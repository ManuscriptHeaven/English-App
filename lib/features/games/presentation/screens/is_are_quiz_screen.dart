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

class IsAreQuizScreen extends ConsumerStatefulWidget {
  const IsAreQuizScreen({super.key});

  @override
  ConsumerState<IsAreQuizScreen> createState() => _IsAreQuizScreenState();
}

class _IsAreQuizScreenState extends ConsumerState<IsAreQuizScreen> {
  int _roundIndex = 0;
  String? _selectedOption;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _questions = [
    {
      'prefix': 'The cat',
      'suffix': 'small.',
      'correct': 'is',
      'emoji': '🐱',
      'explanation': 'One cat = is ("The cat is small.")',
    },
    {
      'prefix': 'The lions',
      'suffix': 'big and strong.',
      'correct': 'are',
      'emoji': '🦁🦁',
      'explanation': 'Many lions = are ("The lions are big.")',
    },
    {
      'prefix': 'The elephant',
      'suffix': 'gentle.',
      'correct': 'is',
      'emoji': '🐘',
      'explanation': 'One elephant = is ("The elephant is gentle.")',
    },
    {
      'prefix': 'The birds',
      'suffix': 'flying in the sky.',
      'correct': 'are',
      'emoji': '🐦🐦',
      'explanation': 'Many birds = are ("The birds are flying.")',
    },
  ];

  void _onSelect(String option) {
    if (_selectedOption != null && _isCorrect == true) return;

    final q = _questions[_roundIndex];
    final isRight = (option == q['correct']);

    setState(() {
      _selectedOption = option;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
        final fullSentence = '${q['prefix']} $option ${q['suffix']}';
        ref.read(audioServiceProvider).playWordPronunciation(fullSentence);
      } else {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    });
  }

  void _onNext() {
    if (_roundIndex + 1 < _questions.length) {
      setState(() {
        _roundIndex++;
        _selectedOption = null;
        _isCorrect = null;
      });
    } else {
      // Completed game!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_grammar_is_are',
            nextActivityId: 'activity_value_moment',
            xp: 30,
            coins: 15,
            stars: 3,
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
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
              const Icon(Icons.verified_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Grammar Champ! ⚖️🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You mastered "is" and "are" with singular and plural friends!\nNext: Islamic Values Moment ❤️',
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
                text: 'Values Moment ❤️ ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.valueMoment);
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
    final q = _questions[_roundIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Is vs Are (${_roundIndex + 1}/${_questions.length})',
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
              message: 'Choose "is" for one friend, or "are" for many friends!',
            ),
            const SizedBox(height: 20),

            Text(q['emoji'] as String, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),

            // Sentence Card with Blank
            AppCard(
              borderColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: AppTypography.displayMedium.copyWith(fontSize: 26),
                      children: [
                        TextSpan(text: '${q['prefix']} '),
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: _selectedOption != null
                                  ? (_isCorrect == true ? AppColors.correctGreen : AppColors.tryAgainOrange)
                                  : AppColors.primaryLight,
                              borderRadius: AppRadius.roundedMd,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _selectedOption ?? '___',
                              style: AppTypography.displayMedium.copyWith(
                                fontSize: 24,
                                color: _selectedOption != null ? Colors.white : AppColors.primaryDark,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: ' ${q['suffix']}'),
                      ],
                    ),
                  ),
                  if (_isCorrect != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      q['explanation'] as String,
                      style: AppTypography.bodyMedium.copyWith(
                        color: _isCorrect == true ? AppColors.correctGreen : AppColors.tryAgainOrange,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Choice Buttons: IS / ARE
            Row(
              children: ['is', 'are'].map((choice) {
                final isSelected = _selectedOption == choice;
                Color bg = AppColors.secondary;
                if (isSelected) {
                  bg = _isCorrect == true ? AppColors.correctGreen : AppColors.tryAgainOrange;
                }

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: AppButton(
                      text: choice.toUpperCase(),
                      height: 64,
                      backgroundColor: bg,
                      foregroundColor: isSelected ? Colors.white : AppColors.textPrimary,
                      onPressed: () => _onSelect(choice),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Next Question ▶',
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
