import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_button.dart';

/// Reusable child-friendly Microphone button with animated states and gentle permission handling.
class MicrophoneButton extends ConsumerStatefulWidget {
  final String targetPhrase;
  final double size;
  final void Function(String recognizedText, double similarity) onSpeechResult;
  final VoidCallback? onHearAlternative;

  const MicrophoneButton({
    super.key,
    required this.targetPhrase,
    this.size = 80.0,
    required this.onSpeechResult,
    this.onHearAlternative,
  });

  @override
  ConsumerState<MicrophoneButton> createState() => _MicrophoneButtonState();
}

class _MicrophoneButtonState extends ConsumerState<MicrophoneButton> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  SpeechRecognitionState _state = SpeechRecognitionState.idle;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startListening() async {
    final speech = ref.read(speechRecognitionServiceProvider);

    setState(() => _state = SpeechRecognitionState.listening);
    _pulseController.repeat(reverse: true);

    await speech.startListening(
      onResult: (text, confidence) {
        if (!mounted) return;
        final similarity = ISpeechRecognitionService.calculateSimilarity(widget.targetPhrase, text);
        setState(() => _state = SpeechRecognitionState.success);
        _pulseController.stop();
        _pulseController.reset();
        widget.onSpeechResult(text, similarity);
      },
      onError: (err) {
        if (!mounted) return;
        _pulseController.stop();
        _pulseController.reset();
        if (err.toLowerCase().contains('permission')) {
          setState(() => _state = SpeechRecognitionState.permissionDenied);
        } else {
          setState(() => _state = SpeechRecognitionState.error);
        }
      },
    );
  }

  void _stopListening() async {
    final speech = ref.read(speechRecognitionServiceProvider);
    await speech.stopListening();
    if (mounted) {
      _pulseController.stop();
      _pulseController.reset();
      setState(() => _state = SpeechRecognitionState.idle);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_state == SpeechRecognitionState.permissionDenied) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryLight,
          borderRadius: AppRadius.roundedMd,
          border: Border.all(color: AppColors.secondary),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎧', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(
              "Microphone access is off. Let's practice by listening first! 🌟",
              style: AppTypography.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.onHearAlternative != null) ...[
                  AppButton(
                    text: 'Hear It 🔊',
                    backgroundColor: AppColors.primary,
                    onPressed: widget.onHearAlternative,
                  ),
                  const SizedBox(width: 12),
                ],
                AppButton(
                  text: 'Try Again 🔄',
                  backgroundColor: AppColors.secondary,
                  onPressed: () {
                    setState(() => _state = SpeechRecognitionState.idle);
                    _startListening();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }

    Color btnColor;
    Widget iconChild;
    String statusLabel;

    switch (_state) {
      case SpeechRecognitionState.listening:
        btnColor = Colors.redAccent;
        iconChild = const Icon(Icons.mic, color: Colors.white, size: 44);
        statusLabel = '🔴 Listening...';
        break;
      case SpeechRecognitionState.processing:
        btnColor = Colors.amber;
        iconChild = const SizedBox(
          width: 36,
          height: 36,
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        );
        statusLabel = '⏳ Checking speech...';
        break;
      case SpeechRecognitionState.success:
        btnColor = AppColors.correctGreen;
        iconChild = const Icon(Icons.check_circle_rounded, color: Colors.white, size: 44);
        statusLabel = '✅ Great job!';
        break;
      case SpeechRecognitionState.error:
        btnColor = AppColors.tryAgainOrange;
        iconChild = const Icon(Icons.refresh_rounded, color: Colors.white, size: 44);
        statusLabel = '😊 Good try! Tap to speak';
        break;
      case SpeechRecognitionState.permissionDenied:
      case SpeechRecognitionState.idle:
        btnColor = AppColors.primary;
        iconChild = const Icon(Icons.mic_rounded, color: Colors.white, size: 44);
        statusLabel = '🎤 Tap to Speak';
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          scale: _state == SpeechRecognitionState.listening ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
          child: GestureDetector(
            onTap: () {
              if (_state == SpeechRecognitionState.listening) {
                _stopListening();
              } else {
                _startListening();
              }
            },
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: btnColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: btnColor.withAlpha(120),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(child: iconChild),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          statusLabel,
          style: AppTypography.headlineMedium.copyWith(
            color: _state == SpeechRecognitionState.listening ? Colors.redAccent : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
