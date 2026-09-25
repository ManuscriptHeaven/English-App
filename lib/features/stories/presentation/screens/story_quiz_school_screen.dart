import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/providers/adventure_brain_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

class SchoolQuizQuestion {
  final String question;
  final List<String> choices;
  final int correctIndex;
  final String positiveFeedback;

  const SchoolQuizQuestion({
    required this.question,
    required this.choices,
    required this.correctIndex,
    required this.positiveFeedback,
  });
}

/// 5-Question Story Comprehension & Islamic Ethics Quiz for "A Pencil for a Friend".
class StoryQuizSchoolScreen extends ConsumerStatefulWidget {
  const StoryQuizSchoolScreen({super.key});

  @override
  ConsumerState<StoryQuizSchoolScreen> createState() => _StoryQuizSchoolScreenState();
}

class _StoryQuizSchoolScreenState extends ConsumerState<StoryQuizSchoolScreen> {
  int _currentIndex = 0;
  int? _selectedIndex;
  bool? _isCorrect;
  bool _isCompleted = false;

  final List<SchoolQuizQuestion> _questions = const [
    SchoolQuizQuestion(
      question: '1. Who needed a pencil in the classroom? ✏️',
      choices: ['Ayaan\'s classmate', 'The bus driver', 'The kitten'],
      correctIndex: 0,
      positiveFeedback: 'Correct! Ayaan noticed his classmate forgot their pencil. 🌟',
    ),
    SchoolQuizQuestion(
      question: '2. What polite words do we say when asking for a pencil? 🗣️',
      choices: ['Give it now!', 'Can I borrow a pencil, please?', 'Move away!'],
      correctIndex: 1,
      positiveFeedback: 'MashaAllah! Courteous requests are beautiful manners! 🤲',
    ),
    SchoolQuizQuestion(
      question: '3. What did Ayaan do to help his friend? 🤝',
      choices: ['He shared his extra pencil', 'He hid his pencil', 'He looked away'],
      correctIndex: 0,
      positiveFeedback: 'SubhanAllah! Sharing brings love and friendship! 💖',
    ),
    SchoolQuizQuestion(
      question: '4. What should you do if you find a lost pencil? 🌟',
      choices: ['Keep it secretly', 'Return it to teacher or owner', 'Throw it'],
      correctIndex: 1,
      positiveFeedback: 'Sidq! Returning lost items is true Islamic honesty! ⭐',
    ),
    SchoolQuizQuestion(
      question: '5. Why is honesty (Sidq) so important? 🤲',
      choices: ['Allah loves truthful people', 'To get ice cream', 'It is a secret'],
      correctIndex: 0,
      positiveFeedback: 'MashaAllah! Truthfulness and honesty are loved by Allah! 🌟',
    ),
  ];

  void _selectChoice(int index) {
    if (_isCorrect == true) return;

    final q = _questions[_currentIndex];
    final isMatch = index == q.correctIndex;

    setState(() {
      _selectedIndex = index;
      _isCorrect = isMatch;
    });

    final activeChild = ref.read(activeChildProfileProvider);
    if (activeChild != null) {
      ref.read(learningSignalRepositoryProvider).recordSignal(
            LearningSignal(
              id: 'sig_story_quiz_${DateTime.now().microsecondsSinceEpoch}',
              childId: activeChild.id,
              skill: SkillType.reading,
              contentId: 'story_quiz_q$_currentIndex',
              activityId: 'activity_story_quiz_school',
              worldId: 'world_school',
              score: isMatch ? 1.0 : 0.4,
              attempts: 1,
              responseTimeMs: 1500,
              timestamp: DateTime.now(),
              mistakeType: isMatch ? MistakeType.none : MistakeType.audioMiscomprehension,
            ),
          );
    }

    if (isMatch) {
      ref.read(audioServiceProvider).playSuccess();
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        if (_currentIndex + 1 < _questions.length) {
          setState(() {
            _currentIndex++;
            _selectedIndex = null;
            _isCorrect = null;
          });
        } else {
          setState(() {
            _isCompleted = true;
          });
          ref.read(audioServiceProvider).playReward();
        }
      });
    } else {
      ref.read(audioServiceProvider).playRetry();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCompleted) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text('Story Quiz Master! 📖⭐'),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: AppCard(
              borderColor: AppColors.primary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🏆📚', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Super Comprehension!', style: AppTypography.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'You answered all 5 story questions and practiced Islamic honesty (Sidq)!',
                    style: AppTypography.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text('⭐ +3 Stars   🔥 +35 XP   🪙 +20 Coins',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.secondaryDark)),
                  const SizedBox(height: 24),
                  AppButton(
                    text: 'Continue Adventure 🚀',
                    onPressed: () {
                      ref.read(activeChildProfileProvider.notifier).completeActivity(
                            'activity_story_quiz_school',
                            xp: 35,
                            coins: 20,
                            stars: 3,
                          );
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Story Quiz 📖'),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Progress Indicator
            LinearProgressIndicator(
              value: (_currentIndex + 1) / _questions.length,
              backgroundColor: AppColors.cardBorder,
              color: AppColors.primary,
              minHeight: 8,
              borderRadius: AppRadius.roundedSm,
            ),
            const SizedBox(height: 20),

            // Question Card
            AppCard(
              backgroundColor: AppColors.primaryLight,
              borderColor: AppColors.primary,
              child: Text(
                q.question,
                style: AppTypography.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Choices List
            Expanded(
              child: ListView.builder(
                itemCount: q.choices.length,
                itemBuilder: (context, idx) {
                  final choice = q.choices[idx];
                  final isSelected = _selectedIndex == idx;

                  Color cardBg = Colors.white;
                  Color borderColor = AppColors.cardBorder;

                  if (isSelected) {
                    if (_isCorrect == true) {
                      cardBg = AppColors.correctGreen.withAlpha(40);
                      borderColor = AppColors.correctGreen;
                    } else if (_isCorrect == false) {
                      cardBg = AppColors.tryAgainOrange.withAlpha(40);
                      borderColor = AppColors.tryAgainOrange;
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GestureDetector(
                      onTap: () => _selectChoice(idx),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: AppRadius.roundedMd,
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: borderColor.withAlpha(80),
                              child: Text(String.fromCharCode(65 + idx),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Text(choice, style: AppTypography.bodyLarge)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_isCorrect == true)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.correctGreen.withAlpha(40),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Text(q.positiveFeedback, style: AppTypography.bodyMedium.copyWith(color: AppColors.correctGreen)),
              ),
          ],
        ),
      ),
    );
  }
}
