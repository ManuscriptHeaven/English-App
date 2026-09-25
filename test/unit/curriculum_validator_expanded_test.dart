import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/content_review_status.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_story.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/religious_content_safety.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/sentence_pattern.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/validation/curriculum_validator_expanded.dart';

void main() {
  group('Phase 14 Expanded Curriculum Static Integrity Validator', () {
    const validator = CurriculumValidatorExpanded();

    test('Seed curriculum dataset passes validation with ZERO errors', () {
      final repository = CurriculumSeedData.createRepository();

      final report = validator.validateAll(repository);
      expect(report.isValid, isTrue);
      expect(report.errors, isEmpty);
    });

    test('Validator detects nonexistent prerequisite concepts', () {
      const brokenConcept = LearningConcept(
        id: 'concept_broken',
        type: ConceptType.vocabulary,
        canonicalText: 'Broken Word',
        meaning: 'Word with missing prereq',
        prerequisites: ['nonexistent_concept_xyz_999'],
      );

      final repository = CurriculumRepository(
        version: CurriculumSeedData.version,
        concepts: [brokenConcept],
      );

      final report = validator.validateAll(repository);
      expect(report.isValid, isFalse);
      expect(report.errors.any((e) => e.contains('nonexistent_concept_xyz_999')), isTrue);
    });

    test('Validator catches prerequisite dependency cycles', () {
      const c1 = LearningConcept(
        id: 'c1',
        type: ConceptType.vocabulary,
        canonicalText: 'Word A',
        meaning: 'Meaning A',
        prerequisites: ['c2'],
      );
      const c2 = LearningConcept(
        id: 'c2',
        type: ConceptType.vocabulary,
        canonicalText: 'Word B',
        meaning: 'Meaning B',
        prerequisites: ['c1'],
      );

      final repository = CurriculumRepository(
        version: CurriculumSeedData.version,
        concepts: [c1, c2],
      );

      final report = validator.validateAll(repository);
      expect(report.isValid, isFalse);
      expect(report.errors.any((e) => e.contains('Circular prerequisite cycle')), isTrue);
    });

    test('Validator catches variable slots in SentencePattern missing from template', () {
      const brokenPattern = SentencePattern(
        id: 'pattern_broken_slot',
        template: 'I like apples.', // Has no slots
        examples: ['I like apples.'],
        variableSlots: ['ghost_slot'], // Declares a slot not in template!
      );

      final repository = CurriculumRepository(
        version: CurriculumSeedData.version,
        sentencePatterns: [brokenPattern],
      );

      final report = validator.validateAll(repository);
      expect(report.isValid, isFalse);
      expect(report.errors.any((e) => e.contains('ghost_slot')), isTrue);
    });

    test('Validator flags religious content safety errors when unreviewed hadith is marked approved', () {
      const unreviewedHadithStory = LearningStory(
        id: 'story_hadith_unreviewed',
        title: 'Story with Hadith',
        worldId: 'world_family',
        unitId: 'unit_family',
        religiousContentType: ReligiousContentType.hadithQuotation,
        reviewStatus: ContentReviewStatus.approved,
        metadata: {
          'reviewedByScholar': false, // Violates scholar review requirement!
        },
      );

      final repository = CurriculumRepository(
        version: CurriculumSeedData.version,
        stories: [unreviewedHadithStory],
      );

      final report = validator.validateAll(repository);
      expect(report.isValid, isFalse);
      expect(report.errors.any((e) => e.contains('scholar review')), isTrue);
    });
  });
}
