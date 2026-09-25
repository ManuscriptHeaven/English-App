import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/audio_play_button.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

/// Warm, cartoon-integrated Islamic Value Moment Screen (Ages 3–10).
class ValueMomentScreen extends ConsumerStatefulWidget {
  const ValueMomentScreen({super.key});

  @override
  ConsumerState<ValueMomentScreen> createState() => _ValueMomentScreenState();
}

class _ValueMomentScreenState extends ConsumerState<ValueMomentScreen> {
  int? _selectedChoiceIndex;
  bool? _isChoiceCorrect;

  final List<Map<String, dynamic>> _choices = [
    {
      'title': 'Gently with clean water ❤️',
      'emoji': '🥣',
      'isCorrect': true,
      'feedback': 'Yes! Kindness (Rahmah) to animals brings Allah’s immense love and light!',
    },
    {
      'title': 'Roughly and loudly ❌',
      'emoji': '📢',
      'isCorrect': false,
      'feedback': 'Remember: Gentle explorers always use soft hands and quiet voices.',
    },
  ];

  void _onChoice(int index) {
    final choice = _choices[index];
    final isRight = choice['isCorrect'] as bool;

    setState(() {
      _selectedChoiceIndex = index;
      _isChoiceCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onFinish() {
    ref.read(activeChildProfileProvider.notifier).completeActivity(
          'activity_value_moment',
          nextActivityId: 'activity_story_read',
          xp: 25,
          coins: 20,
          stars: 3,
        );
    ref.read(audioServiceProvider).playReward();
    _showMedalDialog();
  }

  void _showMedalDialog() {
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
              const Text('🏅💖', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 12),
              Text('Kindness Medal! ❤️🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You practiced the noble value of Rahmah (Mercy)!\nNext up: Story Adventure!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 25),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 20),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Read Animal Story 📖 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.valueEmerald,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.storyPath('story_animal_park'));
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
    const dilemmaPrompt = 'Ayaan sees a thirsty little kitten in the park. How should we treat it?';

    return Scaffold(
      backgroundColor: const Color(0xFFE8F8F5), // Gentle mint aesthetic
      appBar: ChildHeaderBar(
        title: 'Rahmah (Mercy) Moment 🌟',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Center Pip Character Guide with Question Bubble
            PipCharacterGuide(
              state: _isChoiceCorrect == true ? PipState.celebrating : PipState.hinting,
              speechBubbleText: dilemmaPrompt,
              characterSize: 96,
            ),
            const SizedBox(height: 12),

            // Audio Narration
            AudioPlayButton(
              textToSpeak: dilemmaPrompt,
              label: 'Hear Question',
              priority: AudioPriority.learningInstruction,
            ),
            const SizedBox(height: 24),

            // Illustrated Dilemma Image Stage
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.roundedXl,
                border: Border.all(color: AppColors.valueEmerald, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.valueEmerald.withAlpha(40),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  Text('🐱 🌳 ☀️ 💧', style: TextStyle(fontSize: 52)),
                  SizedBox(height: 8),
                  Text(
                    'The kitten is thirsty under the sun.',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Large Choice Cards
            ..._choices.asMap().entries.map((entry) {
              final idx = entry.key;
              final choice = entry.value;
              final isSelected = _selectedChoiceIndex == idx;

              Color bg = Colors.white;
              Color border = AppColors.cardBorder;

              if (isSelected) {
                if (_isChoiceCorrect == true) {
                  bg = AppColors.correctGreen.withAlpha(35);
                  border = AppColors.correctGreen;
                } else {
                  bg = AppColors.tryAgainOrange.withAlpha(35);
                  border = AppColors.tryAgainOrange;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: GestureDetector(
                  onTap: () => _onChoice(idx),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: AppRadius.roundedLg,
                      border: Border.all(color: border, width: isSelected ? 3 : 2),
                      boxShadow: [
                        BoxShadow(
                          color: border.withAlpha(40),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(choice['emoji'] as String, style: const TextStyle(fontSize: 36)),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            choice['title'] as String,
                            style: AppTypography.headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),

            if (_selectedChoiceIndex != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isChoiceCorrect == true ? AppColors.valueMint : AppColors.tryAgainOrange.withAlpha(30),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Text(
                  _choices[_selectedChoiceIndex!]['feedback'] as String,
                  style: AppTypography.bodyMedium.copyWith(
                    color: _isChoiceCorrect == true ? AppColors.valueEmerald : AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (_isChoiceCorrect == true)
              AppButton(
                text: 'Claim Kindness Medal! 🏅 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.valueEmerald,
                foregroundColor: Colors.white,
                onPressed: _onFinish,
              ),
          ],
        ),
      ),
    );
  }
}
