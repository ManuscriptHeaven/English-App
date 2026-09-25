import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/core/widgets/app_scaffold.dart';
import 'package:kids_english_adventure/core/widgets/guide_character.dart';
import 'package:kids_english_adventure/core/widgets/reward_badge.dart';
import 'package:kids_english_adventure/core/widgets/value_pill.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class PoliteRequestsDialogueScreen extends ConsumerStatefulWidget {
  const PoliteRequestsDialogueScreen({super.key});

  @override
  ConsumerState<PoliteRequestsDialogueScreen> createState() => _PoliteRequestsDialogueScreenState();
}

class _PoliteRequestsDialogueScreenState extends ConsumerState<PoliteRequestsDialogueScreen> {
  int _currentDialogueIndex = 0;
  int _currentTurn = 0;

  final List<Map<String, dynamic>> _dialogues = [
    {
      'title': 'Borrowing a Pencil ✏️',
      'turns': [
        {'speaker': 'Ayaan', 'text': 'Can I borrow a pencil, please?', 'emoji': '👦', 'isChild': true},
        {'speaker': 'Tariq', 'text': 'Yes, of course! Here you go.', 'emoji': '🧒', 'isChild': false},
        {'speaker': 'Ayaan', 'text': 'Thank you so much!', 'emoji': '👦', 'isChild': true},
        {'speaker': 'Tariq', 'text': 'You are welcome!', 'emoji': '🧒', 'isChild': false},
      ],
      'manner': 'Always say "Please" when asking and "Thank you" when receiving.',
    },
    {
      'title': 'Asking Teacher for Help 👨‍🏫',
      'turns': [
        {'speaker': 'Ayaan', 'text': 'Excuse me, teacher. Can you please help me?', 'emoji': '👦', 'isChild': true},
        {'speaker': 'Teacher', 'text': 'Yes, Ayaan! I am happy to help.', 'emoji': '👨‍🏫', 'isChild': false},
        {'speaker': 'Ayaan', 'text': 'Thank you, teacher!', 'emoji': '👦', 'isChild': true},
      ],
      'manner': 'Say "Excuse me" before interrupting and listen respectfully.',
    },
  ];

  void _speakTurn(String text) {
    ref.read(audioServiceProvider).playSentence(text);
  }

  void _onNextTurn() {
    final d = _dialogues[_currentDialogueIndex];
    final turns = d['turns'] as List;

    if (_currentTurn + 1 < turns.length) {
      setState(() => _currentTurn++);
      _speakTurn(turns[_currentTurn]['text'] as String);
    } else if (_currentDialogueIndex + 1 < _dialogues.length) {
      setState(() {
        _currentDialogueIndex++;
        _currentTurn = 0;
      });
      _speakTurn(_dialogues[_currentDialogueIndex]['turns'][0]['text'] as String);
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_polite_requests',
            nextActivityId: 'activity_honesty_challenge',
            xp: 30,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
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
              const Icon(Icons.favorite_rounded, size: 72, color: AppColors.valueEmerald),
              const SizedBox(height: 12),
              Text('Polite Speaker Hero! 🗣️❤️', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'MashaAllah! You practiced respectful, polite classroom speech!\nNext up: Honesty & Helping Challenge!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 30),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 15),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Play Honesty Challenge 🌟 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.honestyChallenge);
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
    final d = _dialogues[_currentDialogueIndex];
    final turns = d['turns'] as List;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Dialogue Lab (${_currentDialogueIndex + 1}/${_dialogues.length})',
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
              message: 'Polite words bring friendship and love! Tap each speech bubble to hear!',
            ),
            const SizedBox(height: 16),

            Text(d['title'] as String, style: AppTypography.headlineLarge),
            const SizedBox(height: 14),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentTurn + 1,
              itemBuilder: (context, idx) {
                final turn = turns[idx];
                final isChild = turn['isChild'] as bool;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: isChild ? MainAxisAlignment.start : MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isChild) ...[
                        Text(turn['emoji'] as String, style: const TextStyle(fontSize: 36)),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: AppCard(
                          backgroundColor: isChild ? AppColors.primaryLight : AppColors.valueMint,
                          borderColor: isChild ? AppColors.primary : AppColors.valueEmerald,
                          padding: const EdgeInsets.all(14),
                          onTap: () => _speakTurn(turn['text'] as String),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                turn['speaker'] as String,
                                style: AppTypography.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isChild ? AppColors.primaryDark : AppColors.valueEmerald,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                turn['text'] as String,
                                style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!isChild) ...[
                        const SizedBox(width: 8),
                        Text(turn['emoji'] as String, style: const TextStyle(fontSize: 36)),
                      ],
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            ValueBanner(
              title: 'Good Speech Sunnah',
              description: d['manner'] as String,
              arabicPhrase: 'Al-Kalam at-Tayyib',
            ),
            const SizedBox(height: 20),

            AppButton(
              text: _currentTurn + 1 < turns.length
                  ? 'Continue Conversation 🗣️ ▶'
                  : (_currentDialogueIndex + 1 < _dialogues.length ? 'Next Dialogue ▶' : 'Complete Dialogue Lab! 🚀'),
              minWidth: double.infinity,
              height: 56,
              backgroundColor: AppColors.secondary,
              onPressed: _onNextTurn,
            ),
          ],
        ),
      ),
    );
  }
}
