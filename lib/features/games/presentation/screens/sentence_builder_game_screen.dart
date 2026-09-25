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

class SentenceBuilderGameScreen extends ConsumerStatefulWidget {
  const SentenceBuilderGameScreen({super.key});

  @override
  ConsumerState<SentenceBuilderGameScreen> createState() => _SentenceBuilderGameScreenState();
}

class _SentenceBuilderGameScreenState extends ConsumerState<SentenceBuilderGameScreen> {
  int _roundIndex = 0;
  final List<String> _constructedWords = [];
  bool? _isCorrect;

  final List<Map<String, dynamic>> _rounds = [
    {
      'targetSentence': 'This is a cat',
      'wordsPool': ['a', 'This', 'cat', 'is'],
      'emoji': '🐱',
    },
    {
      'targetSentence': 'The cat is thirsty',
      'wordsPool': ['thirsty', 'The', 'is', 'cat'],
      'emoji': '💧',
    },
    {
      'targetSentence': 'This is an elephant',
      'wordsPool': ['an', 'This', 'elephant', 'is'],
      'emoji': '🐘',
    },
  ];

  void _tapWordTile(String word) {
    if (_constructedWords.contains(word) || _isCorrect == true) return;
    setState(() {
      _constructedWords.add(word);
      _checkSentence();
    });
  }

  void _removeWordTile(String word) {
    if (_isCorrect == true) return;
    setState(() {
      _constructedWords.remove(word);
      _isCorrect = null;
    });
  }

  void _checkSentence() {
    final round = _rounds[_roundIndex];
    final target = round['targetSentence'] as String;
    final current = _constructedWords.join(' ');

    if (_constructedWords.length == (round['wordsPool'] as List).length) {
      if (current.toLowerCase() == target.toLowerCase()) {
        setState(() {
          _isCorrect = true;
        });
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
        ref.read(audioServiceProvider).playWordPronunciation('$target.');
      } else {
        setState(() {
          _isCorrect = false;
        });
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    }
  }

  void _onNext() {
    if (_roundIndex + 1 < _rounds.length) {
      setState(() {
        _roundIndex++;
        _constructedWords.clear();
        _isCorrect = null;
      });
    } else {
      // Completed game!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_grammar_this_is',
            nextActivityId: 'activity_grammar_is_are',
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
              const Icon(Icons.auto_awesome_rounded, size: 72, color: AppColors.secondary),
              const SizedBox(height: 12),
              Text('Sentence Master! 🧩🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You built complete English sentences!\nNext up: Is vs Are Challenge!',
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
                text: 'Play Is vs Are ⚖️ ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.isAreQuiz);
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
    final round = _rounds[_roundIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Sentence Builder (${_roundIndex + 1}/${_rounds.length})',
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
              message: 'Tap the words in order to build: "${round['targetSentence']}"!',
            ),
            const SizedBox(height: 20),

            // Target Image & Target Sentence Hint
            Text(round['emoji'] as String, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),

            // Constructed Sentence Drop Zone
            AppCard(
              borderColor: _isCorrect == true
                  ? AppColors.correctGreen
                  : (_isCorrect == false ? AppColors.tryAgainOrange : AppColors.primary),
              backgroundColor: _isCorrect == true
                  ? AppColors.correctGreen.withValues(alpha: 0.1)
                  : Colors.white,
              padding: const EdgeInsets.all(16),
              child: Container(
                constraints: const BoxConstraints(minHeight: 64),
                alignment: Alignment.center,
                child: _constructedWords.isEmpty
                    ? Text(
                        'Tap words below to place them here...',
                        style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
                      )
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _constructedWords.map((word) {
                          return GestureDetector(
                            onTap: () => _removeWordTile(word),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: AppRadius.roundedMd,
                              ),
                              child: Text(
                                word,
                                style: AppTypography.buttonText.copyWith(color: Colors.white),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Word Pool Tiles
            Text('Word Tiles:', style: AppTypography.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: (round['wordsPool'] as List<String>).map((word) {
                final isUsed = _constructedWords.contains(word);
                return GestureDetector(
                  onTap: isUsed ? null : () => _tapWordTile(word),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: isUsed ? AppColors.lockGrey.withValues(alpha: 0.3) : AppColors.secondary,
                      borderRadius: AppRadius.roundedMd,
                      border: Border.all(
                        color: isUsed ? Colors.transparent : AppColors.secondaryDark,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      word,
                      style: AppTypography.headlineMedium.copyWith(
                        color: isUsed ? AppColors.textMuted : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Great Sentence! Next ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: _onNext,
              )
            else if (_constructedWords.isNotEmpty)
              TextButton(
                onPressed: () => setState(() {
                  _constructedWords.clear();
                  _isCorrect = null;
                }),
                child: Text('Reset Words ↺', style: AppTypography.titleLarge.copyWith(color: AppColors.tryAgainOrange)),
              ),
          ],
        ),
      ),
    );
  }
}
