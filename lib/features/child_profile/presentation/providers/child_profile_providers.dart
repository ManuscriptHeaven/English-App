import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/child_profile.dart';
import '../../domain/models/parent_profile.dart';
import '../../domain/repositories/child_profile_repository.dart';
import '../../data/mock_child_profile_repository.dart';
import '../../../adventure_brain/domain/telemetry/learning_event.dart';
import '../../../adventure_brain/presentation/providers/telemetry_providers.dart';

final childProfileRepositoryProvider = Provider<IChildProfileRepository>((ref) {
  return MockChildProfileRepository();
});

final childProfilesProvider = FutureProvider<List<ChildProfile>>((ref) async {
  final repo = ref.watch(childProfileRepositoryProvider);
  return repo.getChildProfiles();
});

final parentProfileProvider = FutureProvider<ParentProfile?>((ref) async {
  final repo = ref.watch(childProfileRepositoryProvider);
  return repo.getParentProfile();
});

/// StateNotifier to manage the active child currently using the app.
class ActiveChildNotifier extends StateNotifier<ChildProfile?> {
  final Ref _ref;

  ActiveChildNotifier(this._ref) : super(null) {
    _initDefaultChild();
  }

  Future<void> _initDefaultChild() async {
    final profiles = await _ref.read(childProfileRepositoryProvider).getChildProfiles();
    if (profiles.isNotEmpty && state == null) {
      state = profiles.first;
    }
  }

  void selectChild(ChildProfile child) {
    state = child;
  }

  Future<void> addRewards({int xp = 0, int coins = 0, int stars = 0}) async {
    if (state == null) return;
    final updated = state!.copyWith(
      xp: state!.xp + xp,
      coins: state!.coins + coins,
      stars: state!.stars + stars,
    );
    state = updated;
    await _ref.read(childProfileRepositoryProvider).saveChildProfile(updated);
    try {
      _ref.read(learningTelemetryServiceProvider).recordEvent(
        LearningEvent(
          id: '${state!.id}_reward_${DateTime.now().millisecondsSinceEpoch}',
          eventType: LearningEventType.rewardEarned,
          childId: state!.id,
          timestamp: DateTime.now(),
          metadata: {
            'xp': xp,
            'coins': coins,
            'stars': stars,
          },
        ),
      );
    } catch (_) {}
  }

  /// Completes an activity with anti-reward-farming protection for replays.
  Future<void> completeActivity(
    String activityId, {
    String? nextActivityId,
    int xp = 20,
    int coins = 10,
    int stars = 3,
    String? unlockedAchievementId,
  }) async {
    if (state == null) return;

    final isFirstCompletion = !state!.completedLessonIds.contains(activityId);

    // Anti-farming policy: Replays award 25% XP/Coins and 0 additional stars
    final awardedXp = isFirstCompletion ? xp : (xp * 0.25).round().clamp(2, xp);
    final awardedCoins = isFirstCompletion ? coins : (coins * 0.25).round().clamp(1, coins);
    final awardedStars = isFirstCompletion ? stars : 0;

    final completedList = List<String>.from(state!.completedLessonIds);
    if (isFirstCompletion) {
      completedList.add(activityId);
    }

    final unlockedWorlds = List<String>.from(state!.unlockedWorldIds);
    final unlockedAchievements = List<String>.from(state!.unlockedAchievementIds);

    if (unlockedAchievementId != null && !unlockedAchievements.contains(unlockedAchievementId)) {
      unlockedAchievements.add(unlockedAchievementId);
    }

    final updated = state!.copyWith(
      xp: state!.xp + awardedXp,
      coins: state!.coins + awardedCoins,
      stars: state!.stars + awardedStars,
      completedLessonIds: completedList,
      unlockedWorldIds: unlockedWorlds,
      unlockedAchievementIds: unlockedAchievements,
    );

    state = updated;
    await _ref.read(childProfileRepositoryProvider).saveChildProfile(updated);
    try {
      _ref.read(learningTelemetryServiceProvider).recordEvent(
        LearningEvent(
          id: '${state!.id}_${activityId}_${DateTime.now().millisecondsSinceEpoch}',
          eventType: LearningEventType.lessonCompleted,
          childId: state!.id,
          activityId: activityId,
          timestamp: DateTime.now(),
          metadata: {
            'awardedXp': awardedXp,
            'awardedCoins': awardedCoins,
            'awardedStars': awardedStars,
            'isFirstCompletion': isFirstCompletion,
          },
        ),
      );
    } catch (_) {}
  }

  Future<void> createProfile(ChildProfile newProfile) async {
    await _ref.read(childProfileRepositoryProvider).saveChildProfile(newProfile);
    _ref.invalidate(childProfilesProvider);
    state = newProfile;
  }
}

final activeChildProfileProvider = StateNotifierProvider<ActiveChildNotifier, ChildProfile?>((ref) {
  return ActiveChildNotifier(ref);
});
