import 'dart:async';
import '../models/learning_age_band.dart';
import 'pip_dialogue_pool.dart';

/// Distinct auditory cue types for learning activities, calibrated for emotional safety.
enum LearningSoundEffect {
  tap,
  select,
  correctSoft,
  correctStrong,
  recoverySuccess,
  streak,
  incorrectGentle,
  hint,
  starEarned,
  rewardUnlocked,
  lessonComplete,
  levelComplete,
  pipAppear;

  String get sfxKey => name;
}

/// Visual celebration tier matching the educational milestone.
enum VisualFeedbackType {
  none,
  softCheck,
  sparkle,
  starPop,
  pipCheer,
  confettiBurst,
}

/// Decoupled presentation event triggered during learning interactions.
class LearningFeedbackEvent {
  final LearningSoundEffect sound;
  final VisualFeedbackType visual;
  final String? pipMessage;
  final DateTime timestamp;

  const LearningFeedbackEvent({
    required this.sound,
    this.visual = VisualFeedbackType.none,
    this.pipMessage,
    required this.timestamp,
  });
}

/// Abstract audio delegate so sound effects can be tested headlessly without platform channels.
abstract class IFeedbackAudioPlayer {
  Future<void> playSfx(LearningSoundEffect sfx);
  Future<void> stopAll();
}

/// No-op / mock audio player for testing and headless environments.
class MockFeedbackAudioPlayer implements IFeedbackAudioPlayer {
  final List<LearningSoundEffect> playedSounds = [];

  @override
  Future<void> playSfx(LearningSoundEffect sfx) async {
    playedSounds.add(sfx);
  }

  @override
  Future<void> stopAll() async {}
}

/// Decoupled presentation feedback engine handling sound effects, debouncing,
/// Pip encouragement animations, and milestone celebrations without owning learning scores.
class LearningFeedbackService {
  final IFeedbackAudioPlayer _audioPlayer;
  final Duration debouncingWindow;

  bool sfxEnabled;
  bool speechEnabled;
  bool musicEnabled;

  DateTime? _lastTapTime;
  DateTime? _lastRewardTime;
  final _eventController = StreamController<LearningFeedbackEvent>.broadcast();

  LearningFeedbackService({
    IFeedbackAudioPlayer? audioPlayer,
    this.debouncingWindow = const Duration(milliseconds: 250),
    this.sfxEnabled = true,
    this.speechEnabled = true,
    this.musicEnabled = true,
  }) : _audioPlayer = audioPlayer ?? MockFeedbackAudioPlayer();

  Stream<LearningFeedbackEvent> get eventStream => _eventController.stream;

  void setSfxEnabled(bool enabled) => sfxEnabled = enabled;
  void setSpeechEnabled(bool enabled) => speechEnabled = enabled;
  void setMusicEnabled(bool enabled) => musicEnabled = enabled;

  /// Emits standard correct answer feedback: soft sound + subtle sparkle.
  Future<void> triggerStandardCorrect({
    String? customPrompt,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    final message = customPrompt ?? PipDialoguePool.getPrompt(type: PipDialogueType.standardCorrect, ageBand: ageBand);
    _emitEvent(
      LearningFeedbackEvent(
        sound: LearningSoundEffect.correctSoft,
        visual: VisualFeedbackType.sparkle,
        pipMessage: message,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.correctSoft);
    }
  }

  /// Emits independent recall correct feedback: slightly stronger reward chime + star pop.
  Future<void> triggerIndependentCorrect({
    String? customPrompt,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    final message = customPrompt ?? PipDialoguePool.getPrompt(type: PipDialogueType.independentRecall, ageBand: ageBand);
    _emitEvent(
      LearningFeedbackEvent(
        sound: LearningSoundEffect.correctStrong,
        visual: VisualFeedbackType.starPop,
        pipMessage: message,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.correctStrong);
    }
  }

  /// Emits recovery success feedback after previous struggle: warm supportive sound + Pip cheer.
  Future<void> triggerRecoveryCorrect({
    String? customPrompt,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    final message = customPrompt ?? PipDialoguePool.getPrompt(type: PipDialogueType.recoverySuccess, ageBand: ageBand);
    _emitEvent(
      LearningFeedbackEvent(
        sound: LearningSoundEffect.recoverySuccess,
        visual: VisualFeedbackType.pipCheer,
        pipMessage: message,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.recoverySuccess);
    }
  }

  /// Emits gentle, non-punitive incorrect feedback: neutral cue + encouragement.
  /// Strictly avoids harsh failure buzzers.
  Future<void> triggerGentleIncorrect({
    String? encouragingPrompt,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    final message = encouragingPrompt ?? PipDialoguePool.getPrompt(type: PipDialogueType.gentleRetry, ageBand: ageBand);
    _emitEvent(
      LearningFeedbackEvent(
        sound: LearningSoundEffect.incorrectGentle,
        visual: VisualFeedbackType.none,
        pipMessage: message,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.incorrectGentle);
    }
  }

  /// Emits small musical cue when an active learning streak continues.
  Future<void> triggerStreakSound({
    required int streakCount,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    final message = PipDialoguePool.getPrompt(type: PipDialogueType.streakPraise, ageBand: ageBand);
    _emitEvent(
      LearningFeedbackEvent(
        sound: LearningSoundEffect.streak,
        visual: VisualFeedbackType.sparkle,
        pipMessage: message,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.streak);
    }
  }

  /// Emits tap feedback with debouncing to prevent audio distortion or click spamming.
  Future<void> triggerTap() async {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!) < debouncingWindow) {
      return; // Debounced
    }
    _lastTapTime = now;
    if (sfxEnabled) {
      await _audioPlayer.playSfx(LearningSoundEffect.tap);
    }
  }

  /// Emits milestone celebration feedback (lesson/level complete) with anti-spam cooldown.
  Future<void> triggerMilestoneCelebration({
    required bool isLevelComplete,
    String? celebrationTitle,
    LearningAgeBand ageBand = LearningAgeBand.bandBYoungAdventurers,
  }) async {
    final now = DateTime.now();
    if (_lastRewardTime != null && now.difference(_lastRewardTime!) < const Duration(milliseconds: 1500)) {
      return; // Prevent duplicate celebration playback
    }
    _lastRewardTime = now;

    final sfx = isLevelComplete ? LearningSoundEffect.levelComplete : LearningSoundEffect.lessonComplete;
    final defaultMessage = isLevelComplete
        ? PipDialoguePool.getPrompt(type: PipDialogueType.levelComplete, ageBand: ageBand)
        : PipDialoguePool.getPrompt(type: PipDialogueType.lessonComplete, ageBand: ageBand);

    _emitEvent(
      LearningFeedbackEvent(
        sound: sfx,
        visual: VisualFeedbackType.confettiBurst,
        pipMessage: celebrationTitle ?? defaultMessage,
        timestamp: now,
      ),
    );
    if (sfxEnabled) {
      await _audioPlayer.playSfx(sfx);
    }
  }

  void _emitEvent(LearningFeedbackEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  void dispose() {
    _eventController.close();
  }
}
