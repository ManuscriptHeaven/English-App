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
  group('World 5 Adventure Brain Recommendation Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);
    late MockWorldRepository worldRepo;
    late World worldNature;

    final child = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    );

    setUp(() async {
      worldRepo = MockWorldRepository();
      worldNature = (await worldRepo.getWorldById('world_nature'))!;
    });

    test('Recommends Nature Hunt for weak tree/nature vocabulary (<0.45)', () {
      final weakTree = [
        ContentMastery(
          contentId: 'vocab_tree',
          skill: SkillType.vocabulary,
          masteryScore: 0.35,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: child,
        contentMasteries: weakTree,
        skillMasteries: {},
        currentWorld: worldNature,
        availableActivities: worldNature.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_nature_hunt'));
      expect(rec.routePath, contains('nature-hunt'));
    });

    test('Recommends Weather Listen & Tap for weak weather listening (<0.45)', () {
      final weakWeather = [
        ContentMastery(
          contentId: 'vocab_weather_rain',
          skill: SkillType.listening,
          masteryScore: 0.30,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: child,
        contentMasteries: weakWeather,
        skillMasteries: {},
        currentWorld: worldNature,
        availableActivities: worldNature.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_weather_listen'));
      expect(rec.routePath, contains('weather-listen'));
    });
  });
}
