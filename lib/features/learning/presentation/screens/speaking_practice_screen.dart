import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/age_group_config.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/audio_play_button.dart';
import '../../../../core/widgets/child_table_visual.dart';
import '../../../../core/widgets/microphone_button.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/reward_badge.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

/// Child-friendly Speaking Practice Screen with Pip Character Guidance and Real Speech Recognition.
class SpeakingPracticeScreen extends ConsumerStatefulWidget {
  const SpeakingPracticeScreen({super.key});

  @override
  ConsumerState<SpeakingPracticeScreen> createState() => _SpeakingPracticeScreenState();
}

class _SpeakingPracticeScreenState extends ConsumerState<SpeakingPracticeScreen> {
  int _roundIndex = 0;
  String? _recognizedText;
  double? _matchScore;
  bool _hasCompletedCurrent = false;

  List<Map<String, String>> _getPhrasesForAge(AgeGroupType ageGroup) {
    switch (ageGroup) {
      case AgeGroupType.toddler: // Ages 3-4 (Single Words)
        return [
          {'phrase': 'Cat', 'emoji': '🐱', 'prompt': 'Say the word:'},
          {'phrase': 'Book', 'emoji': '📚', 'prompt': 'Say the word:'},
          {'phrase': 'Mother', 'emoji': '👩', 'prompt': 'Say with love:'},
          {'phrase': 'Water', 'emoji': '💧', 'prompt': 'Say clearly:'},
        ];
      case AgeGroupType.earlyLearner: // Ages 5-6 (Short Phrases)
        return [
          {'phrase': 'This is a cat', 'emoji': '🐱', 'prompt': 'Say the phrase:'},
          {'phrase': 'This is my room', 'emoji': '🚪', 'prompt': 'Say clearly:'},
          {'phrase': 'I have a book', 'emoji': '📚', 'prompt': 'Say with confidence:'},
          {'phrase': 'Alhamdulillah', 'emoji': '🌟', 'prompt': 'Say with a joyful smile:'},
        ];
      case AgeGroupType.youngReader: // Ages 7-8 (Sentences)
        return [
          {'phrase': 'The cat is small', 'emoji': '🐱', 'prompt': 'Say the sentence:'},
          {'phrase': 'She is helping mother', 'emoji': '👩', 'prompt': 'Say with feeling:'},
          {'phrase': 'The table is clean', 'emoji': '', 'prompt': 'Say clearly:'},
          {'phrase': 'We use gentle hands', 'emoji': '🤲', 'prompt': 'Say with Rahmah:'},
        ];
      case AgeGroupType.masterLearner: // Ages 9-10 (Complex Sentences)
        return [
          {'phrase': 'The small cat is drinking clean water', 'emoji': '🐱', 'prompt': 'Say the complete sentence:'},
          {'phrase': 'Ayaan is helping his mother at home', 'emoji': '🏡', 'prompt': 'Say with good pronunciation:'},
          {'phrase': 'We always say Bismillah before eating', 'emoji': '🍽️', 'prompt': 'Say with gratitude:'},
          {'phrase': 'Kindness and respect bring blessings to family', 'emoji': '❤️', 'prompt': 'Say with noble character:'},
        ];
    }
  }

  void _onSpeechResult(String spokenText, double similarity) {
    setState(() {
      _recognizedText = spokenText;
      _matchScore = similarity;
      _hasCompletedCurrent = (similarity >= 0.45);
    });

    if (similarity >= 0.6) {
      ref.read(audioServiceProvider).playSuccess();
    } else {
      ref.read(audioServiceProvider).playRetry();
    }
  }

  void _onNext(int totalPhrases) {
    if (_roundIndex + 1 < totalPhrases) {
      setState(() {
        _roundIndex++;
        _recognizedText = null;
        _matchScore = null;
        _hasCompletedCurrent = false;
      });
    } else {
      // Completed all speaking rounds!
      ref.read(activeChildProfileProvider.notifier).completeActivity(
            'activity_speaking_practice',
            xp: 35,
            coins: 20,
            stars: 3,
          );
      ref.read(audioServiceProvider).playReward();
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
              const Icon(Icons.mic_rounded, size: 72, color: AppColors.primary),
              const SizedBox(height: 12),
              Text('Confident Speaker! 🎙️🌟', style: AppTypography.displayMedium),
              const SizedBox(height: 8),
              Text(
                'You spoke clearly and practiced real speech!\nGet ready for the Final Challenge!',
                style: AppTypography.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RewardBadge(type: BadgeType.xp, count: 35),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.coin, count: 20),
                  SizedBox(width: 8),
                  RewardBadge(type: BadgeType.star, count: 3),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                text: 'Grand Challenge 🏆 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.secondary,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.pushReplacement(RouteNames.worldChallenge);
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
    final ageGroup = activeChild?.ageGroup ?? AgeGroupType.earlyLearner;
    final phrases = _getPhrasesForAge(ageGroup);
    final item = phrases[_roundIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Speaking Lab (${_roundIndex + 1}/${phrases.length})',
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Center Pip Character Guide
            PipCharacterGuide(
              state: _hasCompletedCurrent ? PipState.celebrating : PipState.listening,
              speechBubbleText: _hasCompletedCurrent ? '🌟 MashaAllah! Great speaking!' : 'Listen first, then speak clearly into the mic!',
              characterSize: 88,
            ),
            const SizedBox(height: 16),

            // Target Phrase Card
            AppCard(
              borderColor: AppColors.primary,
              borderWidth: 2,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  item['phrase']!.toLowerCase().contains('table')
                      ? const ChildTableVisual(width: 84, height: 60)
                      : Text(item['emoji']!, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 8),
                  Text(
                    item['phrase']!,
                    style: AppTypography.displayMedium.copyWith(color: AppColors.primaryDark),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  AudioPlayButton(
                    textToSpeak: item['phrase']!,
                    label: 'Hear It',
                    priority: AudioPriority.vocabularyPronunciation,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Microphone Button
            MicrophoneButton(
              targetPhrase: item['phrase']!,
              size: 88,
              onSpeechResult: _onSpeechResult,
              onHearAlternative: () => ref.read(audioServiceProvider).playSentence(item['phrase']!),
            ),
            const SizedBox(height: 20),

            // Speech Recognition Result Box
            if (_recognizedText != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (_matchScore ?? 0) >= 0.45
                      ? AppColors.correctGreen.withAlpha(30)
                      : AppColors.tryAgainOrange.withAlpha(30),
                  borderRadius: AppRadius.roundedMd,
                  border: Border.all(
                    color: (_matchScore ?? 0) >= 0.45 ? AppColors.correctGreen : AppColors.tryAgainOrange,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'You said: "$_recognizedText"',
                      style: AppTypography.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (_matchScore ?? 0) >= 0.45
                          ? '🌟 Excellent! Super clear!'
                          : 'Good try! Listen and say it again 😊',
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: (_matchScore ?? 0) >= 0.45 ? AppColors.correctGreen : AppColors.tryAgainOrange,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Continue Button
            if (_hasCompletedCurrent)
              AppButton(
                text: _roundIndex + 1 < phrases.length ? 'Next Phrase ▶' : 'Finish Speaking Lab 🌟 ▶',
                minWidth: double.infinity,
                height: 56,
                backgroundColor: AppColors.correctGreen,
                foregroundColor: Colors.white,
                onPressed: () => _onNext(phrases.length),
              ),
          ],
        ),
      ),
    );
  }
}
