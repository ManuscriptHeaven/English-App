import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

void main() {
  group('Progressive Unlock and Rewards Tests', () {
    test('Completing activity awards XP, Coins, Stars and marks activity as completed', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(childProfileRepositoryProvider);
      final profiles = await repo.getChildProfiles();
      final notifier = container.read(activeChildProfileProvider.notifier);
      notifier.selectChild(profiles.first);

      final initialChild = container.read(activeChildProfileProvider);
      expect(initialChild, isNotNull);

      final initialXp = initialChild!.xp;
      final initialCoins = initialChild.coins;
      final initialStars = initialChild.stars;

      await notifier.completeActivity(
        'activity_animal_vocab',
        nextActivityId: 'activity_animal_hunt',
        xp: 20,
        coins: 10,
        stars: 3,
      );

      final updatedChild = container.read(activeChildProfileProvider);
      expect(updatedChild!.xp, equals(initialXp + 20));
      expect(updatedChild.coins, equals(initialCoins + 10));
      expect(updatedChild.stars, equals(initialStars + 3));
      expect(updatedChild.completedLessonIds, contains('activity_animal_vocab'));
    });

    test('Completing final challenge unlocks Kindness Hero achievement', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final repo = container.read(childProfileRepositoryProvider);
      final profiles = await repo.getChildProfiles();
      final notifier = container.read(activeChildProfileProvider.notifier);
      notifier.selectChild(profiles.first);

      await notifier.completeActivity(
        'activity_final_challenge',
        xp: 50,
        coins: 30,
        stars: 3,
        unlockedAchievementId: 'ach_animal_hero',
      );

      final child = container.read(activeChildProfileProvider);
      expect(child!.unlockedAchievementIds, contains('ach_animal_hero'));
    });
  });
}
