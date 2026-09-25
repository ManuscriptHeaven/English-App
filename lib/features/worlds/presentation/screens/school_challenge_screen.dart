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
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class SchoolChallengeScreen extends ConsumerStatefulWidget {
  const SchoolChallengeScreen({super.key});

  @override
  ConsumerState<SchoolChallengeScreen> createState() => _SchoolChallengeScreenState();
}

class _SchoolChallengeScreenState extends ConsumerState<SchoolChallengeScreen> {
  int _currentStep = 0;
  String? _selectedAnswer;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _challengeSteps = [
    {
      'question': 'Which object do we write with?',
      'options': ['Pencil ✏️', 'Desk', 'Bag 🎒'],
      'correct': 'Pencil ✏️',
      'category': 'Vocabulary',
    },
    {
      'question': 'Complete: "I have two ___ on my desk."',
      'options': ['books 📚', 'book 📖', 'bed 🛏️'],
      'correct': 'books 📚',
      'category': 'Grammar: Plurals',
    },
    {
      'question': 'What polite phrase do we say when someone helps us?',
      'options': ['"Thank you!" 🤲', '"Give me that!"', '"Nothing"'],
      'correct': '"Thank you!" 🤲',
      'category': 'Dialogue & Manners',
    },
    {
      'question': 'What is the honest choice when you find a lost pencil?',
      'options': ['Return it to the teacher 👨‍🏫', 'Hide it in your bag', 'Break it'],
      'correct': 'Return it to the teacher 👨‍🏫',
      'category': 'Honesty / Sidq',
    },
  ];

  void _onAnswerTap(String option) {
    if (_selectedAnswer != null && _isCorrect == true) return;

    final step = _challengeSteps[_currentStep];
    final isRight = (option == step['correct']);

    setState(() {
      _selectedAnswer = option;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_currentStep + 1 < _challengeSteps.length) {
      setState(() {
        _currentStep++;
        _selectedAnswer = null;
        _isCorrect = null;
      });
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_school_challenge',
            xp: 50,
            coins: 30,
            stars: 3,
            unlockedAchievementId: 'ach_honest_helper',
          );
      ref.read(audioServiceProvider).playReward();
      _showTrophyDialog();
    }
  }

  void _showTrophyDialog() {
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
              const Icon(Icons.workspace_premium_rounded, size: 84, color: AppColors.starGold),
              const SizedBox(height: 12),
              Text('School Hero Champion! 🏫🏅', style: AppTypography.displayMedium, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'MashaAllah! You completed all 10 School & Classroom steps!\nYou earned the Honest Helper Medal!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 50),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 30),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Return to Adventure Hub 🌟 ▶',
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
    final step = _challengeSteps[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'School Challenge (${_currentStep + 1}/${_challengeSteps.length})',
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
              message: 'Grand School Challenge! Put all your learning together!',
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.roundedPill,
              ),
              child: Text(
                step['category'] as String,
                style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              borderColor: AppColors.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Text(
                step['question'] as String,
                style: AppTypography.headlineLarge.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (step['options'] as List).length,
              itemBuilder: (context, idx) {
                final opt = step['options'][idx] as String;
                final isSelected = _selectedAnswer == opt;

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

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: AppCard(
                    backgroundColor: bg,
                    borderColor: border,
                    padding: const EdgeInsets.all(16),
                    onTap: () => _onAnswerTap(opt),
                    child: Text(
                      opt,
                      style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: _currentStep + 1 < _challengeSteps.length ? 'Next Question ▶' : 'Claim Honest Helper Medal! 🏆',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNext,
              ),
          ],
        ),
      ),
    );
  }
}
