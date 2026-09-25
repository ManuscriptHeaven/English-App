import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/content_review_status.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/concept_presentation_adapter.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_validator_expanded.dart';

void main() {
  group('Phase 15.6: Curriculum Content Refinement Verification Tests', () {
    late CurriculumRepository repository;

    setUp(() {
      repository = CurriculumSeedData.createRepository();
    });

    test('1. Repository-derived counts are consistent and fully documented', () {
      final allConcepts = repository.getAllConcepts();
      final l1Concepts = allConcepts.where((c) => c.levelOrder == 1).toList();
      final l2Concepts = allConcepts.where((c) => c.levelOrder == 2).toList();
      final patterns = repository.getAllSentencePatterns();
      final functions = repository.getAllConversationFunctions();
      final units = repository.getAllUnits();
      final lessons = repository.getAllLessons();
      final stories = repository.getAllStories();
      final missions = repository.getAllLevelMissions();

      expect(l1Concepts.length, 144);
      expect(l2Concepts.length, 64);
      expect(patterns.length, 26);
      expect(functions.length, 13);
      expect(units.length, 16);
      expect(lessons.length, 18);
      expect(stories.length, 3);
      expect(missions.length, 3);
    });

    test('2. Sentence patterns use natural child contractions instead of stiff textbook syntax', () {
      final patterns = repository.getAllSentencePatterns();
      final templates = patterns.map((p) => p.template).toList();

      expect(templates.contains("I don't like {item}."), isTrue);
      expect(templates.contains("I can't {action} yet."), isTrue);

      for (final template in templates) {
        expect(template.contains('can not'), isFalse,
            reason: "Templates must use can't, never can not");
        expect(template.contains('I do not like'), isFalse,
            reason: "Preference pattern must use natural I don't like");
      }

      final welcomeConcept = repository.getConceptById('concept_p2_you_are_welcome');
      expect(welcomeConcept, isNotNull);
      expect(welcomeConcept!.canonicalText, "You're welcome");
    });

    test('3. Presentation adapter contextual sentences and prompts are pure child English', () {
      const adapter = ConceptPresentationAdapter();
      final water = repository.getConceptById('concept_water')!;
      final apple = repository.getConceptById('concept_apple')!;
      final elephant = repository.getConceptById('concept_elephant')!;

      final bandCWater = adapter.adaptConcept(concept: water, ageBand: LearningAgeBand.bandCGrowingSpeakers);
      expect(bandCWater.contextualExample, 'We drink clean water every day.');
      expect(bandCWater.contextualExample.contains('essential for life'), isFalse);
      expect(bandCWater.promptText, 'What is this? Say "water".');
      expect(bandCWater.promptText.contains('Identify and pronounce'), isFalse);

      final bandCApple = adapter.adaptConcept(concept: apple, ageBand: LearningAgeBand.bandCGrowingSpeakers);
      expect(bandCApple.contextualExample, 'Apples are sweet and good to eat.');

      final bandCElephant = adapter.adaptConcept(concept: elephant, ageBand: LearningAgeBand.bandCGrowingSpeakers);
      expect(bandCElephant.contextualExample, 'The elephant is a big, gentle animal.');
      expect(bandCElephant.contextualExample.contains('largest land animal'), isFalse);

      final bandDWater = adapter.adaptConcept(concept: water, ageBand: LearningAgeBand.bandDConfidentSpeakers);
      expect(bandDWater.promptText, 'Can you use "water" in a sentence?');
      expect(bandDWater.pedagogicalHint, 'Try saying a full sentence with "water".');
    });

    test('4. Pip dialogue pools avoid robotic grading jargon and trivial religious invocations', () {
      final forbiddenJargon = [
        'synthesize',
        'auditory recognition',
        'fluent mastery',
        'discourse',
        'accurate syntax',
        'pedagogical',
      ];

      for (final bandEntry in PipDialoguePool.pools.entries) {
        for (final typeEntry in bandEntry.value.entries) {
          for (final line in typeEntry.value) {
            final lower = line.toLowerCase();
            for (final jargon in forbiddenJargon) {
              expect(lower.contains(jargon), isFalse,
                  reason: 'Pip line "$line" contains forbidden jargon "$jargon"');
            }
            expect(lower.contains('mashaallah'), isFalse,
                reason: 'Pip pool must not trigger MashaAllah on trivial correct taps');
            expect(lower.contains('alhamdulillah'), isFalse,
                reason: 'Pip pool must not trigger Alhamdulillah on trivial correct taps');
          }
        }
      }
    });

    test('5. Isolated concepts expanded with Level 2 collocations or deferred', () {
      final l2Texts = repository
          .getAllConcepts()
          .where((c) => c.levelOrder == 2)
          .map((c) => c.canonicalText.toLowerCase())
          .toSet();

      expect(l2Texts.contains('big camel'), isTrue);
      expect(l2Texts.contains('yellow duck'), isTrue);
      expect(l2Texts.contains('small goat'), isTrue);
      expect(l2Texts.contains('brown cat'), isTrue);
      expect(l2Texts.contains('eat rice'), isTrue);
      expect(l2Texts.contains('eat cheese'), isTrue);
      expect(l2Texts.contains('clean socks'), isTrue);
      expect(l2Texts.contains('blue shirt'), isTrue);
      expect(l2Texts.contains('bright moon'), isTrue);
      expect(l2Texts.contains('green grass'), isTrue);
      expect(l2Texts.contains('purple flower'), isTrue);
      expect(l2Texts.contains('pink flower'), isTrue);

      expect(l2Texts.contains('water, please'), isTrue);
      expect(l2Texts.contains('help me, please'), isTrue);
      expect(l2Texts.contains('on the table'), isTrue);
      expect(l2Texts.contains('on the desk'), isTrue);
      expect(l2Texts.contains('in the sky'), isTrue);
      expect(l2Texts.contains('here you are'), isTrue);
      expect(l2Texts.contains('my turn'), isTrue);
      expect(l2Texts.contains("let's play"), isTrue);
      expect(l2Texts.contains("i'm fine"), isTrue);

      expect(repository.getConceptById('concept_trousers'), isNull);
      expect(repository.getConceptById('concept_dress'), isNull);
    });

    test('6. Stories feature separated simple and rich text segments without moralizing lectures', () {
      final stories = repository.getAllStories();
      expect(stories.length, 3);

      for (final story in stories) {
        expect(story.simpleTextSegments.isNotEmpty, isTrue,
            reason: 'Story ${story.id} must have simple text segments');
        expect(story.richNarrativeTextSegments.isNotEmpty, isTrue,
            reason: 'Story ${story.id} must have rich narrative text segments');
        expect(story.reviewStatus, ContentReviewStatus.pendingQualifiedIslamicReview,
            reason: 'Story ${story.id} must be marked pendingQualifiedIslamicReview');
      }

      final thirstyBird = repository.getStoryById('story_thirsty_bird')!;
      expect(thirstyBird.simpleTextSegments, [
        'It is hot.',
        'The sun is hot.',
        'A bird is thirsty.',
        'The bird wants water.',
        'Here is water.',
        'The bird drinks water.',
        'The bird is happy.',
      ]);

      final lastLine = thirstyBird.textSegments.last;
      expect(lastLine, 'Ayaan smiles as the little bird flies away.');
      expect(lastLine.contains('Caring for gentle creatures brings great joy'), isFalse);
    });

    test('7. Religious and Islamic phrases are marked pendingQualifiedIslamicReview', () {
      final islamicPhrases = [
        'concept_p2_assalamu_alaikum',
        'concept_p2_wa_alaikum_assalam',
        'concept_p2_bismillah',
        'concept_p2_alhamdulillah',
      ];

      for (final id in islamicPhrases) {
        final concept = repository.getConceptById(id);
        expect(concept, isNotNull);
        expect(concept!.reviewStatus, ContentReviewStatus.pendingQualifiedIslamicReview,
            reason: 'Concept $id must be pendingQualifiedIslamicReview');
      }
    });

    test('8. Multi-stage Can-Do statements and 8-world Level 1 coverage', () {
      final canDoMap = {for (final c in repository.getAllCanDoStatements()) c.id: c};

      expect(canDoMap['cando_l2_polite']!.text, contains('Stage 1'));
      expect(canDoMap['cando_l3_requests']!.text, contains('Stage 2'));

      final l1Units = repository.getAllUnits().where((u) => u.levelId == 'level_1_first_words').toList();
      final l1WorldIds = l1Units.map((u) => u.worldId).toSet();

      expect(l1WorldIds.contains('world_family'), isTrue);
      expect(l1WorldIds.contains('world_home'), isTrue);
      expect(l1WorldIds.contains('world_food'), isTrue);
      expect(l1WorldIds.contains('world_animal'), isTrue);
      expect(l1WorldIds.contains('world_school'), isTrue);
      expect(l1WorldIds.contains('world_play'), isTrue);
      expect(l1WorldIds.contains('world_day'), isTrue);
      expect(l1WorldIds.contains('world_nature'), isTrue);
      expect(l1WorldIds.length, 8, reason: 'Every world has a foundational Level 1 entry unit');
    });

    test('9. Expanded curriculum validator passes refined repository with ZERO errors', () {
      final report = CurriculumValidatorExpanded.validate(repository);
      expect(report.isValid, isTrue, reason: 'Validation errors: ${report.errors}');
      expect(report.errors.isEmpty, isTrue);
    });
  });
}
