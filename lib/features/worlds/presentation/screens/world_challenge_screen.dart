import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

class WorldChallengeScreen extends ConsumerStatefulWidget {
  const WorldChallengeScreen({super.key});

  @override
  ConsumerState<WorldChallengeScreen> createState() => _WorldChallengeScreenState();
}

class _WorldChallengeScreenState extends ConsumerState<WorldChallengeScreen> {
  int _questionIndex = 0;
  int? _selectedAnswerIndex;
  bool? _isAnswerCorrect;
  bool _isCompleted = false;

  final List<Map<String, dynamic>> _challengeQuestions = [
    {
      'type': 'vocab',
      'title': 'Question 1: Vocabulary',
      'prompt': 'Which animal is big, gentle, and has a long trunk?',
      'options': ['Elephant 🐘', 'Cat 🐱', 'Lion 🦁'],
      'correctIndex': 0,
      'explanation': 'The elephant is big and gentle!',
    },
    {
      'type': 'listening',
      'title': 'Question 2: Listening',
      'prompt': 'Listen and choose the sentence: "The cat is small."',
      'audioToPlay': 'The cat is small.',
      'options': ['The elephant is big.', 'The cat is small. 🐱', 'The lion is brave.'],
      'correctIndex': 1,
      'explanation': 'Great listening! "The cat is small."',
    },
    {
      'type': 'grammar',
      'title': 'Question 3: Grammar',
      'prompt': 'Complete the sentence: "The lions ___ strong."',
      'options': ['is', 'are', 'am'],
      'correctIndex': 1,
      'explanation': 'Many lions = are ("The lions are strong.")',
    },
    {
      'type': 'sentence',
      'title': 'Question 4: Sentence Meaning',
      'prompt': 'What does "The kitten drinks clean water" mean?',
      'options': [
        'The kitten is drinking fresh, clean water 💧',
        'The kitten is running away 🏃',
        'The kitten is eating fruit 🍎',
      ],
      'correctIndex': 0,
      'explanation': 'Clean water keeps our little animal friends healthy.',
    },
    {
      'type': 'values',
      'title': 'Question 5: Islamic Values & Manners',
      'prompt': 'How does Allah love for us to treat animals?',
      'options': [
        'With gentle hands and kindness ❤️ (Rahmah)',
        'By shouting and making loud noises ❌',
        'By ignoring them 😶',
      ],
      'correctIndex': 0,
      'explanation': 'Rahmah (Mercy and kindness) beautifies all our actions.',
    },
  ];

  void _onAnswer(int selectedIndex, int correctIndex) {
    if (_selectedAnswerIndex != null && _isAnswerCorrect == true) return;

    final isRight = (selectedIndex == correctIndex);
    setState(() {
      _selectedAnswerIndex = selectedIndex;
      _isAnswerCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      } else {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
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
        ref.read(audioServiceProvider).playWordPronunciation(nextQ['audioToPlay'] as String);
      }
    } else {
      // Completed grand challenge!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_final_challenge',
            xp: 50,
            coins: 30,
            stars: 3,
            unlockedAchievementId: 'ach_animal_hero',
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.rewardUnlocked);
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
              const Icon(Icons.military_tech_rounded, size: 96, color: AppColors.starGold),
              const SizedBox(height: 16),
              Text(
                'Animal Adventure Complete! 🎉🏆',
                style: AppTypography.displayLarge.copyWith(color: AppColors.primaryDark),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'MashaAllah! You learned 9 English words, mastered "is/are" grammar, read the story, and practiced Rahmah to animals!',
                style: AppTypography.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Kindness Hero Badge Card
              AppCard(
                backgroundColor: AppColors.valueMint,
                borderColor: AppColors.valueEmerald,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_rounded, color: AppColors.valueEmerald, size: 36),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Badge Unlocked: Kindness Hero 🏅', style: AppTypography.headlineMedium.copyWith(color: AppColors.valueEmerald)),
                          const SizedBox(height: 4),
                          Text('You showed mercy, care, and gentle hands to Allah’s creatures.', style: AppTypography.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Rewards Row
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

              // Next World Teaser Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.worldHomeBg,
                  borderRadius: AppRadius.roundedLg,
                  border: Border.all(color: AppColors.worldHomeOrange, width: 2),
                ),
                child: Column(
                  children: [
                    Text('Next World: Home & Family 🏡', style: AppTypography.headlineMedium.copyWith(color: AppColors.worldHomeOrange)),
                    const SizedBox(height: 6),
                    Text('Learn family words, helping parents, and cleanliness at home! Coming soon.', style: AppTypography.bodyMedium, textAlign: TextAlign.center),
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
        title: 'Grand Challenge (${_questionIndex + 1}/${_challengeQuestions.length})',
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
              message: 'Show everything you learned in Animal Adventure! You can do it!',
            ),
            const SizedBox(height: 16),

            // Question Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: AppRadius.roundedPill,
              ),
              child: Text(
                q['title'] as String,
                style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark),
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              borderColor: AppColors.primary,
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
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary, size: 36),
                      onPressed: () {
                        ref.read(audioServiceProvider).playWordPronunciation(q['audioToPlay'] as String);
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
                            : AppColors.primaryLight,
                        child: Text(
                          String.fromCharCode(65 + idx),
                          style: AppTypography.badgeText.copyWith(
                            color: isSelected && _isAnswerCorrect == true
                                ? Colors.white
                                : AppColors.primaryDark,
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
                    : 'Claim Grand Victory! 🏆 ▶',
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
