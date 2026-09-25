import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

void main() {
  group('Anti-Farming Reward Policy Tests', () {
    test('First-time completion awards 100% XP, coins, and stars', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        xp: 0,
        coins: 0,
        stars: 0,
        avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        completedLessonIds: const [],
      );

      final notifier = container.read(activeChildProfileProvider.notifier);
      notifier.selectChild(child);

      await notifier.completeActivity('activity_animal_vocab', xp: 20, coins: 10, stars: 3);

      final updated = container.read(activeChildProfileProvider)!;
      expect(updated.xp, equals(20));
      expect(updated.coins, equals(10));
      expect(updated.stars, equals(3));
      expect(updated.completedLessonIds, contains('activity_animal_vocab'));
    });

    test('Replaying an already completed activity awards reduced rewards and 0 stars', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        xp: 100,
        coins: 50,
        stars: 10,
        avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        completedLessonIds: const ['activity_animal_vocab'], // Already completed!
      );

      final notifier = container.read(activeChildProfileProvider.notifier);
      notifier.selectChild(child);

      // Replay activity
      await notifier.completeActivity('activity_animal_vocab', xp: 20, coins: 10, stars: 3);

      final updated = container.read(activeChildProfileProvider)!;
      // 25% of 20 = 5 XP, 25% of 10 = 3 (clamped/rounded), 0 stars
      expect(updated.xp, equals(105)); // 100 + 5
      expect(updated.coins, equals(53)); // 50 + 3
      expect(updated.stars, equals(10)); // Stars do not increase on replay
    });
  });
}
