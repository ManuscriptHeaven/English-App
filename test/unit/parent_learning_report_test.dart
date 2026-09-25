import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/content_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Parent Learning Report & Brain Analytics Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);
    late MockWorldRepository worldRepo;
    late World worldFood;

    final child = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    );

    setUp(() async {
      worldRepo = MockWorldRepository();
      worldFood = (await worldRepo.getWorldById('world_food'))!;
    });

    test('AdventureBrain targets weak food vocabulary and recommends Food Hunt', () {
      final weakFood = [
        ContentMastery(
          contentId: 'vocab_apple',
          skill: SkillType.vocabulary,
          masteryScore: 0.35,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: child,
        contentMasteries: weakFood,
        skillMasteries: {},
        currentWorld: worldFood,
        availableActivities: worldFood.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_food_hunt'));
      expect(rec.routePath, contains('food-hunt'));
    });

    test('AdventureBrain targets weak manners and recommends Food Sharing', () {
      final weakSharing = [
        ContentMastery(
          contentId: 'manner_sharing_food',
          skill: SkillType.manners,
          masteryScore: 0.30,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: child,
        contentMasteries: weakSharing,
        skillMasteries: {},
        currentWorld: worldFood,
        availableActivities: worldFood.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_food_sharing'));
      expect(rec.routePath, contains('food-sharing'));
    });
  });
}
