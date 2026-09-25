import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import '../services/speech_recognition_service.dart';
import 'child_experience_controller.dart';

/// The 8 discrete states of child speaking interaction.
enum SpeakingFlowState {
  idle,
  listenToModel,
  ready,
  listening,
  processing,
  success,
  retry,
  unavailable,
}

/// State representation for speaking practice interaction.
class SpeakingPracticeState extends Equatable {
  final SpeakingFlowState flowState;
  final String targetPhrase;
  final String? recognizedText;
  final double similarityScore;
  final String? qualitativeFeedback;
  final String? childFacingMessage;
  final bool isRecording;
  final double soundLevel;

  const SpeakingPracticeState({
    this.flowState = SpeakingFlowState.idle,
    required this.targetPhrase,
    this.recognizedText,
    this.similarityScore = 0.0,
    this.qualitativeFeedback,
    this.childFacingMessage,
    this.isRecording = false,
    this.soundLevel = 0.0,
  });

  SpeakingPracticeState copyWith({
    SpeakingFlowState? flowState,
    String? targetPhrase,
    String? recognizedText,
    double? similarityScore,
    String? qualitativeFeedback,
    String? childFacingMessage,
    bool? isRecording,
    double? soundLevel,
  }) {
    return SpeakingPracticeState(
      flowState: flowState ?? this.flowState,
      targetPhrase: targetPhrase ?? this.targetPhrase,
      recognizedText: recognizedText ?? this.recognizedText,
      similarityScore: similarityScore ?? this.similarityScore,
      qualitativeFeedback: qualitativeFeedback ?? this.qualitativeFeedback,
      childFacingMessage: childFacingMessage ?? this.childFacingMessage,
      isRecording: isRecording ?? this.isRecording,
      soundLevel: soundLevel ?? this.soundLevel,
    );
  }

  @override
  List<Object?> get props => [
        flowState,
        targetPhrase,
        recognizedText,
        similarityScore,
        qualitativeFeedback,
        childFacingMessage,
        isRecording,
        soundLevel,
      ];
}

/// Controller coordinating the 8-step child speaking interaction,
/// gentle error recovery, and qualitative encouragement.
class SpeakingInteractionController extends StateNotifier<SpeakingPracticeState> {
  final ISpeechRecognitionService speechService;
  final IAudioService audioService;
  final ChildExperienceController experience;
  StreamSubscription<double>? _soundLevelSub;

  SpeakingInteractionController({
    required this.speechService,
    required this.audioService,
    required this.experience,
    required String initialTargetPhrase,
  }) : super(SpeakingPracticeState(targetPhrase: initialTargetPhrase));

  /// Step 1: Plays model native pronunciation of the target phrase.
  Future<void> playModelAudio() async {
    state = state.copyWith(
      flowState: SpeakingFlowState.listenToModel,
      childFacingMessage: 'Listen to Pip! 👂',
    );

    try {
      await audioService.playWord(state.targetPhrase, priority: AudioPriority.vocabularyPronunciation);
    } finally {
      // Step 2 & 3: Prompt visible and mic activates
      if (mounted) {
        state = state.copyWith(
          flowState: SpeakingFlowState.ready,
          childFacingMessage: 'Your turn! Tap the mic to speak! 🎙️',
        );
      }
    }
  }

  /// Step 4 & 5: Activates recording and reactive listening visualization.
  Future<void> startListening() async {
    final available = await speechService.isAvailable();
    if (!available) {
      state = state.copyWith(
        flowState: SpeakingFlowState.unavailable,
        childFacingMessage: 'Microphone is sleeping. Ask a grown-up for help!',
      );
      return;
    }

    state = state.copyWith(
      flowState: SpeakingFlowState.listening,
      isRecording: true,
      childFacingMessage: 'Pip is listening! Speak clearly... 🦜',
    );

    _soundLevelSub?.cancel();
    _soundLevelSub = speechService.soundLevelStream.listen((level) {
      if (mounted) {
        state = state.copyWith(soundLevel: level);
      }
    });

    try {
      await speechService.startListening(
        listenFor: const Duration(seconds: 6),
        pauseFor: const Duration(seconds: 2),
        onResult: (spokenText, confidence) {
          _handleSpeechResult(spokenText);
        },
        onError: (err) {
          _handleSpeechError(err);
        },
      );
    } catch (e) {
      _handleSpeechError(e.toString());
    }
  }

