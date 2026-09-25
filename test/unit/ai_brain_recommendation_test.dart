import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/skill_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('AI Speaking Brain Recommendation Tests', () {
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

    test('Recommends Talk with Pip when speaking skill mastery is weak (<0.50)', () {
      final skillMasteries = {
        SkillType.vocabulary: SkillMastery(skill: SkillType.vocabulary, score: 0.85, totalItemsTracked: 3, lastUpdated: now),
        SkillType.listening: SkillMastery(skill: SkillType.listening, score: 0.80, totalItemsTracked: 3, lastUpdated: now),
        SkillType.speaking: SkillMastery(skill: SkillType.speaking, score: 0.40, totalItemsTracked: 3, lastUpdated: now),
        SkillType.grammar: SkillMastery(skill: SkillType.grammar, score: 0.75, totalItemsTracked: 3, lastUpdated: now),
      };

      final rec = AdventureRecommendationEngine.getNextRecommendation(
        child: child,
        contentMasteries: const [],
        skillMasteries: skillMasteries,
        currentWorld: worldNature,
        availableActivities: worldNature.chapters.first.units.first.lessons,
        now: now,
      );

      expect(rec.priority, equals(RecommendationPriority.weakSkill));
      expect(rec.skill, equals(SkillType.speaking));
      expect(rec.routePath, contains('talk-with-pip'));
      expect(rec.title, contains('Talk with Pip'));
    });
  });
}
