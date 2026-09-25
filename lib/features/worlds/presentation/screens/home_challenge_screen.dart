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
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';

class HomeChallengeScreen extends ConsumerStatefulWidget {
  const HomeChallengeScreen({super.key});

  @override
  ConsumerState<HomeChallengeScreen> createState() => _HomeChallengeScreenState();
}

class _HomeChallengeScreenState extends ConsumerState<HomeChallengeScreen> {
  int _questionIndex = 0;
  int? _selectedAnswerIndex;
  bool? _isAnswerCorrect;
  bool _isCompleted = false;

  final List<Map<String, dynamic>> _challengeQuestions = [
    {
      'type': 'vocab',
      'title': 'Question 1: Home Words',
      'prompt': 'Which item do we use for reading colorful stories?',
      'options': ['Book 📚', 'Chair 🪑', 'Door 🚪'],
      'correctIndex': 0,
      'explanation': 'Books give us knowledge and wisdom!',
    },
    {
      'type': 'listening',
      'title': 'Question 2: Listening',
      'prompt': 'Listen and choose the sentence: "This is my room."',
      'audioToPlay': 'This is my room.',
      'options': ['This is a lion.', 'This is my room. 🚪', 'I have an apple.'],
      'correctIndex': 1,
      'explanation': 'Great listening! "This is my room."',
    },
    {
      'type': 'grammar',
      'title': 'Question 3: Grammar',
      'prompt': 'Complete the sentence: "She ___ helping mother at home."',
      'options': ['is', 'are', 'am'],
      'correctIndex': 0,
      'explanation': 'She = is ("She is helping mother.")',
    },
    {
      'type': 'sentence',
      'title': 'Question 4: Sentence Construction',
      'prompt': 'What does "I have a book" mean?',
      'options': [
        'I hold or own a storybook 📚',
        'I am running fast 🏃',
        'I am sleeping in bed 🛏️',
      ],
      'correctIndex': 0,
      'explanation': '"I have a book" expresses holding or owning something.',
    },
    {
      'type': 'values',
      'title': 'Question 5: Sunnah & Home Manners',
      'prompt': 'What do we say before eating our meal with family?',
      'options': [
        'Bismillah 🍽️ (In the name of Allah)',
        'Goodbye 👋',
        'Nothing 😶',
      ],
      'correctIndex': 0,
      'explanation': 'Saying Bismillah brings barakah, light, and blessings to our food.',
    },
  ];

