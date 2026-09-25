import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../../core/widgets/value_pill.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../worlds/domain/models/lesson.dart';
import '../../../worlds/domain/models/question.dart';
import '../../../worlds/presentation/providers/world_providers.dart';

class LessonShellScreen extends ConsumerStatefulWidget {
  final String lessonId;

  const LessonShellScreen({super.key, required this.lessonId});

  @override
  ConsumerState<LessonShellScreen> createState() => _LessonShellScreenState();
}

class _LessonShellScreenState extends ConsumerState<LessonShellScreen> {
  int _currentActivityIndex = 0;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isCompleted = false;
  String? _selectedOption;
  bool? _isCorrect;

  void _checkAnswer(Question question, String option) {
    setState(() {
      _selectedOption = option;
      _isCorrect = (option == question.correctAnswer);
      if (_isCorrect == true) {
        _score += 10;
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      } else {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    });
  }

  void _nextQuestion(Lesson lesson) {
    final currentActivity = lesson.activities[_currentActivityIndex];
    if (_currentQuestionIndex + 1 < currentActivity.questions.length) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = null;
        _isCorrect = null;
      });
    } else if (_currentActivityIndex + 1 < lesson.activities.length) {
      setState(() {
        _currentActivityIndex++;
        _currentQuestionIndex = 0;
        _selectedOption = null;
        _isCorrect = null;
      });
    } else {
      // Lesson finished! Award rewards to child profile
      ref.read(activeChildProfileProvider.notifier).addRewards(
            xp: lesson.rewardXp,
            coins: lesson.rewardCoins,
            stars: lesson.rewardStars,
          );
      ref.read(audioServiceProvider).playSoundEffect(SoundEffect.levelComplete);
      setState(() {
        _isCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessonAsync = ref.watch(lessonDetailProvider(widget.lessonId));
    final activeChild = ref.watch(activeChildProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Learning Adventure',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: lessonAsync.when(
        loading: () => const LoadingView(message: 'Loading lesson activities...'),
        error: (err, _) => ErrorView(message: err.toString()),
        data: (lesson) {
          if (lesson == null) {
            return const EmptyView(title: 'Lesson Not Found', subtitle: 'Could not load the requested lesson.');
          }

          if (lesson.activities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.construction_rounded, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    Text('Activities Coming Soon!', style: AppTypography.headlineMedium),
                    const SizedBox(height: 8),
                    Text(
                      'This lesson is ready in the architecture and content will be populated in next stage.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyMedium,
                    ),
                    const SizedBox(height: 20),
                    AppButton(
                      text: 'Go Back',
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            );
          }

          if (_isCompleted) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, size: 80, color: AppColors.starGold),
                    const SizedBox(height: 16),
                    Text('MashaAllah! Great Job!', style: AppTypography.displayMedium),
                    const SizedBox(height: 8),
                    Text('You completed "${lesson.title}"', style: AppTypography.titleLarge),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RewardBadge(type: BadgeType.xp, count: lesson.rewardXp + _score),
                        const SizedBox(width: 12),
                        RewardBadge(type: BadgeType.coin, count: lesson.rewardCoins),
                        const SizedBox(width: 12),
                        RewardBadge(type: BadgeType.star, count: lesson.rewardStars),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const ValueBanner(
                      title: 'Kindness Hero Badge Unlocked!',
                      description: 'Allah loves when you learn with a happy, kind, and hardworking heart!',
                      arabicPhrase: 'Alhamdulillah',
                    ),
                    const SizedBox(height: 32),
                    AppButton(
                      text: 'Continue Adventure! 🚀',
                      minWidth: double.infinity,
                      height: 60,
                      backgroundColor: AppColors.secondary,
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            );
          }

          final currentActivity = lesson.activities[_currentActivityIndex];
          final currentQuestion = currentActivity.questions[_currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Activity Step Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: AppRadius.roundedPill,
                      ),
                      child: Text(
                        'Step ${_currentActivityIndex + 1}/${lesson.activities.length}: ${currentActivity.title}',
                        style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark),
                      ),
                    ),
                    const ValuePill(title: 'Kindness Value', icon: Icons.favorite_rounded),
                  ],
                ),
                const SizedBox(height: 16),

                // Question Card
                AppCard(
                  borderColor: AppColors.primary,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        currentQuestion.prompt,
                        style: AppTypography.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      IconButton(
                        iconSize: 44,
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.primary),
                        onPressed: () {
                          ref.read(audioServiceProvider).playWordPronunciation(currentQuestion.prompt);
                        },
                      ),
                      if (currentQuestion.valueTip != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.valueMint,
                            borderRadius: AppRadius.roundedMd,
                          ),
                          child: Text(
                            '💡 ${currentQuestion.valueTip!}',
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.valueEmerald),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Options
                Expanded(
                  child: ListView.separated(
                    itemCount: currentQuestion.options.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = currentQuestion.options[index];
                      final isSelected = _selectedOption == option;

                      Color buttonColor = AppColors.surface;
                      Color borderColor = AppColors.cardBorder;

                      if (isSelected) {
                        if (_isCorrect == true) {
                          buttonColor = AppColors.correctGreen.withValues(alpha: 0.2);
                          borderColor = AppColors.correctGreen;
                        } else if (_isCorrect == false) {
                          buttonColor = AppColors.errorRed.withValues(alpha: 0.2);
                          borderColor = AppColors.errorRed;
                        }
                      }

                      return AppCard(
                        backgroundColor: buttonColor,
                        borderColor: borderColor,
                        onTap: _selectedOption == null ? () => _checkAnswer(currentQuestion, option) : null,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.primaryLight,
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: AppTypography.badgeText.copyWith(color: AppColors.primaryDark),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                option,
                                style: AppTypography.headlineMedium,
                              ),
                            ),
                            if (isSelected && _isCorrect == true)
                              const Icon(Icons.check_circle_rounded, color: AppColors.correctGreen, size: 28)
                            else if (isSelected && _isCorrect == false)
                              const Icon(Icons.cancel_rounded, color: AppColors.errorRed, size: 28),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                if (_selectedOption != null) ...[
                  const SizedBox(height: 12),
                  AppButton(
                    text: _isCorrect == true ? 'Great! Next Step ▶' : 'Continue ▶',
                    height: 58,
                    backgroundColor: _isCorrect == true ? AppColors.correctGreen : AppColors.secondary,
                    foregroundColor: _isCorrect == true ? Colors.white : AppColors.textPrimary,
                    onPressed: () => _nextQuestion(lesson),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
