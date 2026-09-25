import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/pip_character_guide.dart';

/// State of Pip companion character including visual state, speech bubble, and active timer.
class PipCompanionState {
  final PipState state;
  final String? speechBubbleText;
  final bool isSpeaking;
  final DateTime lastActionTime;

  const PipCompanionState({
    this.state = PipState.idle,
    this.speechBubbleText,
    this.isSpeaking = false,
    required this.lastActionTime,
  });

  PipCompanionState copyWith({
    PipState? state,
    String? speechBubbleText,
    bool? isSpeaking,
    DateTime? lastActionTime,
  }) {
    return PipCompanionState(
      state: state ?? this.state,
      speechBubbleText: speechBubbleText,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      lastActionTime: lastActionTime ?? this.lastActionTime,
    );
  }
}

/// Controller managing Pip's lifecycle states, micro-reactions, duration timeouts,
/// and speech anti-fatigue throttling.
class PipStateController extends StateNotifier<PipCompanionState> {
  Timer? _revertTimer;
  int _consecutiveTrivialTaps = 0;
  DateTime? _lastSpokenPraiseTime;

  PipStateController()
      : super(PipCompanionState(
          state: PipState.idle,
          lastActionTime: DateTime.now(),
        ));

  /// Transitions Pip into [newState] for [duration], then returns to [PipState.idle].
  void transitionTo(
    PipState newState, {
    Duration duration = const Duration(milliseconds: 1200),
    String? speechText,
  }) {
    _revertTimer?.cancel();

    state = state.copyWith(
      state: newState,
      speechBubbleText: speechText,
      lastActionTime: DateTime.now(),
    );

    if (duration > Duration.zero) {
      _revertTimer = Timer(duration, () {
        if (mounted) {
          state = state.copyWith(
            state: PipState.idle,
            speechBubbleText: null,
          );
        }
      });
    }
  }

  /// Reacts to a correct answer based on intensity tier.
  /// Anti-fatigue rule: Pip does NOT give a full speech bubble on every trivial tap.
  void reactToCorrect({
    required bool isIndependent,
    bool isRecovery = false,
    String? promptPraise,
  }) {
    if (isRecovery) {
      transitionTo(
        PipState.encouraging,
        duration: const Duration(milliseconds: 1400),
        speechText: promptPraise ?? 'Nice correction!',
      );
      _consecutiveTrivialTaps = 0;
      return;
    }

    if (isIndependent) {
      transitionTo(
        PipState.happy,
        duration: const Duration(milliseconds: 1200),
        speechText: promptPraise ?? 'You remembered it!',
      );
      _consecutiveTrivialTaps = 0;
      return;
    }

    // Trivial tap / simple recognition: small smile, NO full speech bubble every time
    _consecutiveTrivialTaps++;
    final now = DateTime.now();
    final canSpeakPraise = _lastSpokenPraiseTime == null ||
        now.difference(_lastSpokenPraiseTime!) > const Duration(seconds: 4);

    if (_consecutiveTrivialTaps >= 3 && canSpeakPraise && promptPraise != null) {
      _lastSpokenPraiseTime = now;
      _consecutiveTrivialTaps = 0;
      transitionTo(
        PipState.happy,
        duration: const Duration(milliseconds: 900),
        speechText: promptPraise,
      );
    } else {
      // Subtle physical bounce without text clutter
      transitionTo(
        PipState.happy,
        duration: const Duration(milliseconds: 600),
        speechText: null,
      );
    }
  }

  /// Reacts to a retry attempt gently without disappointment.
  void reactToRetry({String? hintText}) {
    _consecutiveTrivialTaps = 0;
    transitionTo(
      PipState.encouraging,
      duration: const Duration(milliseconds: 1500),
      speechText: hintText ?? 'Almost! Listen once more.',
    );
  }

  /// Sets listening state while child is speaking.
  void setListening() {
    _revertTimer?.cancel();
    state = state.copyWith(
      state: PipState.listening,
      speechBubbleText: null,
      lastActionTime: DateTime.now(),
    );
  }

  /// Sets thinking / processing state.
  void setThinking() {
    _revertTimer?.cancel();
    state = state.copyWith(
      state: PipState.thinking,
      speechBubbleText: null,
      lastActionTime: DateTime.now(),
    );
  }

  /// Numerical celebration intensity tier:
  /// - 0: none (idle, thinking, listening, etc.)
  /// - 1: routine lesson completion (happy bounce / sparkle pose, PipState.happy)
  /// - 2: major milestone (full celebration / backflip, PipState.celebrating)
  static int celebrationIntensityFor(PipState state) {
    switch (state) {
      case PipState.celebrating:
        return 2; // Major milestone: mission complete, world unlock, level complete
      case PipState.happy:
      case PipState.excited:
        return 1; // Routine lesson completion: happy bounce / sparkle pose
      default:
        return 0;
    }
  }

  /// Celebrates routine lesson completion with moderate intensity (Tier 3: happy bounce / sparkle pose).
  /// Routine lesson completions do NOT trigger Pip's large backflip celebration.
  void celebrateRoutineLesson({String? message}) {
    _consecutiveTrivialTaps = 0;
    transitionTo(
      PipState.happy,
      duration: const Duration(milliseconds: 1600),
      speechText: message ?? 'Adventure complete! 🌟',
    );
  }

  /// Celebrates major milestone (mission complete, world unlock, level complete).
  /// Triggers Pip's full celebration (Tier 4: major backflip / cheering).
  void celebrateMajorMilestone({String? message}) {
    _consecutiveTrivialTaps = 0;
    transitionTo(
      PipState.celebrating,
      duration: const Duration(milliseconds: 2500),
      speechText: message ?? 'Incredible milestone! 🏆',
    );
  }

  /// Celebrates major milestone (preserved for backward compatibility).
  void celebrateMilestone({String? message}) => celebrateMajorMilestone(message: message);

  /// Resets Pip immediately to idle state.
  void resetToIdle() {
    _revertTimer?.cancel();
    state = state.copyWith(
      state: PipState.idle,
      speechBubbleText: null,
    );
  }

  @override
  void dispose() {
    _revertTimer?.cancel();
    super.dispose();
  }
}

/// Global provider for PipStateController.
final pipStateControllerProvider =
    StateNotifierProvider<PipStateController, PipCompanionState>((ref) {
  return PipStateController();
});
