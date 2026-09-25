import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/activity_variety_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Activity Variety & Mechanic Distribution Validation', () {
    late ActivityVarietyEngine varietyEngine;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      varietyEngine = const ActivityVarietyEngine();
    });

    test('1. ActivityVarietyEngine detects and prevents more than 2 consecutive identical mechanics', () {
      final historyWithTwoGames = [
        ActivityCategory.animalHunt,
        ActivityCategory.animalHunt,
      ];

      final isGameEligible = varietyEngine.isCategoryEligible(
        ActivityCategory.animalHunt,
        historyWithTwoGames,
      );
      expect(isGameEligible, isFalse);

      final isStoryEligible = varietyEngine.isCategoryEligible(
        ActivityCategory.story,
        historyWithTwoGames,
      );
      expect(isStoryEligible, isTrue);
    });

    test('2. Orchestrated standard sessions have varied activity types with no adjacent duplicates', () {
      final orchestrator = LearningSessionOrchestrator(clock: () => now);
      const child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      final session = orchestrator.assembleSession(
        child: child,
        masteries: const [],
        graph: CurriculumGraph.standard(),
        currentWorld: const World(
          id: 'world_animal',
          title: 'Animal Adventure',
          theme: 'animal',
          description: 'Animal world',
          bannerAssetPath: 'assets/banner.png',
          primaryColorHex: '0xFF66BB6A',
          orderIndex: 1,
          metadata: ContentMetadata(
            learningObjective: 'Animals',
            worldId: 'world_animal',
          ),
          chapters: [],
        ),
        dailyScreenTimeLimitMinutes: 15,
        now: now,
      );

      // Verify that no two consecutive activities in the session share the exact same activity type
      for (int i = 0; i < session.activities.length - 1; i++) {
        final currentType = session.activities[i].activityType;
        final nextType = session.activities[i + 1].activityType;
        expect(
          currentType,
          isNot(equals(nextType)),
          reason: 'Activity $i and ${i + 1} both have type $currentType',
        );
      }
    });
  });
}
