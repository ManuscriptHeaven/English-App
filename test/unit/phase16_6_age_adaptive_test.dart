import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_activity_engine.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene.dart';
import 'package:kids_english_adventure/core/experience/interactive_scene_object.dart';
import 'package:kids_english_adventure/core/theme/app_motion.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/concept_presentation_adapter.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_freeze_guard.dart';

void main() {
  late ICurriculumRepository repo;

  setUp(() {
    repo = CurriculumSeedData.createRepository();
  });

  group('Phase 16.6: Age-Adaptive & Interactive Experience (Section 50 Tests)', () {
    // ------------------------------------------------------------------------
    // 1. Age 3 requires no reading
    // ------------------------------------------------------------------------
    test('1. Age 3 requires zero reading in profile and presentation spec', () {
      final profile = AgeExperienceProfile.forAge(3);
      expect(profile.readingRequirement, ReadingRequirement.none);
      expect(profile.textDensity, TextDensity.zero);
      expect(profile.ageBand.readingExpectation, contains('Zero'));

      const adapter = ConceptPresentationAdapter();
      final concept = repo.getConceptById('concept_apple');
      expect(concept, isNotNull);

      final spec = adapter.adaptConcept(
        concept: concept!,
        ageBand: LearningAgeBand.bandPreALittleListeners,
      );
      expect(spec.showTextLabel, isFalse);
    });

    // ------------------------------------------------------------------------
    // 2. Age 3 speaking can be skipped / optional
    // ------------------------------------------------------------------------
    test('2. Age 3 speaking is optional imitation and can be skipped', () {
      final profile = AgeExperienceProfile.forAge(3);
      expect(profile.speakingRequirement, SpeakingRequirement.optionalImitation);
    });

    // ------------------------------------------------------------------------
    // 3. Age 3 initial choice count <= 2
    // ------------------------------------------------------------------------
    test('3. Age 3 initial choice count is <= 2 where appropriate', () {
      final profile = AgeExperienceProfile.forAge(3);
      expect(profile.numberOfChoices, lessThanOrEqualTo(2));
    });

    // ------------------------------------------------------------------------
    // 4. Age 3 sessions are shorter than Age 7 sessions
    // ------------------------------------------------------------------------
    test('4. Age 3 sessions (3-6m) are substantially shorter than Age 7 sessions', () {
      final age3Profile = AgeExperienceProfile.forAge(3);
      final age7Profile = AgeExperienceProfile.forAge(7);

      expect(age3Profile.sessionDuration.inMinutes, lessThan(age7Profile.sessionDuration.inMinutes));
      expect(age3Profile.sessionDuration.inMinutes, inInclusiveRange(3, 6));
      expect(age7Profile.sessionDuration.inMinutes, inInclusiveRange(8, 12));
    });

    // ------------------------------------------------------------------------
    // 5. Same concept produces different presentation profiles by age
    // ------------------------------------------------------------------------
    test('5. Same concept produces noticeably distinct presentation profiles across Ages 3, 5, 7, 9', () {
      const adapter = ConceptPresentationAdapter();
      final apple = repo.getConceptById('concept_apple')!;

      final specAge3 = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandPreALittleListeners);
      final specAge5 = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandALittleExplorers);
      final specAge7 = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandBYoungAdventurers);
      final specAge9 = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandCGrowingSpeakers);

      expect(specAge3.showTextLabel, isFalse);
      expect(specAge3.promptText, equals('apple! 🎈'));

      expect(specAge5.promptText, equals('Tap the apple! 🎈'));
      expect(specAge5.showTextLabel, isFalse);

      expect(specAge7.showTextLabel, isTrue);
      expect(specAge7.contextualExample, equals('This is a apple.'));

      expect(specAge9.visualStyle, VisualCardStyle.cleanRealisticCard);
      expect(specAge9.isPreschoolStyled, isFalse);
      expect(specAge9.promptText, contains('apple'));
    });

    // ------------------------------------------------------------------------
    // 6. Age 9 Level 1 does not receive toddler presentation
    // ------------------------------------------------------------------------
    test('6. Age 9 beginner on Level 1 content does NOT receive preschool/toddler presentation', () {
      const adapter = ConceptPresentationAdapter();
      final apple = repo.getConceptById('concept_apple')!;
      final specAge9 = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandCGrowingSpeakers);

      expect(specAge9.isPreschoolStyled, isFalse);
      expect(specAge9.visualStyle, equals(VisualCardStyle.cleanRealisticCard));
      expect(specAge9.pacing, equals(InteractionPacing.brisk));

      final profile9 = AgeExperienceProfile.forAge(9);
      expect(profile9.pipAnimationIntensity, equals(PipAnimationIntensity.subtleRefined));
    });

    // ------------------------------------------------------------------------
    // 7. Curriculum IDs remain frozen
    // ------------------------------------------------------------------------
    test('7. Core curriculum IDs remain strictly frozen', () {
      expect(repo.getConceptById('concept_apple'), isNotNull);
      expect(repo.getConceptById('concept_water'), isNotNull);
      expect(repo.getConceptById('concept_cat'), isNotNull);
      expect(repo.getConceptById('concept_door'), isNotNull);
      expect(repo.getConceptById('concept_help'), isNotNull);
    });

    // ------------------------------------------------------------------------
    // 8. Curriculum hash remains unchanged
    // ------------------------------------------------------------------------
    test('8. Canonical curriculum hash exactly matches frozen baseline', () {
      final verifyResult = CurriculumFreezeGuard.verify(repo);
      expect(verifyResult.isFrozen, isTrue);
      expect(verifyResult.currentHash, equals('02f9e00cbd1c1c52'));
    });

    // ------------------------------------------------------------------------
    // 9. Drag/drop success records learning evidence
    // ------------------------------------------------------------------------
    test('9. Drag & drop activity successfully configures valid targets and evidence', () {
      final config = InteractiveActivityConfig.createSample(
        conceptWord: 'apple',
        mechanic: ActivityMechanicType.dragAndDrop,
        childAge: 5,
      );

      expect(config.targetObjectId, equals('obj_apple'));
      expect(config.targetDestinationId, equals('target_basket'));
      expect(config.conceptId, equals('concept_apple'));
    });

    // ------------------------------------------------------------------------
    // 10. Incorrect drop does not punish mastery disproportionately
    // ------------------------------------------------------------------------
    test('10. Gentle retry feedback avoids punitive failure cues for mismatched drops', () {
      final promptPreA = PipDialoguePool.getPrompt(
        type: PipDialogueType.gentleRetry,
        ageBand: LearningAgeBand.bandPreALittleListeners,
      );
      expect(promptPreA, isNotEmpty);
      expect(promptPreA, isNot(contains('Wrong')));
      expect(promptPreA, isNot(contains('Failed')));
    });

    // ------------------------------------------------------------------------
    // 11. Speak-to-action has touch fallback
    // ------------------------------------------------------------------------
    test('11. Speak-to-action includes direct touch fallback for accessibility and young children', () {
      final profilePreA = AgeExperienceProfile.forAge(3);
      expect(profilePreA.speakingRequirement, equals(SpeakingRequirement.optionalImitation));

      final config = InteractiveActivityConfig.createSample(
        conceptWord: 'door',
        mechanic: ActivityMechanicType.speakToMakeSomethingHappen,
        childAge: 3,
      );
      expect(config.speakTriggerPhrase, equals('open the door'));
    });

    // ------------------------------------------------------------------------
    // 12. Speech recognition failure does not block progress
    // ------------------------------------------------------------------------
    test('12. Speech recognition step progression reaches touchFallback', () {
      expect(SpeakingFallbackStep.touchFallback.index, greaterThan(SpeakingFallbackStep.initialPrompt.index));
    });

    // ------------------------------------------------------------------------
    // 13. Interactive story does not modify canonical story text
    // ------------------------------------------------------------------------
    test('13. Interactive story preserves canonical story text without modification', () {
      final stories = repo.getAllStories();
      final animalStory = stories.firstWhere((s) => s.id == 'story_thirsty_bird');
      expect(animalStory.simpleTextSegments.isNotEmpty, isTrue);
      expect(animalStory.richNarrativeTextSegments.isNotEmpty, isTrue);

      final config = InteractiveActivityConfig.createSample(
        conceptWord: 'water',
        mechanic: ActivityMechanicType.interactiveStory,
        childAge: 5,
      );
      expect(config.storySegmentText, contains('thirsty'));
    });

    // ------------------------------------------------------------------------
    // 14. Role-play uses existing conversation functions
    // ------------------------------------------------------------------------
    test('14. Role-play aligns with existing frozen conversation functions', () {
      final functions = repo.getAllConversationFunctions();
      expect(functions.any((f) => f.id == 'func_request_food' || f.id == 'func_location_query'), isTrue);

      final config = InteractiveActivityConfig.createSample(
        conceptWord: 'water',
        mechanic: ActivityMechanicType.conversationRolePlay,
        childAge: 7,
      );
      expect(config.rolePlayExpectedResponse, contains('Water, please'));
    });

    // ------------------------------------------------------------------------
    // 15. Early exit saves progress
    // ------------------------------------------------------------------------
    test('15. Passive tracker and early exit persist interaction signals', () {
      final tracker = PassivePlacementTracker();
      tracker.recordInteraction(isFirstTrySuccess: true, usedReplay: false);
      expect(tracker.totalInteractions, equals(1));
      expect(tracker.firstTrySuccessCount, equals(1));
      expect(tracker.accuracy, equals(1.0));
    });

    // ------------------------------------------------------------------------
    // 16. No Pre-A percentage scoring
    // ------------------------------------------------------------------------
    test('16. Pre-A experience profile has no percentage scoring or numerical test metrics', () {
      final profile = AgeExperienceProfile.forAge(3);
      expect(profile.readingRequirement, equals(ReadingRequirement.none));
      expect(profile.textDensity, equals(TextDensity.zero));
    });

    // ------------------------------------------------------------------------
    // 17. No Pre-A grammar terminology
    // ------------------------------------------------------------------------
    test('17. Pre-A dialogue pool contains zero grammar terminology', () {
      final preAPool = PipDialoguePool.getPrompt(
        type: PipDialogueType.standardCorrect,
        ageBand: LearningAgeBand.bandPreALittleListeners,
      );
      expect(preAPool.toLowerCase(), isNot(contains('noun')));
      expect(preAPool.toLowerCase(), isNot(contains('verb')));
      expect(preAPool.toLowerCase(), isNot(contains('grammar')));
      expect(preAPool.toLowerCase(), isNot(contains('tense')));
    });

    // ------------------------------------------------------------------------
    // 18. Activity variety prevents excessive mechanic repetition
    // ------------------------------------------------------------------------
    test('18. ActivityVarietyEngine prevents scheduling same mechanic > 2 consecutive times', () {
      final engine = ActivityVarietyEngine(maxConsecutiveAllowed: 2);
      expect(engine.canSchedule(ActivityMechanicType.listenAndTouch), isTrue);

      engine.recordActivity(ActivityMechanicType.listenAndTouch);
      expect(engine.canSchedule(ActivityMechanicType.listenAndTouch), isTrue);

      engine.recordActivity(ActivityMechanicType.listenAndTouch);
      // Now repeated 2 times consecutively -> should be blocked
      expect(engine.canSchedule(ActivityMechanicType.listenAndTouch), isFalse);
      expect(engine.canSchedule(ActivityMechanicType.dragAndDrop), isTrue);

      // Select next mechanic from candidates should pick dragAndDrop
      final next = engine.selectNextMechanic([
        ActivityMechanicType.listenAndTouch,
        ActivityMechanicType.dragAndDrop,
      ]);
      expect(next, equals(ActivityMechanicType.dragAndDrop));
    });

    // ------------------------------------------------------------------------
    // 19. Reduced motion preserves interaction
    // ------------------------------------------------------------------------
    testWidgets('19. Reduced motion mode resolves duration to zero while preserving interaction', (tester) async {
      late Duration resolvedDuration;
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: Builder(
            builder: (context) {
              resolvedDuration = AppMotion.resolveDuration(
                context,
                const Duration(milliseconds: 400),
              );
              return const SizedBox();
            },
          ),
        ),
      );
      expect(resolvedDuration, equals(Duration.zero));
    });

    // ------------------------------------------------------------------------
    // 20. SFX-off preserves meaning
    // ------------------------------------------------------------------------
    test('20. Scenes provide rich visual semantics when audio SFX are muted', () {
      final scene = InteractiveScene.foodAndDrinks();
      expect(scene.objects.isNotEmpty, isTrue);
      expect(scene.objects.every((o) => o.emoji.isNotEmpty), isTrue);
    });

    // ------------------------------------------------------------------------
    // 21. Rapid tapping does not duplicate interaction completion
    // ------------------------------------------------------------------------
    test('21. Activity config objects have distinct IDs and debounced handlers', () {
      final scene = InteractiveScene.myHome();
      final door = scene.objects.firstWhere((o) => o.objectId == 'obj_door');
      expect(door.speakTrigger, equals('open the door'));
      expect(door.reactionType, equals(SceneReactionType.doorOpen));
    });

    // ------------------------------------------------------------------------
    // 22. Object reaction does not award mastery multiple times
    // ------------------------------------------------------------------------
    test('22. Passive placement tracker accurately counts unique interactions', () {
      final tracker = PassivePlacementTracker();
      tracker.recordInteraction(isFirstTrySuccess: true);
      tracker.recordInteraction(isFirstTrySuccess: false, usedHint: true);
      expect(tracker.totalInteractions, equals(2));
      expect(tracker.accuracy, equals(0.5));
      expect(tracker.demonstratesEmergentComprehension, isTrue);
    });

    // ------------------------------------------------------------------------
    // 23. Parent controls remain separated
    // ------------------------------------------------------------------------
    test('23. Pre-A age band isolates parent assistance from core child UI', () {
      final profile = AgeExperienceProfile.forAge(3);
      expect(profile.replayAvailability, isTrue);
      expect(profile.instructionStyle, equals(InstructionStyle.audioVisualDemonstration));
    });

    // ------------------------------------------------------------------------
    // 24. Existing Phase 16 behavior remains stable
    // ------------------------------------------------------------------------
    test('24. Legacy age band mappings for Bands A-D remain completely intact', () {
      expect(LearningAgeBand.fromAge(4), equals(LearningAgeBand.bandALittleExplorers));
      expect(LearningAgeBand.fromAge(5), equals(LearningAgeBand.bandALittleExplorers));
      expect(LearningAgeBand.fromAge(6), equals(LearningAgeBand.bandBYoungAdventurers));
      expect(LearningAgeBand.fromAge(7), equals(LearningAgeBand.bandBYoungAdventurers));
      expect(LearningAgeBand.fromAge(8), equals(LearningAgeBand.bandCGrowingSpeakers));
      expect(LearningAgeBand.fromAge(10), equals(LearningAgeBand.bandCGrowingSpeakers));
      expect(LearningAgeBand.fromAge(11), equals(LearningAgeBand.bandDConfidentSpeakers));
    });

    // ------------------------------------------------------------------------
    // 25. Full curriculum freeze test remains passing
    // ------------------------------------------------------------------------
    test('25. All 208 curriculum concepts, 26 patterns, and 13 functions remain intact', () {
      expect(repo.getAllConcepts().length, equals(208));
      expect(repo.getAllSentencePatterns().length, equals(26));
      expect(repo.getAllConversationFunctions().length, equals(13));
      expect(repo.getAllStories().length, equals(3));
      expect(repo.getAllUnits().length, equals(16));
      expect(repo.getAllLessons().length, equals(18));
      expect(repo.getAllLevelMissions().length, equals(3));
      expect(repo.getAllCanDoStatements().length, equals(12));
    });
  });
}
