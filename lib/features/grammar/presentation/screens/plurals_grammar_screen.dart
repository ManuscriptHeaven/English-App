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

class PluralsGrammarScreen extends ConsumerStatefulWidget {
  const PluralsGrammarScreen({super.key});

  @override
  ConsumerState<PluralsGrammarScreen> createState() => _PluralsGrammarScreenState();
}

class _PluralsGrammarScreenState extends ConsumerState<PluralsGrammarScreen> {
  int _currentStep = 0;
  String? _selectedOption;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _questions = [
    {
      'sentencePrefix': 'I have two',
      'visualEmoji': '📚 📚',
      'correctWord': 'books',
      'options': ['book', 'books'],
      'rule': 'One book ➜ Two books (add "s")',
    },
    {
      'sentencePrefix': 'Look! There are three',
      'visualEmoji': '✏️ ✏️ ✏️',
      'correctWord': 'pencils',
      'options': ['pencil', 'pencils'],
      'rule': 'One pencil ➜ Three pencils (add "s")',
    },
    {
      'sentencePrefix': 'The students have two',
      'visualEmoji': '🎒 🎒',
      'correctWord': 'bags',
      'options': ['bag', 'bags'],
      'rule': 'One bag ➜ Two bags (add "s")',
    },
  ];

  void _onSelect(String option) {
    if (_selectedOption != null && _isCorrect == true) return;

    final q = _questions[_currentStep];
    final isRight = (option == q['correctWord']);

    setState(() {
      _selectedOption = option;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSuccess();
      } else {
        ref.read(audioServiceProvider).playRetry();
      }
    });
  }

  void _onNext() {
    if (_currentStep + 1 < _questions.length) {
      setState(() {
        _currentStep++;
        _selectedOption = null;
        _isCorrect = null;
      });
    } else {
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_grammar_plurals',
            nextActivityId: 'activity_polite_requests',
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
              const Icon(Icons.auto_awesome_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Plural Counting Pro! ✍️🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You mastered counting singular and plural objects!\nNext up: Polite Classroom Requests!',
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
                text: 'Practice Polite Requests 🗣️ ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.politeRequests);
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
    final q = _questions[_currentStep];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Grammar: Plurals (${_currentStep + 1}/${_questions.length})',
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
              message: 'When we have more than one, we add an "s" at the end! 📚',
              onSpeakTap: () {
                ref.read(audioServiceProvider).playSentence(q['rule'] as String);
              },
            ),
            const SizedBox(height: 16),

            AppCard(
              borderColor: AppColors.primary,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(q['visualEmoji'] as String, style: const TextStyle(fontSize: 54)),
                  const SizedBox(height: 16),
                  Text(
                    '${q['sentencePrefix']} [ ${_selectedOption ?? '?'} ]',
                    style: AppTypography.headlineLarge.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '💡 ${q['rule']}',
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: (q['options'] as List<String>).map((opt) {
                final isSelected = _selectedOption == opt;
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

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: AppCard(
                      backgroundColor: bg,
                      borderColor: border,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      onTap: () => _onSelect(opt),
                      child: Text(
                        opt,
                        style: AppTypography.headlineMedium.copyWith(color: AppColors.textPrimary),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Next Sentence ▶',
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
