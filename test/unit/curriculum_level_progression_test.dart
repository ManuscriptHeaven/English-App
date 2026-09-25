import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/curriculum/data/seed/curriculum_seed_data.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_concept.dart';
import 'package:kids_english_adventure/features/curriculum/domain/repositories/curriculum_repository.dart';
import 'package:kids_english_adventure/features/curriculum/domain/services/curriculum_level_progression_engine.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Phase 14 Curriculum Level Progression Engine', () {
    late CurriculumRepository repository;
    late CurriculumLevelProgressionEngine progressionEngine;
    final now = DateTime(2026, 9, 10, 12, 0);

    setUp(() {
      repository = CurriculumSeedData.createRepository();
      progressionEngine = const CurriculumLevelProgressionEngine(
        minimumCoverageThreshold: 0.75,
        minimumSpeakingRatioThreshold: 0.60,
      );
    });

    final testChild = ChildProfile(
      id: 'child_1',
      parentId: 'parent_1',
      name: 'Amina',
      age: 6,
      avatar: const Avatar(id: 'av_1', name: 'Amina', assetPath: 'avatar.png'),
      currentCurriculumLevelId: 'level_1_first_words',
    );

    test('Advancement is BLOCKED when concept coverage is below 75%', () {
      final level1 = repository.getLevelById('level_1_first_words')!;
      final level2 = repository.getLevelById('level_2_first_phrases')!;
      final level1Concepts = level1.coreConceptIds
          .map(repository.getConceptById)
          .whereType<LearningConcept>()
          .toList();
      final canDos = repository.getAllCanDoStatements().where((c) => c.levelOrder == 1).toList();

      // Only 2 of 7 concepts familiar
      final masteries = [
        VocabularyMastery(
          childId: 'child_1',
          vocabularyId: 'concept_mother',
          word: 'mother',
          lastSeenAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
          currentLearningState: VocabularyLearningState.mastered,
          masteryScore: 0.90,
          pronunciationAttempts: 5,
          pronunciationSuccesses: 4,
        ),
        VocabularyMastery(
          childId: 'child_1',
          vocabularyId: 'concept_father',
          word: 'father',
          lastSeenAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
          currentLearningState: VocabularyLearningState.familiar,
          masteryScore: 0.80,
          pronunciationAttempts: 4,
          pronunciationSuccesses: 3,
        ),
      ];

      final evaluation = progressionEngine.evaluateLevelReadiness(
        currentLevel: level1,
        nextLevel: level2,
        levelConcepts: level1Concepts,
        masteries: masteries,
        levelCanDoStatements: canDos,
      );

      expect(evaluation.isReadyToAdvance, isFalse);
      expect(evaluation.conceptCoverageRatio < 0.75, isTrue);
      expect(evaluation.educationalReasoning.contains('Needs further practice'), isTrue);
      expect(evaluation.conceptsRemainingInReview.isNotEmpty, isTrue);
    });

    test('Advancement is BLOCKED when speaking evidence ratio is below 60%', () {
      final level1 = repository.getLevelById('level_1_first_words')!;
      final level2 = repository.getLevelById('level_2_first_phrases')!;
      final level1Concepts = level1.coreConceptIds
          .map(repository.getConceptById)
          .whereType<LearningConcept>()
          .toList();
      final canDos = repository.getAllCanDoStatements().where((c) => c.levelOrder == 1).toList();

      // 6 of 7 concepts are familiar, but speaking success is poor (2/10 = 20%)
      final masteries = level1Concepts.map((c) {
        return VocabularyMastery(
          childId: 'child_1',
          vocabularyId: c.id,
          word: c.canonicalText,
          lastSeenAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
          currentLearningState: VocabularyLearningState.familiar,
          masteryScore: 0.75,
          pronunciationAttempts: 2,
          pronunciationSuccesses: 0, // 0% speaking success
        );
      }).toList();

      final evaluation = progressionEngine.evaluateLevelReadiness(
        currentLevel: level1,
        nextLevel: level2,
        levelConcepts: level1Concepts,
        masteries: masteries,
        levelCanDoStatements: canDos,
      );

      expect(evaluation.isReadyToAdvance, isFalse);
      expect(evaluation.conceptCoverageRatio >= 0.75, isTrue);
      expect(evaluation.speakingEvidenceRatio < 0.60, isTrue);
      expect(evaluation.educationalReasoning.contains('speaking evidence needs reinforcement'), isTrue);
    });

    test('Advancement is GRANTED when coverage >= 75% and speaking >= 60%', () {
      final level1 = repository.getLevelById('level_1_first_words')!;
      final level2 = repository.getLevelById('level_2_first_phrases')!;
      final level1Concepts = level1.coreConceptIds
          .map(repository.getConceptById)
          .whereType<LearningConcept>()
          .toList();
      final canDos = repository.getAllCanDoStatements().where((c) => c.levelOrder == 1).toList();

      // 6 of 7 concepts familiar/mastered with high pronunciation success
      final masteries = level1Concepts.map((c) {
        return VocabularyMastery(
          childId: 'child_1',
          vocabularyId: c.id,
          word: c.canonicalText,
          lastSeenAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
          currentLearningState: VocabularyLearningState.mastered,
          masteryScore: 0.85,
          pronunciationAttempts: 5,
          pronunciationSuccesses: 4, // 80% speaking success
        );
      }).toList();

      final evaluation = progressionEngine.evaluateLevelReadiness(
        currentLevel: level1,
        nextLevel: level2,
        levelConcepts: level1Concepts,
        masteries: masteries,
        levelCanDoStatements: canDos,
      );

      expect(evaluation.isReadyToAdvance, isTrue);
      expect(evaluation.conceptCoverageRatio >= 0.75, isTrue);
      expect(evaluation.speakingEvidenceRatio >= 0.60, isTrue);
      expect(evaluation.educationalReasoning.contains('solid speaking confidence'), isTrue);
    });

    test('CurriculumAwareRecommendation routes to level mission when ready to advance', () {
      const currentWorld = World(
        id: 'world_family',
        title: 'Family & Home',
        theme: 'family',
        description: 'Loving family',
        bannerAssetPath: 'banner.png',
        primaryColorHex: '#4CAF50',
        orderIndex: 1,
        metadata: ContentMetadata(learningObjective: 'Family'),
        chapters: [],
      );

      final level1 = repository.getLevelById('level_1_first_words')!;
      final level1Concepts = level1.coreConceptIds
          .map(repository.getConceptById)
          .whereType<LearningConcept>()
          .toList();

      // Prepare qualifying masteries
      final masteries = level1Concepts.map((c) {
        return VocabularyMastery(
          childId: testChild.id,
          vocabularyId: c.id,
          word: c.canonicalText,
          lastSeenAt: now,
          nextReviewAt: now.add(const Duration(days: 3)),
          currentLearningState: VocabularyLearningState.mastered,
          masteryScore: 0.90,
          pronunciationAttempts: 5,
          pronunciationSuccesses: 4,
        );
      }).toList();

      final rec = AdventureRecommendationEngine.getCurriculumAwareRecommendation(
        child: testChild,
        vocabularyMasteries: masteries,
        currentWorld: currentWorld,
        availableActivities: [],
        curriculumRepository: repository,
        now: now,
      );

      expect(rec.type, LearningRecommendationType.continueWorld);
      expect(rec.internalReason.contains('Ready for capstone challenge'), isTrue);
      expect(rec.priorityScore, 88);
    });

    test('CurriculumAwareRecommendation still respects ConfidenceGuardian easy-win priority', () {
      const currentWorld = World(
        id: 'world_family',
        title: 'Family & Home',
        theme: 'family',
        description: 'Loving family',
        bannerAssetPath: 'banner.png',
        primaryColorHex: '#4CAF50',
        orderIndex: 1,
        metadata: ContentMetadata(learningObjective: 'Family'),
        chapters: [],
      );

      final rec = AdventureRecommendationEngine.getCurriculumAwareRecommendation(
        child: testChild,
        vocabularyMasteries: [],
        currentWorld: currentWorld,
        availableActivities: [],
        curriculumRepository: repository,
        consecutiveErrors: 3, // Triggers confidence guardian easy win!
        now: now,
      );

      expect(rec.type, LearningRecommendationType.confidenceActivity);
      expect(rec.priorityScore, 95);
    });
  });
}
