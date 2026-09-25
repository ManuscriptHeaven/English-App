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
  group('World 3 Adventure Brain Recommendation Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);
    late MockWorldRepository worldRepo;
    late World worldSchool;

    final baseChild = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    );

    setUp(() async {
      worldRepo = MockWorldRepository();
      worldSchool = (await worldRepo.getWorldById('world_school'))!;
    });

    test('Recommends Classroom Hunt for weak pencil vocabulary (<0.45)', () {
      final weakPencil = [
        ContentMastery(
          contentId: 'vocab_pencil',
          skill: SkillType.vocabulary,
          masteryScore: 0.32,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: weakPencil,
        skillMasteries: {},
        currentWorld: worldSchool,
        availableActivities: worldSchool.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_classroom_hunt'));
      expect(rec.routePath, contains('classroom-hunt'));
    });

    test('Recommends Plurals Grammar for weak plural countables (<0.45)', () {
      final weakPlurals = [
        ContentMastery(
          contentId: 'grammar_plural',
          skill: SkillType.grammar,
          masteryScore: 0.30,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 2)),
        ),
      ];

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: baseChild,
        contentMasteries: weakPlurals,
        skillMasteries: {},
        currentWorld: worldSchool,
        availableActivities: worldSchool.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.activityId, equals('activity_grammar_plurals'));
      expect(rec.routePath, contains('plurals'));
    });
  });
}
