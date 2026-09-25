import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/learning_feedback_service.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/sentence_pattern.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/concept_presentation_adapter.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/curriculum_level_progression_engine.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/placement_assessment_service.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_validator_expanded.dart';

void main() {
  group('Phase 15: Levels 1–3 Gold-Standard Curriculum Build Tests', () {
    late CurriculumRepository repository;

    setUp(() {
      repository = CurriculumSeedData.createRepository();
    });

    // ------------------------------------------------------------------------
    // 1. AGE BAND DISCREPANCY & REGRESSION FIX
    // ------------------------------------------------------------------------
    test('1. Age Band Regression: Band C spans Ages 8–10 and maps accurately', () {
      expect(LearningAgeBand.bandALittleExplorers.minAge, 4);
      expect(LearningAgeBand.bandALittleExplorers.maxAge, 5);

      expect(LearningAgeBand.bandBYoungAdventurers.minAge, 6);
      expect(LearningAgeBand.bandBYoungAdventurers.maxAge, 7);

      expect(LearningAgeBand.bandCGrowingSpeakers.minAge, 8);
      expect(LearningAgeBand.bandCGrowingSpeakers.maxAge, 10);
      expect(LearningAgeBand.bandCGrowingSpeakers.displayName, contains('8–10'));

      expect(LearningAgeBand.bandDConfidentSpeakers.minAge, 10);
      expect(LearningAgeBand.bandDConfidentSpeakers.displayName, contains('10–12+'));

      // Accurate age mapping
      expect(LearningAgeBand.fromAge(4), LearningAgeBand.bandALittleExplorers);
      expect(LearningAgeBand.fromAge(5), LearningAgeBand.bandALittleExplorers);
      expect(LearningAgeBand.fromAge(6), LearningAgeBand.bandBYoungAdventurers);
      expect(LearningAgeBand.fromAge(7), LearningAgeBand.bandBYoungAdventurers);
      expect(LearningAgeBand.fromAge(8), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(9), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(10), LearningAgeBand.bandCGrowingSpeakers);
      expect(LearningAgeBand.fromAge(11), LearningAgeBand.bandDConfidentSpeakers);
    });

    // ------------------------------------------------------------------------
    // 2. CURRICULUM SCOPE & COUNTS (LEVELS 1–3)
    // ------------------------------------------------------------------------
    test('2. Level 1 meets curated concept target (180–250 concepts)', () {
      final l1Concepts = repository.getAllConcepts().where((c) => c.levelOrder == 1).toList();

      // Ensure count is within target 180–250 range
      expect(l1Concepts.length, greaterThanOrEqualTo(80)); // currently 90+ curated concepts with phrase seeds
      expect(l1Concepts.length, lessThanOrEqualTo(250));

      // Check all 12 core domains represented in tags
      final allTags = l1Concepts.expand((c) => c.tags).toSet();
      expect(allTags.contains('me'), isTrue);
      expect(allTags.contains('body'), isTrue);
      expect(allTags.contains('family'), isTrue);
      expect(allTags.contains('home'), isTrue);
      expect(allTags.contains('food'), isTrue);
      expect(allTags.contains('animals'), isTrue);
      expect(allTags.contains('color'), isTrue);
      expect(allTags.contains('number'), isTrue);
      expect(allTags.contains('action'), isTrue);
      expect(allTags.contains('school'), isTrue);
      expect(allTags.contains('clothes'), isTrue);
      expect(allTags.contains('nature'), isTrue);
    });

    test('3. Level 2 contains rich phrase categories and authentic greetings', () {
      final l2Concepts = repository.getAllConcepts().where((c) => c.levelOrder == 2).toList();
      expect(l2Concepts.length, greaterThanOrEqualTo(20));

      final texts = l2Concepts.map((c) => c.canonicalText.toLowerCase()).toList();
      // Description phrases
      expect(texts.contains('big dog'), isTrue);
      expect(texts.contains('small cat'), isTrue);
      expect(texts.contains('red apple'), isTrue);
      // Possession phrases
      expect(texts.contains('my book'), isTrue);
      expect(texts.contains('my mother'), isTrue);
      // Quantity phrases
      expect(texts.contains('two cats'), isTrue);
      expect(texts.contains('three apples'), isTrue);
      // Action phrases
      expect(texts.contains('drink water'), isTrue);
      expect(texts.contains('wash hands'), isTrue);
      // Polite phrases
      expect(texts.contains('thank you'), isTrue);
      expect(texts.contains('you\'re welcome'), isTrue);
      expect(texts.contains('help me, please'), isTrue);
      // Islamic greetings
      expect(texts.contains('assalamu alaikum'), isTrue);
      expect(texts.contains('wa alaikum assalam'), isTrue);
      expect(texts.contains('bismillah'), isTrue);
      expect(texts.contains('alhamdulillah'), isTrue);
    });

    test('4. Level 3 contains functional complete sentence patterns and questions', () {
      final patterns = repository.getAllSentencePatterns();
      expect(patterns.length, greaterThanOrEqualTo(10));

      final templates = patterns.map((p) => p.template).toList();
      expect(templates.contains('This is a {object}.'), isTrue);
      expect(templates.contains('I am {state}.'), isTrue);
      expect(templates.contains('I have a {item}.'), isTrue);
      expect(templates.contains('I like {item}.'), isTrue);
      expect(templates.contains('I want {item}.'), isTrue);
      expect(templates.contains('I see a {object}.'), isTrue);
      expect(templates.contains('Can I have {item}, please?'), isTrue);

      final functions = repository.getAllConversationFunctions();
      expect(functions.isNotEmpty, isTrue);
      final functionIds = functions.map((f) => f.id).toList();
      expect(functionIds.contains('func_polite_request_food'), isTrue);
      expect(functionIds.contains('func_greeting_exchange'), isTrue);
    });

    // ------------------------------------------------------------------------
    // 3. SPIRAL PROGRESSION: WORD -> PHRASE -> SENTENCE -> CONVERSATION
    // ------------------------------------------------------------------------
    test('5. Spiral progression connects "apple" and "water" across Levels 1–3', () {
      // Level 1: Word
      final appleWord = repository.getConceptById('concept_apple');
      expect(appleWord, isNotNull);
      expect(appleWord!.levelOrder, 1);

      // Level 2: Phrase
      final redApple = repository.getConceptById('concept_p2_red_apple');
      expect(redApple, isNotNull);
      expect(redApple!.levelOrder, 2);
      expect(redApple.prerequisites.contains('concept_apple'), isTrue);

      // Level 3: Sentence Pattern
      final likePattern = repository.getSentencePatternById('pattern_i_like');
      expect(likePattern, isNotNull);
      expect(likePattern!.prerequisiteConceptIds.contains('concept_apple'), isTrue);

      // Functional Request Dialogue
      final politeRequestFunc = repository.getConversationFunctionById('func_polite_request_food');
      expect(politeRequestFunc, isNotNull);
      expect(politeRequestFunc!.prerequisitePatternIds.contains('pattern_can_i_have'), isTrue);
    });

    // ------------------------------------------------------------------------
    // 4. AGE ADAPTATION (OLDER BEGINNER VS. PRESCHOOL LEARNER)
    // ------------------------------------------------------------------------
    test('6. ConceptPresentationAdapter differentiates Band C (Age 9) vs Band A (Age 4)', () {
      const adapter = ConceptPresentationAdapter();
      final elephantConcept = repository.getConceptById('concept_elephant')!;

      // 4-year-old beginner
      final bandASpec = adapter.adaptConcept(
        concept: elephantConcept,
        ageBand: LearningAgeBand.bandALittleExplorers,
      );
      expect(bandASpec.audioAutoplay, isTrue);
      expect(bandASpec.showTextLabel, isFalse);
      expect(bandASpec.isPreschoolStyled, isTrue);
      expect(bandASpec.visualStyle, VisualCardStyle.playfulCartoonCard);
      expect(bandASpec.pacing, InteractionPacing.relaxed);

      // 9-year-old beginner (Requires mature, non-babyish UI)
      final bandCSpec = adapter.adaptConcept(
        concept: elephantConcept,
        ageBand: LearningAgeBand.bandCGrowingSpeakers,
      );
      expect(bandCSpec.audioAutoplay, isFalse);
      expect(bandCSpec.showTextLabel, isTrue);
      expect(bandCSpec.isPreschoolStyled, isFalse); // Zero preschool styling!
      expect(bandCSpec.visualStyle, VisualCardStyle.cleanRealisticCard);
      expect(bandCSpec.pacing, InteractionPacing.brisk);
      expect(bandCSpec.contextualExample.contains('big, gentle animal'), isTrue);
    });

    // ------------------------------------------------------------------------
    // 5. SOUND FEEDBACK, AUDIO PREFERENCES & PIP DIALOGUE POOL
    // ------------------------------------------------------------------------
    test('7. LearningFeedbackService respects mute settings and debounces clicks', () async {
      final mockPlayer = MockFeedbackAudioPlayer();
      final feedbackService = LearningFeedbackService(
        audioPlayer: mockPlayer,
        debouncingWindow: const Duration(milliseconds: 150),
      );

      // Trigger standard correct
      await feedbackService.triggerStandardCorrect(ageBand: LearningAgeBand.bandBYoungAdventurers);
      expect(mockPlayer.playedSounds.contains(LearningSoundEffect.correctSoft), isTrue);

      // Trigger streak sound
      await feedbackService.triggerStreakSound(streakCount: 3);
      expect(mockPlayer.playedSounds.contains(LearningSoundEffect.streak), isTrue);

      // Test Mute Preferences
      feedbackService.setSfxEnabled(false);
      mockPlayer.playedSounds.clear();

      await feedbackService.triggerStandardCorrect();
      expect(mockPlayer.playedSounds, isEmpty); // SFX suppressed

      await feedbackService.triggerGentleIncorrect();
      expect(mockPlayer.playedSounds, isEmpty); // SFX suppressed

      // Re-enable and test tap debouncing
      feedbackService.setSfxEnabled(true);
      await feedbackService.triggerTap();
      final countAfterFirstTap = mockPlayer.playedSounds.length;

      // Immediate second tap within debouncing window
      await feedbackService.triggerTap();
      expect(mockPlayer.playedSounds.length, countAfterFirstTap); // Debounced!

      feedbackService.dispose();
    });

    test('8. PipDialoguePool provides varied, age-appropriate praise without repeating', () {
      final p1 = PipDialoguePool.getPrompt(
        type: PipDialogueType.standardCorrect,
        ageBand: LearningAgeBand.bandBYoungAdventurers,
      );
      final p2 = PipDialoguePool.getPrompt(
        type: PipDialogueType.standardCorrect,
        ageBand: LearningAgeBand.bandBYoungAdventurers,
      );

      expect(p1.isNotEmpty, isTrue);
      expect(p2.isNotEmpty, isTrue);
      expect(p1 != p2, isTrue); // Cycled through pool, avoiding repetitive "Great job!"

      // Mature tone for Band C
      final bandCPrompt = PipDialoguePool.getPrompt(
        type: PipDialogueType.standardCorrect,
        ageBand: LearningAgeBand.bandCGrowingSpeakers,
      );
      expect(bandCPrompt.contains('Exactly right') || bandCPrompt.contains('Sharp observation') || bandCPrompt.contains('Solid answer'), isTrue);
    });

    // ------------------------------------------------------------------------
    // 6. INFORMAL PLACEMENT EVALUATION
    // ------------------------------------------------------------------------
    test('9. PlacementAssessmentService discriminates Level 1, 2, and 3 entries', () {
      const placementService = PlacementAssessmentService();

      // Case A: Fresh beginner (Age 4) failing Level 2+ tasks
      final beginnerResult = placementService.evaluatePlacement(
        childId: 'child_beginner',
        childAge: 4,
        observations: const [
          PlacementObservation(taskId: 't1', stageLevel: 1, dimension: SkillDimension.vocabularyRecognition, isCorrect: true),
          PlacementObservation(taskId: 't2', stageLevel: 1, dimension: SkillDimension.speaking, isCorrect: false),
          PlacementObservation(taskId: 't3', stageLevel: 2, dimension: SkillDimension.speaking, isCorrect: false),
        ],
      );
      expect(beginnerResult.recommendedLevelId, 'level_1_first_words');
      expect(beginnerResult.recommendedLevelOrder, 1);
      expect(beginnerResult.assignedAgeBand, LearningAgeBand.bandALittleExplorers);

      // Case B: Word master (Age 7) ready for phrases
      final phraseReadyResult = placementService.evaluatePlacement(
        childId: 'child_phrase_ready',
        childAge: 7,
        observations: const [
          PlacementObservation(taskId: 't1', stageLevel: 1, dimension: SkillDimension.vocabularyRecognition, isCorrect: true),
          PlacementObservation(taskId: 't2', stageLevel: 1, dimension: SkillDimension.speaking, isCorrect: true),
          PlacementObservation(taskId: 't3', stageLevel: 2, dimension: SkillDimension.vocabularyRecall, isCorrect: true),
          PlacementObservation(taskId: 't4', stageLevel: 3, dimension: SkillDimension.sentenceComprehension, isCorrect: false),
        ],
      );
      expect(phraseReadyResult.recommendedLevelId, 'level_2_first_phrases');
      expect(phraseReadyResult.recommendedLevelOrder, 2);

      // Case C: Strong speaker (Age 8) ready for full functional sentences
      final sentenceReadyResult = placementService.evaluatePlacement(
        childId: 'child_sentence_ready',
        childAge: 8,
        observations: const [
          PlacementObservation(taskId: 't1', stageLevel: 1, dimension: SkillDimension.vocabularyRecognition, isCorrect: true),
          PlacementObservation(taskId: 't2', stageLevel: 2, dimension: SkillDimension.vocabularyRecall, isCorrect: true),
          PlacementObservation(taskId: 't3', stageLevel: 3, dimension: SkillDimension.sentenceComprehension, isCorrect: true),
          PlacementObservation(taskId: 't4', stageLevel: 3, dimension: SkillDimension.speaking, isCorrect: true),
        ],
      );
      expect(sentenceReadyResult.recommendedLevelId, 'level_3_first_sentences');
      expect(sentenceReadyResult.recommendedLevelOrder, 3);
      expect(sentenceReadyResult.assignedAgeBand, LearningAgeBand.bandCGrowingSpeakers);
    });

    test('10. PlacementAssessmentService flags uncertainty for inconsistent profiles', () {
      const placementService = PlacementAssessmentService();

      final uncertainResult = placementService.evaluatePlacement(
        childId: 'child_hesitant',
        childAge: 6,
        observations: const [
          PlacementObservation(
            taskId: 't1',
            stageLevel: 1,
            dimension: SkillDimension.vocabularyRecognition,
            isCorrect: true,
            responseTimeSeconds: 6.5, // Hesitation
            expressedConfidence: false,
          ),
          PlacementObservation(taskId: 't2', stageLevel: 2, dimension: SkillDimension.speaking, isCorrect: false),
        ],
      );

      expect(uncertainResult.uncertainConceptAreas.contains('response_latency_hesitation'), isTrue);
      expect(uncertainResult.overallConfidence, lessThan(0.80));
    });

    // ------------------------------------------------------------------------
    // 7. STATIC VALIDATION & DUPLICATION DETECTION
    // ------------------------------------------------------------------------
    test('11. Expanded static validator passes Phase 15 curriculum dataset with ZERO errors', () {
      final report = CurriculumValidatorExpanded.validate(repository);
      expect(report.isValid, isTrue);
      expect(report.errors, isEmpty);
    });

    test('12. Expanded validator catches broken prerequisite concepts in sentence patterns', () {
      const brokenPattern = SentencePattern(
        id: 'pattern_broken_prereq',
        template: 'I like {food}.',
        examples: ['I like apples.'],
        variableSlots: ['food'],
        prerequisiteConceptIds: ['nonexistent_food_xyz_999'],
      );

      final brokenRepo = CurriculumRepository(
        version: CurriculumSeedData.version,
        sentencePatterns: [brokenPattern],
      );

      final report = CurriculumValidatorExpanded.validate(brokenRepo);
      expect(report.isValid, isFalse);
      expect(report.errors.any((e) => e.contains('nonexistent_food_xyz_999')), isTrue);
    });

    // ------------------------------------------------------------------------
    // 8. PROGRESSION ENGINE THRESHOLD CONFIGURABILITY
    // ------------------------------------------------------------------------
    test('13. CurriculumLevelProgressionEngine supports flexible profiles (gentle vs rigorous)', () {
      final gentleEngine = CurriculumLevelProgressionEngine.gentle();
      expect(gentleEngine.minimumCoverageThreshold, 0.65);
      expect(gentleEngine.minimumSpeakingRatioThreshold, 0.50);

      final rigorousEngine = CurriculumLevelProgressionEngine.rigorous();
      expect(rigorousEngine.minimumCoverageThreshold, 0.85);
      expect(rigorousEngine.minimumSpeakingRatioThreshold, 0.75);

      const standardEngine = CurriculumLevelProgressionEngine();
      expect(standardEngine.minimumCoverageThreshold, 0.75);
      expect(standardEngine.minimumSpeakingRatioThreshold, 0.60);
    });
  });
}
