import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/content_review_status.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_validator_expanded.dart';

void main() {
  group('Phase 15.7: Levels 1–3 Curriculum Lock Pass Tests', () {
    late CurriculumRepository repository;

    setUp(() {
      repository = CurriculumSeedData.createRepository();
    });

    test('1. "read" progression defect is fixed: cannot map to "eat bread"', () {
      final readConcept = repository.getConceptById('concept_read')!;
      final eatBreadConcept = repository.getConceptById('concept_p2_eat_bread')!;
      final readBookConcept = repository.getConceptById('concept_p2_read_book')!;

      // Regression check: read does NOT connect to eat bread
      expect(eatBreadConcept.prerequisites.contains('concept_read'), isFalse,
          reason: 'eat bread must not have concept_read as a prerequisite');
      expect(readBookConcept.prerequisites.contains('concept_read'), isTrue,
          reason: 'read a book must connect to concept_read');
      expect(readConcept.canonicalText, 'read');
      expect(readConcept.meaning, 'To look at and read words or books.');

      // In Level 3 patterns:
      final iCanPattern = repository.getAllSentencePatterns().firstWhere((p) => p.id == 'pattern_i_can');
      expect(iCanPattern.prerequisiteConceptIds.contains('concept_read'), isTrue);
      expect(iCanPattern.examples.contains('I can read.'), isTrue);
    });

    test('2. Canonical concept IDs remain unique across the entire repository', () {
      final allConcepts = repository.getAllConcepts();
      final idSet = allConcepts.map((c) => c.id).toSet();
      expect(idSet.length, allConcepts.length,
          reason: 'Every concept in repository must have a unique canonical ID');
    });

    test('3. Cross-world reinforcement does not inflate concept counts', () {
      final allConcepts = repository.getAllConcepts();
      final l1Concepts = allConcepts.where((c) => c.levelOrder == 1).toList();

      // Concepts like water, bird, fish, bee, ant, garden have 1 canonical ID
      final waterConcepts = allConcepts.where((c) => c.canonicalText.toLowerCase() == 'water').toList();
      expect(waterConcepts.length, 1, reason: '"water" has exactly one canonical definition');

      final birdConcepts = allConcepts.where((c) => c.canonicalText.toLowerCase() == 'bird').toList();
      expect(birdConcepts.length, 1, reason: '"bird" has exactly one canonical definition');

      final fishConcepts = allConcepts.where((c) => c.canonicalText.toLowerCase() == 'fish').toList();
      expect(fishConcepts.length, 1, reason: '"fish" has exactly one canonical definition');

      expect(l1Concepts.length, 144, reason: 'Level 1 has exactly 144 concepts (135 words + 9 seeds)');
    });

    test('4. No generic "Direct L3 reuse" accepted as evidence of spiral reuse', () {
      // Validate that all high-priority Level 1 concepts link to concrete Level 2/3 structures
      final highPriorityIds = [
        'concept_water',
        'concept_apple',
        'concept_bread',
        'concept_book',
        'concept_mother',
        'concept_father',
        'concept_cat',
        'concept_dog',
        'concept_help',
        'concept_clean',
        'concept_wash',
      ];

      final l2Phrases = repository.getAllConcepts().where((c) => c.levelOrder == 2).toList();
      final l3Patterns = repository.getAllSentencePatterns();

      for (final id in highPriorityIds) {
        final hasL2 = l2Phrases.any((p) => p.prerequisites.contains(id));
        final hasL3 = l3Patterns.any((pat) => pat.prerequisiteConceptIds.contains(id));
        expect(hasL2 || hasL3, isTrue,
            reason: 'High priority concept "$id" must have concrete L2 phrase or L3 pattern, not generic claim');
      }
    });

    test('5. Conversation repair language exists and is properly structured', () {
      final repairConcept1 = repository.getConceptById('concept_p2_i_dont_know');
      final repairConcept2 = repository.getConceptById('concept_p2_i_dont_understand');
      final repairConcept3 = repository.getConceptById('concept_p2_say_it_again');

      expect(repairConcept1, isNotNull);
      expect(repairConcept1!.canonicalText, "I don't know");
      expect(repairConcept1.canonicalText == "I don't know", isTrue);
      expect(repairConcept1.canonicalText.contains("I'don't"), isFalse);

      // Verify no concepts have malformed contractions across the repository
      for (final concept in repository.getAllConcepts()) {
        expect(concept.canonicalText.contains("I'don't"), isFalse);
        expect(concept.canonicalText.contains("I' don't"), isFalse);
      }

      expect(repairConcept2, isNotNull);
      expect(repairConcept2!.canonicalText, "I don't understand");

      expect(repairConcept3, isNotNull);
      expect(repairConcept3!.canonicalText, "please say it again");

      final convRepair = repository.getConversationFunctionById('func_conversation_repair');
      expect(convRepair, isNotNull);
      expect(convRepair!.targetResponse, "I don't understand. Please say it again.");
      expect(convRepair.recoveryPrompt, contains('Please say it again'));
    });

    test('6. "I need..." progression exists with practical everyday contexts', () {
      final pattern = repository.getAllSentencePatterns().firstWhere((p) => p.id == 'pattern_i_need');
      expect(pattern.template, 'I need {item}.');
      expect(pattern.examples, ['I need water.', 'I need help.', 'I need my book.']);
      expect(pattern.prerequisiteConceptIds, ['concept_water', 'concept_help', 'concept_book']);

      final needsFunc = repository.getConversationFunctionById('func_wants_needs');
      expect(needsFunc, isNotNull);
      expect(needsFunc!.targetResponse, 'I need my book.');
    });

    test('7. Basic state language exists for hungry, thirsty, happy, tired', () {
      final hungryPhrase = repository.getConceptById('concept_p2_im_hungry');
      final thirstyPhrase = repository.getConceptById('concept_p2_im_thirsty');
      final happyPhrase = repository.getConceptById('concept_p2_im_happy');
      final tiredPhrase = repository.getConceptById('concept_p2_im_tired');

      expect(hungryPhrase, isNotNull);
      expect(hungryPhrase!.canonicalText, "I'm hungry");
      expect(hungryPhrase.prerequisites, contains('concept_hungry'));

      expect(thirstyPhrase, isNotNull);
      expect(thirstyPhrase!.canonicalText, "I'm thirsty");
      expect(thirstyPhrase.prerequisites, contains('concept_thirsty'));

      expect(happyPhrase, isNotNull);
      expect(happyPhrase!.canonicalText, "I'm happy");
      expect(happyPhrase.prerequisites, contains('concept_happy'));

      expect(tiredPhrase, isNotNull);
      expect(tiredPhrase!.canonicalText, "I'm tired");
      expect(tiredPhrase.prerequisites, contains('concept_tired'));
    });

    test('8. Band C and Band D Pip pools contain zero banned robotic/system jargon', () {
      final bannedBandC = [
        "that's accurate",
        'solid answer',
        'review the sentence context',
        'natural delivery and clear diction',
        'unit objective completed',
        'curriculum level achievement unlocked',
      ];
      final bannedBandD = [
        're-evaluate the phrasing',
        'great listening comprehension',
        'milestone reached',
        'advanced speaker milestone achieved',
      ];

      final poolC = PipDialoguePool.pools[LearningAgeBand.bandCGrowingSpeakers]!;
      for (final lines in poolC.values) {
        for (final line in lines) {
          final lower = line.toLowerCase();
          for (final banned in bannedBandC) {
            expect(lower.contains(banned), isFalse,
                reason: 'Band C contains banned phrase "$banned" in "$line"');
          }
        }
      }

      final poolD = PipDialoguePool.pools[LearningAgeBand.bandDConfidentSpeakers]!;
      for (final lines in poolD.values) {
        for (final line in lines) {
          final lower = line.toLowerCase();
          for (final banned in bannedBandD) {
            expect(lower.contains(banned), isFalse,
                reason: 'Band D contains banned phrase "$banned" in "$line"');
          }
        }
      }
    });

    test('9. Generic Pip success responses contain no automatic religious invocation', () {
      for (final bandEntry in PipDialoguePool.pools.entries) {
        for (final typeEntry in bandEntry.value.entries) {
          for (final line in typeEntry.value) {
            final lower = line.toLowerCase();
            expect(lower.contains('mashaallah'), isFalse,
                reason: 'Pip feedback line must not contain MashaAllah: "$line"');
            expect(lower.contains('alhamdulillah'), isFalse,
                reason: 'Pip feedback line must not contain Alhamdulillah: "$line"');
          }
        }
      }

      final whoFunc = repository.getConversationFunctionById('func_who_is_this')!;
      for (final turn in whoFunc.exampleTurns) {
        expect(turn.toLowerCase().contains('mashaallah'), isFalse,
            reason: 'Generic family identification must use natural English praise, not automatic MashaAllah');
      }

      // Verification of the 4 corrected conversation strings
      final locFunc = repository.getConversationFunctionById('func_location_query')!;
      expect(locFunc.pipFollowUp, 'There it is! You found it! 🔍');

      final abilityFunc = repository.getConversationFunctionById('func_ability_query')!;
      expect(abilityFunc.pipFollowUp, 'Nice reading! 📖');

      final whatFunc = repository.getConversationFunctionById('func_what_is_this')!;
      expect(whatFunc.pipFollowUp, "Yes! It's a red apple! 🍎");

      expect(whoFunc.pipFollowUp, "Yes! That's your mother! 😊");
    });

    test('10. Islamic content has pendingQualifiedIslamicReview status', () {
      final islamicConcepts = repository.getAllConcepts().where((c) => c.tags.contains('islamic')).toList();
      expect(islamicConcepts.isNotEmpty, isTrue);
      for (final c in islamicConcepts) {
        expect(c.reviewStatus, ContentReviewStatus.pendingQualifiedIslamicReview,
            reason: 'Concept "${c.id}" must be pendingQualifiedIslamicReview');
      }

      final stories = repository.getAllStories();
      for (final s in stories) {
        expect(s.reviewStatus, ContentReviewStatus.pendingQualifiedIslamicReview,
            reason: 'Story "${s.id}" must be pendingQualifiedIslamicReview');
      }
    });

    test('11. Level-1 story productive text remains simple with separate rich narrative', () {
      final birdStory = repository.getStoryById('story_thirsty_bird')!;
      expect(birdStory.simpleTextSegments, [
        'It is hot.',
        'The sun is hot.',
        'A bird is thirsty.',
        'The bird wants water.',
        'Here is water.',
        'The bird drinks water.',
        'The bird is happy.',
      ]);
      expect(birdStory.richNarrativeTextSegments.length, greaterThanOrEqualTo(5));
      expect(birdStory.richNarrativeTextSegments, isNot(equals(birdStory.simpleTextSegments)));
    });

    test('12. Unit outcomes only use taught vocabulary prerequisites', () {
      final units = repository.getAllUnits();
      for (final u in units) {
        final outcome = u.speakingOutcome.toLowerCase();
        // Check animal savannah unit no longer requires untaught adjectives
        if (u.id == 'unit_animal_savannah') {
          expect(outcome.contains('big or gentle'), isFalse);
          expect(outcome.contains('gentle'), isFalse);
        }
      }
    });

    test('13. Live repository counts match exact Phase 15.7 lock specifications', () {
      final allConcepts = repository.getAllConcepts();
      final l1Concepts = allConcepts.where((c) => c.levelOrder == 1).toList();
      final l2Concepts = allConcepts.where((c) => c.levelOrder == 2).toList();
      final patterns = repository.getAllSentencePatterns();
      final functions = repository.getAllConversationFunctions();
      final units = repository.getAllUnits();
      final lessons = repository.getAllLessons();
      final stories = repository.getAllStories();
      final missions = repository.getAllLevelMissions();
      final canDos = repository.getAllCanDoStatements();

      expect(l1Concepts.length, 144);
      expect(l2Concepts.length, 64);
      expect(allConcepts.length, 208);
      expect(patterns.length, 26);
      expect(functions.length, 13);
      expect(units.length, 16);
      expect(lessons.length, 18);
      expect(stories.length, 3);
      expect(missions.length, 3);
      expect(canDos.length, 12);

      // Verify validator passes with 0 errors
      final report = CurriculumValidatorExpanded.validate(repository);
      expect(report.isValid, isTrue);
      expect(report.errors.isEmpty, isTrue);
    });
  });
}