  /// Step 6 & 7: Stops listening and processes result.
  Future<void> stopListening() async {
    _soundLevelSub?.cancel();
    await speechService.stopListening();
    if (mounted && state.flowState == SpeakingFlowState.listening) {
      state = state.copyWith(
        flowState: SpeakingFlowState.processing,
        isRecording: false,
        childFacingMessage: 'Checking your awesome speech... ✨',
      );
    }
  }

  /// INITIAL_TUNING_THRESHOLD: Lenient acoustic baseline similarity threshold (0.45).
  ///
  /// NOTE: This is an INITIAL_TUNING_THRESHOLD, NOT a final child-calibrated threshold.
  /// Final calibration requires real-device validation across:
  /// - younger voices (pitch, formant variation)
  /// - regional and multilingual accents
  /// - different hardware microphones (budget devices, tablets)
  /// - ambient background noise (home, classroom, car)
  /// - quiet, soft, or hesitant speech
  static const double initialTuningThreshold = 0.45;

  /// Step 8: Evaluates result qualitatively with confidence-building encouragement.
  void _handleSpeechResult(String spokenText) {
    _soundLevelSub?.cancel();
    final similarity = ISpeechRecognitionService.calculateSimilarity(state.targetPhrase, spokenText);

    final isSuccess = similarity >= initialTuningThreshold;

    if (isSuccess) {
      final feedback = _generateQualitativePraise(similarity);
      state = state.copyWith(
        flowState: SpeakingFlowState.success,
        recognizedText: spokenText,
        similarityScore: similarity,
        qualitativeFeedback: feedback,
        childFacingMessage: feedback,
        isRecording: false,
      );
      experience.onSpeakingSuccess(
        isIndependent: similarity >= 0.75,
        spokenText: spokenText,
      );
    } else {
      // Lenient supportive retry — NEVER "Wrong pronunciation" or numeric score
      final retryMsg = 'Almost! Listen once more. 😊';
      state = state.copyWith(
        flowState: SpeakingFlowState.retry,
        recognizedText: spokenText,
        similarityScore: similarity,
        qualitativeFeedback: retryMsg,
        childFacingMessage: retryMsg,
        isRecording: false,
      );
      experience.onGentleRetry(hintClue: retryMsg);
    }
  }

  /// Handles errors with friendly child-facing messages. Zero technical jargon.
  void _handleSpeechError(String err) {
    _soundLevelSub?.cancel();
    final lower = err.toLowerCase();

    if (lower.contains('permission')) {
      state = state.copyWith(
        flowState: SpeakingFlowState.unavailable,
        isRecording: false,
        childFacingMessage: 'Microphone is sleeping. Ask a grown-up for help!',
      );
    } else if (lower.contains('timeout') || lower.contains('no_match') || lower.contains('silent')) {
      const retryMsg = 'I didn\'t hear that. Let\'s try once more! 👂';
      state = state.copyWith(
        flowState: SpeakingFlowState.retry,
        isRecording: false,
        childFacingMessage: retryMsg,
      );
      experience.onGentleRetry(hintClue: retryMsg);
    } else {
      const retryMsg = 'Let\'s try saying it together!';
      state = state.copyWith(
        flowState: SpeakingFlowState.retry,
        isRecording: false,
        childFacingMessage: retryMsg,
      );
      experience.onGentleRetry(hintClue: retryMsg);
    }
  }

  /// Sets a new target phrase and resets flow.
  void setTargetPhrase(String phrase) {
    _soundLevelSub?.cancel();
    state = SpeakingPracticeState(
      flowState: SpeakingFlowState.ready,
      targetPhrase: phrase,
      childFacingMessage: 'Ready to speak "$phrase"? Tap the mic! 🎙️',
    );
  }

  /// British Council style qualitative encouragement (no discouraging percentages).
  String _generateQualitativePraise(double similarity) {
    if (similarity >= 0.85) {
      return 'Clear and wonderful speaking! 🌟';
    } else if (similarity >= 0.65) {
      return 'Great effort! Pip heard you clearly! 🦜';
    } else {
      return 'Nice try! You are doing great! 👍';
    }
  }

  @override
  void dispose() {
    _soundLevelSub?.cancel();
    super.dispose();
  }
}
