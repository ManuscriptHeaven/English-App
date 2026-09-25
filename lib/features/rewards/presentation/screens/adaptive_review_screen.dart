import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/child_table_visual.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class AdaptiveReviewScreen extends ConsumerStatefulWidget {
  const AdaptiveReviewScreen({super.key});

  @override
  ConsumerState<AdaptiveReviewScreen> createState() => _AdaptiveReviewScreenState();
}

class _AdaptiveReviewScreenState extends ConsumerState<AdaptiveReviewScreen> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> _reviewItems = [
    {
      'word': 'Clean',
      'emoji': '🧼',
      'mastery': 0.65,
      'sentence': 'We keep our house clean and tidy.',
      'valueTip': 'Cleanliness (Taharah) is half of faith.',
    },
    {
      'word': 'Gentle',
      'emoji': '🤲',
      'mastery': 0.50,
      'sentence': 'We use gentle hands with little animals.',
      'valueTip': 'Gentleness makes everything beautiful.',
    },
    {
      'word': 'Table',
      'emoji': '',
      'mastery': 0.70,
      'sentence': 'We sit around the table and say Bismillah.',
      'valueTip': 'Saying Bismillah brings barakah to our food.',
    },
  ];

  void _speakWord(String word, String sentence) {
    ref.read(audioServiceProvider).playSentence('$word. $sentence');
  }

  void _onNext() {
    if (_currentIndex + 1 < _reviewItems.length) {
      setState(() => _currentIndex++);
      final next = _reviewItems[_currentIndex];
      _speakWord(next['word'] as String, next['sentence'] as String);
    } else {
      ref.read(activeChildProfileProvider.notifier).addRewards(xp: 15, coins: 10, stars: 1);
      ref.read(audioServiceProvider).playReward();
      _showReviewCompleteDialog();
    }
  }

  void _showReviewCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedXl),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.psychology_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Memory Refreshed! 🧠🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You strengthened your mastery on review words!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 15),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 10),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 1),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Back to Home 🏠',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go(RouteNames.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final item = _reviewItems[_currentIndex];
    final mastery = (item['mastery'] as double);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Memory Review (${_currentIndex + 1}/${_reviewItems.length})',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            GuideCharacterBanner(
              message: 'Pip says: "Let’s refresh our memory on words we practiced before!"',
              onSpeakTap: () => _speakWord(item['word'] as String, item['sentence'] as String),
            ),
            const SizedBox(height: 20),

            AppCard(
              borderColor: AppColors.primary,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  item['word'] == 'Table'
                      ? const ChildTableVisual(width: 84, height: 60)
                      : Text(item['emoji'] as String, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['word'] as String, style: AppTypography.displayLarge.copyWith(color: AppColors.primaryDark)),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 32),
                        onPressed: () => _speakWord(item['word'] as String, item['sentence'] as String),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mastery Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Mastery: ${(mastery * 100).toInt()}%', style: AppTypography.badgeText),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 100,
                        child: LinearProgressIndicator(
                          value: mastery,
                          backgroundColor: AppColors.cardBorder,
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.correctGreen),
                          borderRadius: AppRadius.roundedPill,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.roundedMd,
                    ),
                    child: Text(
                      '🗣️ "${item['sentence']}"',
                      style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            AppButton(
              text: _currentIndex + 1 < _reviewItems.length ? 'Next Review Word ▶' : 'Finish Practice! 🌟',
              minWidth: double.infinity,
              height: 56,
              backgroundColor: AppColors.secondary,
              onPressed: _onNext,
            ),
          ],
        ),
      ),
    );
  }
}
