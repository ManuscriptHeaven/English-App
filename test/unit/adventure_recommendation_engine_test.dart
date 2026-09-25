import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/content_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/skill_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/rewards/domain/models/child_progress.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('AdventureRecommendationEngine 8-Level Priority Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);
    late MockWorldRepository worldRepo;
    late World worldAnimal;
    late World worldHome;

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
      worldHome = (await worldRepo.getWorldById('world_home'))!;
    });

    test('Priority 1: Recommends rest when daily screen time is reached', () {
      const progress = ChildProgress(
        childId: 'child_ayaan',
        totalMinutesSpent: 35, // Exceeds 30m limit
      );

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        progress: progress,
        contentMasteries: [],
        skillMasteries: {},
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        dailyScreenTimeLimitMinutes: 30,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.parentSafety));
      expect(rec.title, contains('Rest'));
    });

    test('Priority 2: Recommends Spaced Review when content is overdue', () {
      final overdueContent = [
        ContentMastery(
          contentId: 'vocab_elephant',
          skill: SkillType.vocabulary,
          masteryScore: 0.70,
          lastAttemptAt: now.subtract(const Duration(days: 5)),
          nextReviewAt: now.subtract(const Duration(days: 1)), // Due!
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: overdueContent,
        skillMasteries: {},
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.overdueReview));
      expect(rec.isReview, isTrue);
      expect(rec.routePath, contains('adaptive-review'));
    });

    test('Priority 3: Recommends Animal Hunt for weak elephant vocabulary (<0.45)', () {
      final weakElephant = [
        ContentMastery(
          contentId: 'vocab_elephant',
          skill: SkillType.vocabulary,
          masteryScore: 0.28, // Weak!
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: weakElephant,
        skillMasteries: {},
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_animal_hunt'));
      expect(rec.childFriendlyPrompt, contains('animal friends'));
    });

    test('Priority 3: Recommends Is/Are Challenge for weak is_are grammar (<0.45)', () {
      final weakGrammar = [
        ContentMastery(
          contentId: 'grammar_is_are',
          skill: SkillType.grammar,
          masteryScore: 0.35, // Weak!
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: weakGrammar,
        skillMasteries: {},
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_grammar_is_are'));
    });

    test('Priority 3: Recommends Home Hunt for weak home vocabulary in World 2', () {
      final weakHome = [
        ContentMastery(
          contentId: 'vocab_room',
          skill: SkillType.vocabulary,
          masteryScore: 0.30, // Weak!
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: weakHome,
        skillMasteries: {},
        currentWorld: worldHome,
        availableActivities: worldHome.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_home_hunt'));
    });

    test('Priority 4: Recommends Speaking Lab when speaking skill score is low (<0.60)', () {
      final skillMasteries = {
        SkillType.speaking: SkillMastery(
          skill: SkillType.speaking,
          score: 0.48, // Low speaking accuracy!
          totalItemsTracked: 4,
          lastUpdated: now,
        ),
        SkillType.vocabulary: SkillMastery(
          skill: SkillType.vocabulary,
          score: 0.85,
          totalItemsTracked: 4,
          lastUpdated: now,
        ),
      };

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: [],
        skillMasteries: skillMasteries,
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.weakSkill));
      expect(rec.activityId, equals('activity_speaking_practice'));
      expect(rec.reason, contains('Speaking'));
    });

    test('Priority 5: Recommends next uncompleted curriculum step when performance is strong', () {
      final strongChild = baseChild.copyWith(
        completedLessonIds: ['activity_animal_vocab', 'activity_animal_hunt'],
      );

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: strongChild,
        contentMasteries: [],
        skillMasteries: {},
        currentWorld: worldAnimal,
        availableActivities: worldAnimal.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.curriculumProgression));
      expect(rec.activityId, equals('activity_listen_tap')); // Step 3
    });
  });
}
