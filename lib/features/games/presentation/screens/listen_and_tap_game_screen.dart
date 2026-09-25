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

class ListenAndTapGameScreen extends ConsumerStatefulWidget {
  const ListenAndTapGameScreen({super.key});

  @override
  ConsumerState<ListenAndTapGameScreen> createState() => _ListenAndTapGameScreenState();
}

class _ListenAndTapGameScreenState extends ConsumerState<ListenAndTapGameScreen> {
  int _roundIndex = 0;
  String? _selectedOption;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _rounds = [
    {
      'word': 'Cat',
      'soundPrompt': 'Cat',
      'options': [
        {'word': 'Lion', 'emoji': '🦁'},
        {'word': 'Cat', 'emoji': '🐱'},
        {'word': 'Bird', 'emoji': '🐦'},
      ],
    },
    {
      'word': 'Water',
      'soundPrompt': 'Water',
      'options': [
        {'word': 'Water', 'emoji': '💧'},
        {'word': 'Elephant', 'emoji': '🐘'},
        {'word': 'Cat', 'emoji': '🐱'},
      ],
    },
    {
      'word': 'Bird',
      'soundPrompt': 'Bird',
      'options': [
        {'word': 'Elephant', 'emoji': '🐘'},
        {'word': 'Lion', 'emoji': '🦁'},
        {'word': 'Bird', 'emoji': '🐦'},
      ],
    },
    {
      'word': 'Elephant',
      'soundPrompt': 'Elephant',
      'options': [
        {'word': 'Elephant', 'emoji': '🐘'},
        {'word': 'Cat', 'emoji': '🐱'},
        {'word': 'Water', 'emoji': '💧'},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playPromptAudio());
  }

  void _playPromptAudio() {
    final round = _rounds[_roundIndex];
    ref.read(audioServiceProvider).playWordPronunciation(round['soundPrompt'] as String);
  }

  void _onOptionSelected(String word) {
    if (_selectedOption != null && _isCorrect == true) return;

    final round = _rounds[_roundIndex];
    final isRight = (word == round['word']);

    setState(() {
      _selectedOption = word;
      _isCorrect = isRight;
      if (isRight) {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.correct);
      } else {
        ref.read(audioServiceProvider).playSoundEffect(SoundEffect.tryAgain);
      }
    });
  }

  void _onNext() {
    if (_roundIndex + 1 < _rounds.length) {
      setState(() {
        _roundIndex++;
        _selectedOption = null;
        _isCorrect = null;
      });
      _playPromptAudio();
    } else {
      // Completed game!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_listen_tap',
            nextActivityId: 'activity_word_match',
            xp: 25,
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
              const Icon(Icons.hearing_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Sharp Ears! 🎧🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You listened carefully and matched every sound!\nNext up: Word Match Game!',
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
                text: 'Play Word Match 🃏 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.wordMatch);
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
        title: 'Listen & Tap (${_roundIndex + 1}/${_rounds.length})',
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
              message: 'Tap the big blue speaker to listen, then tap the matching picture!',
              onSpeakTap: _playPromptAudio,
            ),
            const SizedBox(height: 20),

            // Big Listening Audio Button
            GestureDetector(
              onTap: _playPromptAudio,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.25),
                      offset: const Offset(0, 6),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up_rounded, size: 54, color: AppColors.primary),
                    Text('Tap to Hear', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Which picture matches what you hear?',
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Choices Grid
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
                final isSelected = _selectedOption == opt['word'];

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
                  onTap: () => _onOptionSelected(opt['word'] as String),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(opt['emoji'] as String, style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 6),
                      Text(
                        opt['word'] as String,
                        style: AppTypography.titleLarge.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            if (_isCorrect == true)
              AppButton(
                text: 'Correct! Next ▶',
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
