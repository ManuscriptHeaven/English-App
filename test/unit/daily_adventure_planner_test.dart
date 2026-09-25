import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/daily_adventure_planner.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';

void main() {
  group('DailyAdventurePlanner Session Generation Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);

    test('Generates a 3 to 4 activity balanced plan within screen-time limit', () async {
      final worldRepo = MockWorldRepository();
      final world = (await worldRepo.getWorldById('world_animal'))!;

      final child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
      );

      final session = DailyAdventurePlanner.generateDailySession(
        child: child,
        contentMasteries: [],
        skillMasteries: {},
        currentWorld: world,
        availableActivities: world.chapters.first.units.first.lessons,
        dailyScreenTimeLimitMinutes: 20,
        now: now,
      );

      expect(session.activities.length, greaterThanOrEqualTo(2));
      expect(session.activities.length, lessThanOrEqualTo(4));
      expect(session.totalEstimatedMinutes, lessThanOrEqualTo(20));
      expect(session.nextActivity, isNotNull);
      expect(session.isCompleted, isFalse);
    });
  });
}
