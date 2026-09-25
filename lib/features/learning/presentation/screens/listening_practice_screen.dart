import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/services/audio_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/guide_character.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';

class ListeningPracticeScreen extends ConsumerStatefulWidget {
  const ListeningPracticeScreen({super.key});

  @override
  ConsumerState<ListeningPracticeScreen> createState() => _ListeningPracticeScreenState();
}

class _ListeningPracticeScreenState extends ConsumerState<ListeningPracticeScreen> {
  int _roundIndex = 0;
  String? _selectedOption;
  bool? _isCorrect;

  final List<Map<String, dynamic>> _rounds = [
    {
      'audioText': 'The cat is small.',
      'options': [
        {'text': 'The cat is small. 🐱', 'isCorrect': true},
        {'text': 'The elephant is big. 🐘', 'isCorrect': false},
        {'text': 'The lion is roaring. 🦁', 'isCorrect': false},
      ],
    },
    {
      'audioText': 'The kitten drinks clean water.',
      'options': [
        {'text': 'The bird is flying. 🐦', 'isCorrect': false},
        {'text': 'The kitten drinks clean water. 💧', 'isCorrect': true},
        {'text': 'The cat is sleeping. 🐱', 'isCorrect': false},
      ],
    },
    {
      'audioText': 'We use gentle hands.',
      'options': [
        {'text': 'We use gentle hands. 🤲', 'isCorrect': true},
        {'text': 'We run fast. 🏃', 'isCorrect': false},
        {'text': 'The lion is hungry. 🦁', 'isCorrect': false},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _playAudioPrompt());
  }

  void _playAudioPrompt() {
    final round = _rounds[_roundIndex];
    ref.read(audioServiceProvider).playWordPronunciation(round['audioText'] as String);
  }

  void _onOptionTap(String text, bool isRight) {
    if (_selectedOption != null && _isCorrect == true) return;

    setState(() {
      _selectedOption = text;
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
      _playAudioPrompt();
    } else {
      context.pushReplacement(RouteNames.speakingPractice);
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final round = _rounds[_roundIndex];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: 'Listening Practice (${_roundIndex + 1}/${_rounds.length})',
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
              message: 'Listen carefully to the spoken sentence, then pick the matching sentence below!',
              onSpeakTap: _playAudioPrompt,
            ),
            const SizedBox(height: 20),

            // Big Listening Audio Prompt Button
            GestureDetector(
              onTap: _playAudioPrompt,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up_rounded, size: 48, color: AppColors.primary),
                    Text('Play Audio', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            ...((round['options'] as List).map((opt) {
              final text = opt['text'] as String;
              final isRight = opt['isCorrect'] as bool;
              final isSelected = _selectedOption == text;

              Color bg = Colors.white;
              Color border = AppColors.cardBorder;

              if (isSelected) {
                if (_isCorrect == true) {
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
                  onTap: () => _onOptionTap(text, isRight),
                  child: Row(
                    children: [
                      Icon(
                        isSelected && _isCorrect == true
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected && _isCorrect == true
                            ? AppColors.correctGreen
                            : AppColors.textSecondary,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(text, style: AppTypography.headlineMedium.copyWith(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              );
            })),

            const SizedBox(height: 20),
            if (_isCorrect == true)
              AppButton(
                text: _roundIndex + 1 < _rounds.length ? 'Next Sentence ▶' : 'Go to Speaking Lab 🎙️ ▶',
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
