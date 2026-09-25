import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/activity_variety_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/child_learning_profile.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/confidence_guardian.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/difficulty_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/spaced_review_scheduler.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Adaptive Curriculum Intelligence Tests', () {
    final now = DateTime(2026, 9, 2, 10, 0);

    late MockWorldRepository worldRepo;
    late World worldAnimal;

    final baseChild = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    );

    setUp(() async {
      worldRepo = MockWorldRepository();
      worldAnimal = (await worldRepo.getWorldById('world_animal'))!;
    });

    test('SpacedReviewScheduler computes due words and prioritized queue', () {
      const scheduler = SpacedReviewScheduler();

      final masteries = [
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          now: now,
        ).copyWith(
          nextReviewAt: now.subtract(const Duration(hours: 2)), // Overdue!
          currentLearningState: VocabularyLearningState.practicing,
        ),
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          now: now,
        ).copyWith(
          nextReviewAt: now.add(const Duration(days: 3)), // Not due
          currentLearningState: VocabularyLearningState.familiar,
        ),
      ];

      final due = scheduler.getDueForReview(masteries, now);
      expect(due.length, equals(1));
      expect(due.first.vocabularyId, equals('vocab_elephant'));

      final queue = scheduler.getPrioritizedReviewQueue(masteries, now);
      expect(queue.first.vocabularyId, equals('vocab_elephant'));
    });

    test('DifficultyEngine adjusts tiers and choice parameters from child signals', () {
      const engine = DifficultyEngine();

      // Consecutive errors -> support tier
      final supportTier = engine.resolveDifficulty(
        childAge: 6,
        recentMasteries: [],
        consecutiveErrors: 2,
      );
      expect(supportTier, equals(AdaptiveDifficultyTier.support));
      expect(supportTier.choiceCount, equals(2));
      expect(supportTier.autoHintDelaySeconds, lessThanOrEqualTo(5));

      // Toddler child age 4 with standard play -> easy tier
      final toddlerTier = engine.resolveDifficulty(
        childAge: 4,
        recentMasteries: [],
      );
      expect(toddlerTier, equals(AdaptiveDifficultyTier.easy));

      // Older child with 5+ correct and mastered words -> challenge tier
      final masteredList = List.generate(
        3,
        (i) => VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_$i',
          word: 'Word$i',
          now: now,
        ).copyWith(
          currentLearningState: VocabularyLearningState.mastered,
          masteryScore: 0.90,
        ),
      );
      final challengeTier = engine.resolveDifficulty(
        childAge: 7,
        recentMasteries: masteredList,
        consecutiveCorrect: 5,
      );
      expect(challengeTier, equals(AdaptiveDifficultyTier.challenge));
      expect(challengeTier.choiceCount, equals(4));
    });

    test('ConfidenceGuardian prescribes support intervention when error streak is detected', () {
      const guardian = ConfidenceGuardian();

      final masteries = [
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          now: now,
        ).copyWith(
          currentLearningState: VocabularyLearningState.struggling,
          consecutiveIncorrect: 3,
        ),
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          now: now,
        ).copyWith(
          currentLearningState: VocabularyLearningState.mastered,
          consecutiveCorrect: 4,
          correctAttempts: 5,
          masteryScore: 0.90,
        ),
      ];

      final intervention = guardian.assessConfidence(
        consecutiveErrors: 3,
        hintUsageInSession: 1,
        micFailureCount: 0,
        masteries: masteries,
      );

      expect(intervention.type, equals(ConfidenceInterventionType.provideEasyWin));
      expect(intervention.recommendedVocabularyId, equals('vocab_cat'));
      expect(intervention.pipEncouragingDialogue, contains('Pip'));
    });

    test('ActivityVarietyEngine prevents fatigue by rotating activity types', () {
      const varietyEngine = ActivityVarietyEngine(maxConsecutiveSameCategory: 2);

      final history = [
        ActivityCategory.animalHunt,
        ActivityCategory.animalHunt,
      ];

      expect(varietyEngine.isCategoryEligible(ActivityCategory.animalHunt, history), isFalse);
      expect(varietyEngine.isCategoryEligible(ActivityCategory.story, history), isTrue);

      final selected = varietyEngine.selectBestCategory(
        candidates: [
          ActivityCategory.animalHunt,
          ActivityCategory.story,
          ActivityCategory.conversation,
        ],
        history: history,
      );

      expect(selected, isNot(equals(ActivityCategory.animalHunt)));
    });

    test('ChildLearningProfile aggregates individual vocabulary masteries accurately', () {
      final masteries = [
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          now: now,
        ).copyWith(
          currentLearningState: VocabularyLearningState.mastered,
          masteryScore: 0.90,
        ),
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          now: now,
        ).copyWith(
          currentLearningState: VocabularyLearningState.struggling,
          masteryScore: 0.30,
          consecutiveIncorrect: 3,
        ),
      ];

      final profile = ChildLearningProfile.fromMasteries(
        childId: 'child_ayaan',
        masteries: masteries,
        currentWorldId: 'world_animal',
        streakDays: 4,
      );

      expect(profile.childId, equals('child_ayaan'));
      expect(profile.totalWordsTracked, equals(2));
      expect(profile.masteredVocabulary, contains('Elephant'));
      expect(profile.strugglingVocabulary, contains('Lion'));
      expect(profile.learningStreakDays, equals(4));
    });

    test('AdventureRecommendationEngine generates explainable adaptive recommendations', () {
      final overdueMastery = [
        VocabularyMastery.initial(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          now: now,
        ).copyWith(
          nextReviewAt: now.subtract(const Duration(days: 1)),
          currentLearningState: VocabularyLearningState.practicing,
          masteryScore: 0.50,
        ),
      ];

      final recommendation = AdventureRecommendationEngine.getAdaptiveRecommendation(
        child: baseChild,
        vocabularyMasteries: overdueMastery,
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(recommendation.type, equals(LearningRecommendationType.reviewDueVocabulary));
      expect(recommendation.internalReason, contains('spaced'));
      expect(recommendation.childFriendlyPrompt, contains('Pip'));
      expect(recommendation.targetVocabularyIds, contains('vocab_elephant'));
    });
  });
}
