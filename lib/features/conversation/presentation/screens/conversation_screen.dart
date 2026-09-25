import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';
import 'package:kids_english_adventure/core/widgets/app_scaffold.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/character_expression.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_option.dart';
import 'package:kids_english_adventure/features/conversation/domain/services/conversation_engine.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/features/settings/presentation/providers/settings_providers.dart';

/// Interactive conversation screen with Pip and friends.
class ConversationScreen extends ConsumerStatefulWidget {
  final Conversation conversation;

  const ConversationScreen({
    super.key,
    required this.conversation,
  });

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late ConversationEngine _engine;
  String? _feedback;
  bool _isSpeakingMode = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    _engine = ConversationEngine(conversation: widget.conversation);
  }

  void _onSelectOption(ConversationOption option) {
    final correct = _engine.submitChoice(option);
    setState(() {
      _feedback = option.feedback;
    });

    if (correct) {
      ref.read(audioServiceProvider).playSuccess();
    } else {
      ref.read(audioServiceProvider).playRetry();
    }
  }

  void _onSpeechRecorded() async {
    setState(() => _isListening = true);
    final speechService = ref.read(speechRecognitionServiceProvider);
    final turn = _engine.currentTurn;

    if (turn != null) {
      await speechService.startListening(
        onResult: (recognizedText, confidence) {
          if (mounted) {
            final score = _engine.submitSpeech(recognizedText);
            setState(() {
              _isListening = false;
              _feedback = score >= 0.7 ? 'Great speaking! 🌟' : 'Almost! Try saying: "${turn.expectedResponse}"';
            });

            if (score >= 0.7) {
              ref.read(audioServiceProvider).playSuccess();
            } else {
              ref.read(audioServiceProvider).playRetry();
            }
          }
        },
        onError: (err) {
          if (mounted) {
            setState(() => _isListening = false);
          }
        },
      );
    }
  }

  void _onComplete() {
    ref.read(activeChildProfileProvider.notifier).completeActivity(
          widget.conversation.id,
          xp: widget.conversation.rewardXp,
          coins: widget.conversation.rewardCoins,
          stars: widget.conversation.rewardStars,
        );
    ref.read(audioServiceProvider).playReward();
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final turn = _engine.currentTurn;

    if (_engine.isCompleted || turn == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: ChildHeaderBar(
          title: widget.conversation.title,
          stars: activeChild?.stars ?? 0,
          coins: activeChild?.coins ?? 0,
          streak: activeChild?.streakDays ?? 0,
          showBack: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🎉', style: TextStyle(fontSize: 84)),
                const SizedBox(height: 14),
                Text('Conversation Complete!', style: AppTypography.displayMedium),
                const SizedBox(height: 8),
                Text('MashaAllah! Excellent talking with Pip!', style: AppTypography.bodyLarge),
                const SizedBox(height: 24),
                AppButton(
                  text: 'Collect Reward ⭐',
                  minWidth: double.infinity,
                  height: 56,
                  backgroundColor: AppColors.correctGreen,
                  foregroundColor: Colors.white,
                  onPressed: _onComplete,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChildHeaderBar(
        title: widget.conversation.title,
        stars: activeChild?.stars ?? 0,
        coins: activeChild?.coins ?? 0,
        streak: activeChild?.streakDays ?? 0,
        showBack: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Character Dialogue Card
            AppCard(
              borderColor: AppColors.primary,
              backgroundColor: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(turn.speakerEmoji, style: const TextStyle(fontSize: 64)),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(turn.speakerName, style: AppTypography.titleLarge.copyWith(color: AppColors.primaryDark)),
                          Text(
                            turn.expression == CharacterExpression.happy
                                ? 'Smiling 😊'
                                : (turn.expression == CharacterExpression.curious
                                    ? 'Curious 🧐'
                                    : 'Encouraging 🌟'),
                            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: AppRadius.roundedLg,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            turn.promptText,
                            style: AppTypography.headlineMedium.copyWith(fontSize: 20),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up_rounded, color: AppColors.primaryDark),
                          onPressed: () => ref.read(audioServiceProvider).playWord(turn.promptText),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Mode Selector Pill
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isSpeakingMode = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: !_isSpeakingMode ? AppColors.secondary : Colors.white,
                      borderRadius: AppRadius.roundedPill,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text('Tap Choice 👆',
                        style: TextStyle(
                            color: !_isSpeakingMode ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => _isSpeakingMode = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _isSpeakingMode ? AppColors.secondary : Colors.white,
                      borderRadius: AppRadius.roundedPill,
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Text('Speak Aloud 🎙️',
                        style: TextStyle(
                            color: _isSpeakingMode ? Colors.white : AppColors.textPrimary,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Feedback Banner
            if (_feedback != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Text(_feedback!, style: AppTypography.headlineMedium.copyWith(fontSize: 16), textAlign: TextAlign.center),
              ),
              const SizedBox(height: 14),
            ],

            // Input Mode: Choice options or Microphone
            if (!_isSpeakingMode) ...[
              ...turn.options.map((opt) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: AppCard(
                    backgroundColor: Colors.white,
                    borderColor: AppColors.cardBorder,
                    padding: const EdgeInsets.all(16),
                    onTap: () => _onSelectOption(opt),
                    child: Text(
                      opt.text,
                      style: AppTypography.headlineMedium.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            ] else ...[
              AppCard(
                backgroundColor: Colors.white,
                borderColor: AppColors.primary,
                child: Column(
                  children: [
                    Text('Say aloud:', style: AppTypography.bodyMedium),
                    const SizedBox(height: 6),
                    Text('"${turn.expectedResponse}"', style: AppTypography.headlineLarge.copyWith(fontSize: 22, color: AppColors.primaryDark)),
                    const SizedBox(height: 18),
                    IconButton(
                      iconSize: 68,
                      icon: Icon(
                        _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                        color: _isListening ? AppColors.tryAgainOrange : AppColors.primary,
                      ),
                      onPressed: _isListening ? null : _onSpeechRecorded,
                    ),
                    const SizedBox(height: 6),
                    Text(_isListening ? 'Listening... 🎙️' : 'Tap microphone to speak', style: AppTypography.badgeText),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