  void _onAnswer(int selectedIndex, int correctIndex) {
    if (_selectedAnswerIndex != null && _isAnswerCorrect == true) return;

    final isRight = (selectedIndex == correctIndex);
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswerCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_questionIndex + 1 < _challengeQuestions.length) {
      setState(() {
        _questionIndex++;
        _selectedAnswerIndex = null;
        _isAnswerCorrect = null;
      });
      final nextQ = _challengeQuestions[_questionIndex];
      if (nextQ.containsKey('audioToPlay')) {
        ref.read(audioServiceProvider).playSentence(nextQ['audioToPlay'] as String);
      }
    } else {
      // Completed grand home challenge!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_home_challenge',
            xp: 50,
            coins: 30,
            stars: 3,
            unlockedAchievementId: 'ach_home_helper',
          );
      ref.read(audioServiceProvider).playReward();
      setState(() {
        _isCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);

    if (_isCompleted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: ChildHeaderBar(
          title: 'Victory!',
          stars: activeChild?.stars ?? 0,
          coins: activeChild?.coins ?? 0,
          streak: activeChild?.streakDays ?? 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Icon(Icons.stars_rounded, size: 96, color: AppColors.worldHomeOrange),
              const SizedBox(height: 16),
              Text(
                'Home & Family Complete! 🏡🎉',
                style: AppTypography.displayLarge.copyWith(color: AppColors.worldHomeOrange),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'MashaAllah! You learned household words, family nouns, helping verbs, and practiced filial respect and Sunnah manners!',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Home Helper Badge Card
              AppCard(
                backgroundColor: AppColors.worldHomeBg,
                borderColor: AppColors.worldHomeOrange,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.handshake_rounded, color: AppColors.worldHomeOrange, size: 36),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Badge Unlocked: Home Helper 🏅', style: AppTypography.headlineMedium.copyWith(color: AppColors.worldHomeOrange)),
                          const SizedBox(height: 4),
                          Text('You practiced helping parents, tidying rooms, and saying Bismillah!', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 50),
                  SizedBox(width: 12),
                  RewardBadge(type: BadgeType.coin, count: 30),
                  SizedBox(width: 12),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),

              // Next World Teaser
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.roundedLg,
                  border: Border.all(color: AppColors.primary, width: 2),
                ),
                child: Column(
                  children: [
                    Text('Next World: School & Classroom 🏫', style: AppTypography.headlineMedium.copyWith(color: AppColors.primaryDark)),
                    const SizedBox(height: 6),
                    Text('Learn classroom objects, respectful speech with teachers, and honesty! Coming soon.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              AppButton(
                text: 'Return to Adventure Hub 🚀',
                minWidth: double.infinity,
                height: 60,
                backgroundColor: AppColors.secondary,
                onPressed: () => context.go(RouteNames.home),
              ),
            ],
          ),
        ),
      );
    }

    final q = _challengeQuestions[_questionIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Home Challenge (${_questionIndex + 1}/${_challengeQuestions.length})',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GuideCharacterBanner(
              message: 'Show everything you learned in Home & Family! You’ve got this!',
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.worldHomeBg,
                borderRadius: AppRadius.roundedPill,
              ),
              child: Text(
                q['title'] as String,
                style: AppTypography.badgeText.copyWith(color: AppColors.worldHomeOrange),
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              borderColor: AppColors.worldHomeOrange,
              child: Column(
                children: [
                  Text(
                    q['prompt'] as String,
                    style: AppTypography.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                  if (q.containsKey('audioToPlay')) ...[
                    const SizedBox(height: 12),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.worldHomeOrange, size: 36),
                      onPressed: () {
                        ref.read(audioServiceProvider).playSentence(q['audioToPlay'] as String);
                      },
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            ...((q['options'] as List<String>).asMap().entries.map((entry) {
              final idx = entry.key;
              final opt = entry.value;
              final isSelected = _selectedAnswerIndex == idx;

              Color bg = Colors.white;
              Color border = AppColors.cardBorder;

              if (isSelected) {
                if (_isAnswerCorrect == true) {
                  bg = AppColors.correctGreen.withValues(alpha: 0.15);
                  border = AppColors.correctGreen;
                } else {
                  bg = AppColors.tryAgainOrange.withValues(alpha: 0.15);
                  border = AppColors.tryAgainOrange;
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: AppCard(
                  backgroundColor: bg,
                  borderColor: border,
                  onTap: () => _onAnswer(idx, q['correctIndex'] as int),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: isSelected && _isAnswerCorrect == true
                            ? AppColors.correctGreen
                            : AppColors.worldHomeBg,
                        child: Text(
                          String.fromCharCode(65 + idx),
                          style: AppTypography.badgeText.copyWith(
                            color: isSelected && _isAnswerCorrect == true
                                ? Colors.white
                                : AppColors.worldHomeOrange,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(opt, style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              );
            })),

            if (_isAnswerCorrect != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: _isAnswerCorrect == true
                      ? AppColors.valueMint
                      : AppColors.tryAgainOrange.withValues(alpha: 0.15),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Text(
                  _isAnswerCorrect == true ? '🌟 ${q['explanation']}' : 'Good try! Let’s think carefully.',
                  style: AppTypography.bodyMedium.copyWith(
                    color: _isAnswerCorrect == true ? AppColors.valueEmerald : AppColors.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
            ],

            if (_isAnswerCorrect == true)
              AppButton(
                text: _questionIndex + 1 < _challengeQuestions.length
                    ? 'Next Question ▶'
                    : 'Claim Home Helper Medal! 🏆 ▶',
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
