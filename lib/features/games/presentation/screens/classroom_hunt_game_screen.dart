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
import 'package:kids_english_adventure/core/widgets/child_table_visual.dart';
import 'package:kids_english_adventure/core/widgets/guide_character.dart';
import 'package:kids_english_adventure/core/widgets/reward_badge.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class ClassroomHuntGameScreen extends ConsumerStatefulWidget {
  const ClassroomHuntGameScreen({super.key});

  @override
  ConsumerState<ClassroomHuntGameScreen> createState() => _ClassroomHuntGameScreenState();
}

class _ClassroomHuntGameScreenState extends ConsumerState<ClassroomHuntGameScreen> {
  int _currentRound = 0;
  String? _selectedCard;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _rounds = [
    {
      'targetWord': 'Pencil',
      'prompt': 'Find the Pencil! ✏️',
      'options': [
        {'word': 'Desk', 'emoji': ''},
        {'word': 'Pencil', 'emoji': '✏️'},
        {'word': 'Bag', 'emoji': '🎒'},
      ],
      'clue': 'Look for the yellow tool you write with!',
    },
    {
      'targetWord': 'Desk',
      'prompt': 'Find the Desk! ✨',
      'options': [
        {'word': 'Desk', 'emoji': ''},
        {'word': 'Chair', 'emoji': '🪑'},
        {'word': 'Door', 'emoji': '🚪'},
      ],
      'clue': 'Look for where you place your book and notebooks!',
    },
    {
      'targetWord': 'School Bag',
      'prompt': 'Find the School Bag! 🎒',
      'options': [
        {'word': 'Book', 'emoji': '📚'},
        {'word': 'Bed', 'emoji': '🛏️'},
        {'word': 'School Bag', 'emoji': '🎒'},
      ],
      'clue': 'Look for what carries all your learning supplies!',
    },
    {
      'targetWord': 'Book',
      'prompt': 'Find the Book! 📚',
      'options': [
        {'word': 'Desk', 'emoji': ''},
        {'word': 'Book', 'emoji': '📚'},
        {'word': 'Pencil', 'emoji': '✏️'},
      ],
      'clue': 'Look for the colorful story with pages!',
    },
  ];

  void _onCardTap(String word) {
    if (_selectedCard != null && _isCorrect == true) return;

    final round = _rounds[_currentRound];
    final isRight = (word == round['targetWord']);

    setState(() {
      _selectedCard = word;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNextRound() {
    if (_currentRound + 1 < _rounds.length) {
      setState(() {
        _currentRound++;
        _selectedCard = null;
        _isCorrect = null;
      });
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_classroom_hunt',
            nextActivityId: 'activity_listen_find_school',
            xp: 25,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
      _showVictoryDialog();
    }
  }

  void _showVictoryDialog() {
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
              const Icon(Icons.celebration_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Classroom Hunter Champion! 🏫🏆', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'Super job finding all classroom objects!\nNext up: Listen & Find School!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 25),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 15),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Play Listen & Find 🎧 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.listenAndFindSchool);
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
    final round = _rounds[_currentRound];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Classroom Hunt (${_currentRound + 1}/${_rounds.length})',
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
              message: _isCorrect == false
                  ? 'Good try! ${round['clue']}'
                  : 'Can you spot which card has the ${round['targetWord']}?',
              onSpeakTap: () {
                ref.read(audioServiceProvider).playGamePrompt(round['prompt'] as String);
              },
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: AppColors.primary,
              child: Text(
                round['prompt'] as String,
                style: AppTypography.displayMedium.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: (round['options'] as List).length,
              itemBuilder: (context, idx) {
                final opt = round['options'][idx];
                final isSelected = _selectedCard == opt['word'];

                Color bg = Colors.white;
                Color border = AppColors.cardBorder;

                if (isSelected) {
                  if (_isCorrect == true) {
                    bg = AppColors.correctGreen.withValues(alpha: 0.2);
                    border = AppColors.correctGreen;
                  } else {
                    bg = AppColors.tryAgainOrange.withValues(alpha: 0.2);
                    border = AppColors.tryAgainOrange;
                  }
                }

                return AppCard(
                  backgroundColor: bg,
                  borderColor: border,
                  onTap: () => _onCardTap(opt['word'] as String),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      opt['word'] == 'Desk'
                          ? const ChildTableVisual(width: 58, height: 42)
                          : Text(opt['emoji'] as String, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 6),
                      Text(
                        opt['word'] as String,
                        style: AppTypography.titleLarge.copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Awesome! Next Round ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNextRound,
              ),
          ],
        ),
      ),
    );
  }
}
