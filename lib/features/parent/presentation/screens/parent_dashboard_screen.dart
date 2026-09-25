import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../adventure_brain/presentation/providers/adventure_brain_providers.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../sync/presentation/providers/sync_providers.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parentAsync = ref.watch(parentProfileProvider);
    final activeChild = ref.watch(activeChildProfileProvider);
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Parent Dashboard 🛡️', style: AppTypography.headlineLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: AppColors.textPrimary),
            onPressed: () => context.push(RouteNames.settings),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Parent Account Header
            parentAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (err, stack) => const SizedBox(),
              data: (parent) {
                return AppCard(
                  backgroundColor: AppColors.primaryLight,
                  borderColor: AppColors.primary,
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primary,
                        child: Icon(Icons.verified_user_rounded, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(parent?.name ?? 'Parent Account', style: AppTypography.headlineMedium),
                            Text(parent?.email ?? '', style: AppTypography.bodyMedium),
                            const SizedBox(height: 4),
                            Consumer(
                              builder: (context, ref, _) {
                                final syncAsync = ref.watch(syncStatusProvider);
                                return syncAsync.when(
                                  loading: () => const Text('Syncing...', style: TextStyle(fontSize: 12)),
                                  error: (_, _) => const Text('Offline', style: TextStyle(fontSize: 12)),
                                  data: (info) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.correctGreen.withValues(alpha: 0.15),
                                      borderRadius: AppRadius.roundedPill,
                                    ),
                                    child: Text(info.displayLabel, style: AppTypography.badgeText.copyWith(color: AppColors.correctGreen, fontSize: 11)),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            if (activeChild != null) ...[
              // Child Profile Card
              AppCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.secondary,
                      child: Text(
                        activeChild.name.isNotEmpty ? activeChild.name[0] : 'C',
                        style: AppTypography.headlineLarge.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${activeChild.name} (Age ${activeChild.age})', style: AppTypography.titleLarge),
                          Text('Level ${activeChild.level} Explorer • ${activeChild.streakDays} Day Streak 🔥', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                    RewardBadge(type: BadgeType.xp, count: activeChild.xp),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5-Skill Mastery Breakdown
              Text('Core Skill Mastery', style: AppTypography.headlineLarge),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    _buildSkillRow('Vocabulary (Animals, Home & School)', 0.85, AppColors.correctGreen),
                    const SizedBox(height: 12),
                    _buildSkillRow('Grammar (This is... / Plurals / Requests)', 0.75, AppColors.primary),
                    const SizedBox(height: 12),
                    _buildSkillRow('Listening Comprehension', 0.90, AppColors.valueEmerald),
                    const SizedBox(height: 12),
                    _buildSkillRow('Speaking Pronunciation', 0.65, AppColors.accent),
                    const SizedBox(height: 12),
                    _buildSkillRow('Story Reading & Character (Rahmah, Birr, Sidq)', 0.80, AppColors.worldHomeOrange),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Deterministic Weak-Area & Adaptive Recommendations
              Text('Personalized Learning Insights', style: AppTypography.headlineLarge),
              const SizedBox(height: 12),
              ref.watch(currentRecommendationProvider).when(
                    loading: () => const LinearProgressIndicator(),
                    error: (err, stack) => const SizedBox(),
                    data: (rec) {
                      return AppCard(
                        backgroundColor: AppColors.valueMint,
                        borderColor: AppColors.valueEmerald,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.lightbulb_rounded, color: AppColors.valueEmerald, size: 28),
                                const SizedBox(width: 10),
                                Text(
                                  'Current Engine Recommendation',
                                  style: AppTypography.titleLarge.copyWith(color: AppColors.valueEmerald),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Recommended Activity: "${rec.title}"\n• Priority: ${rec.priority.name}\n• Pedagogical Reason: ${rec.reason}',
                              style: AppTypography.bodyMedium.copyWith(height: 1.5),
                            ),
                            const SizedBox(height: 14),
                            AppButton(
                              text: 'Launch Recommended Activity ▶',
                              minWidth: double.infinity,
                              height: 48,
                              backgroundColor: AppColors.valueEmerald,
                              foregroundColor: Colors.white,
                              onPressed: () => context.push(rec.routePath),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              const SizedBox(height: 20),

              // Weekly Activity Tracker (Mon - Sun)
              Text('Weekly Learning Minutes', style: AppTypography.headlineLarge),
              const SizedBox(height: 12),
              AppCard(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        _DayActivityBar(day: 'Mon', minutes: 20, isTargetMet: true),
                        _DayActivityBar(day: 'Tue', minutes: 15, isTargetMet: true),
                        _DayActivityBar(day: 'Wed', minutes: 25, isTargetMet: true),
                        _DayActivityBar(day: 'Thu', minutes: 10, isTargetMet: false),
                        _DayActivityBar(day: 'Fri', minutes: 30, isTargetMet: true),
                        _DayActivityBar(day: 'Sat', minutes: 20, isTargetMet: true),
                        _DayActivityBar(day: 'Sun', minutes: 15, isTargetMet: true),
                      ],
                    ),
                    const Divider(height: 24),
                    Text('Total: 135 mins this week • Daily goal: ${settings.dailyScreenTimeLimitMinutes}m', style: AppTypography.bodyMedium),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Screen Time & Safety Controls
            Text('Child Safety & Screen Time', style: AppTypography.headlineLarge),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daily Limit: ${settings.dailyScreenTimeLimitMinutes} mins', style: AppTypography.titleLarge),
                      Slider(
                        value: settings.dailyScreenTimeLimitMinutes.toDouble(),
                        min: 10,
                        max: 90,
                        divisions: 8,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          ref.read(appSettingsProvider.notifier).setDailyScreenTimeLimit(val.toInt());
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              text: 'View Full Learning Report 📊',
              minWidth: double.infinity,
              height: 56,
              backgroundColor: AppColors.secondary,
              onPressed: () => context.go(RouteNames.parentReports),
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Account & Data Sync ⚙️',
              minWidth: double.infinity,
              height: 56,
              backgroundColor: AppColors.primaryDark,
              onPressed: () => context.go(RouteNames.parentAccount),
            ),
            const SizedBox(height: 12),

            AppButton(
              text: 'Back to Explorer World 🚀',
              minWidth: double.infinity,
              height: 56,
              onPressed: () => context.go(RouteNames.home),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillRow(String skillName, double progress, Color barColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                skillName,
                style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('${(progress * 100).toInt()}%', style: AppTypography.badgeText.copyWith(color: barColor)),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.cardBorder,
          valueColor: AlwaysStoppedAnimation<Color>(barColor),
          borderRadius: AppRadius.roundedPill,
          minHeight: 8,
        ),
      ],
    );
  }
}

class _DayActivityBar extends StatelessWidget {
  final String day;
  final int minutes;
  final bool isTargetMet;

  const _DayActivityBar({
    required this.day,
    required this.minutes,
    required this.isTargetMet,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 24,
          height: (minutes * 1.5).clamp(10.0, 60.0),
          decoration: BoxDecoration(
            color: isTargetMet ? AppColors.primary : AppColors.lockGrey,
            borderRadius: AppRadius.roundedPill,
          ),
        ),
        const SizedBox(height: 6),
        Text(day, style: AppTypography.badgeText.copyWith(fontSize: 12)),
        Text('${minutes}m', style: AppTypography.badgeText.copyWith(fontSize: 10, color: AppColors.textMuted)),
      ],
    );
  }
}
