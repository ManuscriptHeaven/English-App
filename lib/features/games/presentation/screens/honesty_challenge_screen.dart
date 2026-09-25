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

class HonestyChallengeScreen extends ConsumerStatefulWidget {
  const HonestyChallengeScreen({super.key});

  @override
  ConsumerState<HonestyChallengeScreen> createState() => _HonestyChallengeScreenState();
}

class _HonestyChallengeScreenState extends ConsumerState<HonestyChallengeScreen> {
  int _currentScenario = 0;
  int? _selectedChoiceIndex;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _scenarios = [
    {
      'title': 'The Lost Pencil ✏️',
      'emoji': '✏️',
      'situation': 'You find a shiny blue pencil on the classroom floor. What should you do?',
      'choices': [
        {'text': 'Return it to the teacher or friend 👨‍🏫', 'isRight': true},
        {'text': 'Keep it in your pocket secretly 🙈', 'isRight': false},
        {'text': 'Throw it outside 🗑️', 'isRight': false},
      ],
      'lesson': 'Truthfulness & Honesty (Sidq) means returning things that belong to others!',
      'value': 'Honesty / Sidq',
    },
    {
      'title': 'Dropped Books in the Hall 📚',
      'emoji': '📚',
      'situation': 'A friend accidentally dropped heavy books on the floor. What should you do?',
      'choices': [
        {'text': 'Walk away and ignore 🏃', 'isRight': false},
        {'text': 'Help pick up the books with a smile 🤝', 'isRight': true},
        {'text': 'Laugh at them 😆', 'isRight': false},
      ],
      'lesson': 'Helping our brothers and sisters in need brings great reward and love.',
      'value': 'Kindness & Helping',
    },
    {
      'title': 'Spilled Water Bottle 💧',
      'emoji': '💧',
      'situation': 'You accidentally tipped over water on the desk. What should you do?',
      'choices': [
        {'text': 'Say "Sorry, let me clean it" and wipe it 🧽', 'isRight': true},
        {'text': 'Blame someone else 🤥', 'isRight': false},
        {'text': 'Run out of class 🏃', 'isRight': false},
      ],
      'lesson': 'Taking responsibility and speaking truth brings peace of mind.',
      'value': 'Responsibility & Truth',
    },
  ];

  void _onChoiceTap(int index) {
    if (_selectedChoiceIndex != null && _isCorrect == true) return;

    final sc = _scenarios[_currentScenario];
    final isRight = (sc['choices'][index]['isRight'] as bool);

    setState(() {
      _selectedChoiceIndex = index;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_currentScenario + 1 < _scenarios.length) {
      setState(() {
        _currentScenario++;
        _selectedChoiceIndex = null;
        _isCorrect = null;
      });
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_honesty_challenge',
            nextActivityId: 'activity_story_school',
            xp: 25,
            coins: 20,
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
              const Icon(Icons.verified_rounded, size: 72, color: AppColors.valueEmerald),
              const SizedBox(height: 12),
              Text('Honesty Hero! 🌟🕊️', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'MashaAllah! You made truthful, kind, and responsible choices!\nNext up: Story "The Honest Pencil"!',
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
                text: 'Read "The Honest Pencil" 📖 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.storyPath('story_honest_pencil'));
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
    final sc = _scenarios[_currentScenario];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Honesty Dilemmas (${_currentScenario + 1}/${_scenarios.length})',
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
              message: 'What is the honest and kind choice in this situation?',
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: AppColors.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(sc['emoji'] as String, style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 12),
                  Text(sc['title'] as String, style: AppTypography.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    sc['situation'] as String,
                    style: AppTypography.bodyLarge.copyWith(fontSize: 18, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (sc['choices'] as List).length,
              itemBuilder: (context, idx) {
                final choice = sc['choices'][idx];
                final isSelected = _selectedChoiceIndex == idx;

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
                    onTap: () => _onChoiceTap(idx),
                    child: Text(
                      choice['text'] as String,
                      style: AppTypography.titleLarge.copyWith(fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            if (_isCorrect == true) ...[
              ValueBanner(
                title: sc['value'] as String,
                description: sc['lesson'] as String,
                arabicPhrase: 'As-Sidqu Najah',
              ),
              const SizedBox(height: 20),
              AppButton(
                text: 'Next Scenario ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNext,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
