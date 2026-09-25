import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../providers/progress_providers.dart';

/// Treasure Room / Rewards Screen — Redesigned for joy and pride.
class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final achievementsAsync = ref.watch(activeChildAchievementsProvider);
    final missionsAsync = ref.watch(activeChildMissionsProvider);
    final theme = WorldTheme.deliciousFood; // Warm celebratory theme

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // Background Painter
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: theme,
                    groundHeightFraction: 0.15,
                  ),
                ),
              ),
            ),
          ),

          // Child AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChildAppBar(
              title: 'Trophy Room 🏆',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: theme,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 68),

                  // Pip congratulating
                  Center(
                    child: PipCharacterGuide(
                      state: PipState.celebrating,
                      characterSize: 72,
                      speechBubbleText: 'Look at all your awesome badges and stars!',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Missions Header
                  Row(
                    children: [
                      const Text('🎯', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text('Daily Missions', style: AppTypography.headlineLarge.copyWith(color: AppColors.earthDark)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  missionsAsync.when(
                    loading: () => const LoadingView(),
                    error: (err, _) => ErrorView(message: err.toString()),
                    data: (missions) {
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: missions.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, idx) {
                          final mission = missions[idx];
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: mission.isCompleted ? AppColors.correctGreen : AppColors.sunYellow,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: (mission.isCompleted ? AppColors.correctGreen : AppColors.sunYellow).withAlpha(30),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Text(
                                  mission.isCompleted ? '⭐' : '⭕',
                                  style: TextStyle(fontSize: mission.isCompleted ? 26 : 22),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mission.title,
                                        style: AppTypography.headlineMedium.copyWith(
                                          color: mission.isCompleted ? AppColors.meadowDark : AppColors.earthDark,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        mission.description,
                                        style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                RewardBadge(type: BadgeType.coin, count: mission.rewardCoins),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),

                  // Achievement Badges
                  Row(
                    children: [
                      const Text('🏆', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      Text('Trophy Showcase', style: AppTypography.headlineLarge.copyWith(color: AppColors.earthDark)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  achievementsAsync.when(
                    loading: () => const LoadingView(),
                    error: (err, _) => ErrorView(message: err.toString()),
                    data: (achievements) {
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: achievements.length,
                        itemBuilder: (context, idx) {
                          final ach = achievements[idx];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: ach.isUnlocked ? Colors.white : const Color(0xFFF0EBE4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: ach.isUnlocked ? AppColors.sunYellow : AppColors.lockGrey.withAlpha(80),
                                width: ach.isUnlocked ? 2.5 : 1.5,
                              ),
                              boxShadow: ach.isUnlocked
                                  ? [
                                      BoxShadow(
                                        color: AppColors.sunYellow.withAlpha(60),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: ach.isUnlocked ? AppColors.sunLight : AppColors.lockGrey.withAlpha(50),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    ach.isUnlocked ? '🌟' : '🔒',
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  ach.title,
                                  style: AppTypography.titleLarge.copyWith(
                                    color: ach.isUnlocked ? AppColors.earthDark : AppColors.textMuted,
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  ach.description,
                                  style: AppTypography.bodySmall.copyWith(
                                    fontSize: 11,
                                    color: ach.isUnlocked ? AppColors.textSecondary : AppColors.textMuted,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
