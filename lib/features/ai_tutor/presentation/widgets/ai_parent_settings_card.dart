import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/providers/ai_tutor_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

/// Parent controls card managing child AI conversation features and quotas.
class AiParentSettingsCard extends ConsumerWidget {
  const AiParentSettingsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(aiParentSettingsProvider);
    final usageManager = ref.watch(aiUsageManagerProvider);
    final activeChild = ref.watch(activeChildProfileProvider);

    final stats = activeChild != null
        ? usageManager.getTodayStats(activeChild.id)
        : null;

    return AppCard(
      borderColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🤖', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'AI Tutor & Conversation Controls',
                        style: AppTypography.headlineMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: settings.aiTutorEnabled,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  ref.read(aiParentSettingsProvider.notifier).updateSettings(aiTutorEnabled: val);
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Curriculum-controlled safe English speaking companion with Pip the Parrot.',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          const Divider(),

          // Usage Stats Banner
          if (stats != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withAlpha(80),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatPill('Today\'s Turns', '${stats.usedTurns} / ${settings.dailyTurnsLimit}'),
                  _buildStatPill('Practice Time', '${stats.usedMinutes} / ${settings.dailyMinutesLimit} min'),
                  _buildStatPill('Fallback Rate', stats.usedTurns > 0 ? '${((stats.fallbackCount / stats.usedTurns) * 100).toInt()}%' : '0%'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Daily Minute Limit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Time Limit', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text('${settings.dailyMinutesLimit} minutes', style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark)),
            ],
          ),
          Slider(
            value: settings.dailyMinutesLimit.toDouble(),
            min: 5,
            max: 30,
            divisions: 5,
            activeColor: AppColors.primary,
            onChanged: settings.aiTutorEnabled
                ? (val) {
                    ref.read(aiParentSettingsProvider.notifier).updateSettings(dailyMinutesLimit: val.toInt());
                  }
                : null,
          ),

          // Daily Turns Limit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Daily Turns Limit', style: AppTypography.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
              Text('${settings.dailyTurnsLimit} turns', style: AppTypography.badgeText.copyWith(color: AppColors.secondaryDark)),
            ],
          ),
          Slider(
            value: settings.dailyTurnsLimit.toDouble(),
            min: 5,
            max: 50,
            divisions: 9,
            activeColor: AppColors.secondary,
            onChanged: settings.aiTutorEnabled
                ? (val) {
                    ref.read(aiParentSettingsProvider.notifier).updateSettings(dailyTurnsLimit: val.toInt());
                  }
                : null,
          ),

          // Voice Toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Voice & Speech Practice', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      const Text('Allow microphone interaction with Pip', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: settings.voiceConversationEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: settings.aiTutorEnabled
                      ? (val) {
                          ref.read(aiParentSettingsProvider.notifier).updateSettings(voiceConversationEnabled: val);
                        }
                      : null,
                ),
              ],
            ),
          ),

          // Story Variations Toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Curriculum Story Variations', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      const Text('Generate approved practice variations of story scenarios', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: settings.storyVariationsEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: settings.aiTutorEnabled
                      ? (val) {
                          ref.read(aiParentSettingsProvider.notifier).updateSettings(storyVariationsEnabled: val);
                        }
                      : null,
                ),
              ],
            ),
          ),

          // Offline Scripted Fallback Toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Offline Scripted Fallback', style: AppTypography.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 2),
                      const Text('Seamlessly practice using scripted dialogues when offline', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Switch(
                  value: settings.aiFallbackEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: settings.aiTutorEnabled
                      ? (val) {
                          ref.read(aiParentSettingsProvider.notifier).updateSettings(aiFallbackEnabled: val);
                        }
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
