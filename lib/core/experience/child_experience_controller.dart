import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/curriculum/domain/feedback/pip_dialogue_pool.dart';
import '../../features/curriculum/domain/models/learning_age_band.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';
import '../widgets/pip_character_guide.dart';
import 'child_audio_manager.dart';
import 'pip_state_controller.dart';
import 'sound_design_system.dart';

/// Centralized coordinator for child feedback, sound effects, mascot reactions,
/// celebration intensity tiers, and navigation safety.
class ChildExperienceController {
  final ChildAudioManager audioManager;
  final PipStateController pipController;
  final Ref ref;

  /// Protection against double submission / rapid navigation storms.
  final Set<String> _completedEventsThisSession = {};
  DateTime? _lastCompletionSubmissionTime;

  ChildExperienceController({
    required this.audioManager,
    required this.pipController,
    required this.ref,
  });

  /// Checks if reduced motion is requested via user settings or platform.
  bool get isReducedMotionRequested {
    try {
      final settings = ref.read(appSettingsProvider);
      return settings.highContrastMode; // Can be enhanced with reducedMotionEnabled
    } catch (_) {
      return false;
    }
  }

  /// Tier 1: Micro-interaction tap.
  void onTap() {
    audioManager.playSound(SemanticSound.tap);
  }

  /// Tier 1: Card / Choice Selection.
  void onSelection() {
    audioManager.playSound(SemanticSound.selection);
  }

  /// Tier 1 or 2: Correct answer response.
  /// Categorized into Small Success, Meaningful Recall, or Recovery Success.
  Future<void> onCorrectAnswer({
    required bool isIndependent,
    bool isRecovery = false,
    int attempts = 1,
    String? conceptId,
    LearningAgeBand ageBand = LearningAgeBand.bandALittleExplorers,
  }) async {
    if (isRecovery) {
      // Tier 3: Recovery Success (calibrated for single mistake vs repeated struggle)
      await audioManager.playSound(SemanticSound.recoverySuccess);
      final praise = PipDialoguePool.getRecoveryPrompt(
        ageBand: ageBand,
        attempts: attempts,
      );
      pipController.reactToCorrect(
        isIndependent: false,
        isRecovery: true,
        promptPraise: praise,
      );
      return;
    }

    if (isIndependent) {
      // Tier 2: Meaningful Success
      await audioManager.playSound(SemanticSound.correctIndependent);
      final praise = PipDialoguePool.getPrompt(
        type: PipDialogueType.independentRecall,
        ageBand: ageBand,
      );
      pipController.reactToCorrect(
        isIndependent: true,
        isRecovery: false,
        promptPraise: praise,
      );
    } else {
      // Tier 1: Small Success
      await audioManager.playSound(SemanticSound.correctSoft);
      final praise = PipDialoguePool.getPrompt(
        type: PipDialogueType.standardCorrect,
        ageBand: ageBand,
      );
      pipController.reactToCorrect(
        isIndependent: false,
        isRecovery: false,
        promptPraise: praise,
      );
    }
  }

  /// Tier 2: Spoken response success.
  /// Spoken production is celebrated with higher auditory warmth than a tap.
  Future<void> onSpeakingSuccess({
    required bool isIndependent,
    String? spokenText,
    LearningAgeBand ageBand = LearningAgeBand.bandALittleExplorers,
  }) async {
    await audioManager.playSound(SemanticSound.speakingSuccess);
    final praise = PipDialoguePool.getPrompt(
      type: PipDialogueType.speakingPraise,
      ageBand: ageBand,
    );
    pipController.transitionTo(
      PipState.happy,
      duration: const Duration(milliseconds: 1400),
      speechText: praise,
    );
  }

  /// Gentle non-punitive retry cue.
  /// Zero shame, zero alarm sounds, zero red failure screens.
  Future<void> onGentleRetry({
    String? hintClue,
    LearningAgeBand ageBand = LearningAgeBand.bandALittleExplorers,
  }) async {
    await audioManager.playSound(SemanticSound.gentleRetry);
    final retryPrompt = hintClue ??
        PipDialoguePool.getPrompt(
          type: PipDialogueType.gentleRetry,
          ageBand: ageBand,
        );
    pipController.reactToRetry(hintText: retryPrompt);
  }

  /// Hint requested or displayed.
  Future<void> onHintUsed({int hintLevel = 1}) async {
    await audioManager.playSound(SemanticSound.hint);
    pipController.transitionTo(
      PipState.thinking,
      duration: const Duration(milliseconds: 1000),
    );
  }

  /// Streak milestone acknowledgment (e.g. 3 correct in a row).
  Future<void> onStreakMilestone(int streakCount, {LearningAgeBand ageBand = LearningAgeBand.bandALittleExplorers}) async {
    if (streakCount < 3) return;
    await audioManager.playSound(SemanticSound.streak);
    final praise = PipDialoguePool.getPrompt(
      type: PipDialogueType.streakPraise,
      ageBand: ageBand,
    );
    pipController.transitionTo(
      PipState.excited,
      duration: const Duration(milliseconds: 1200),
      speechText: praise,
    );
  }

  /// Tier 4: Major Achievement — Lesson Completion.
  /// Protected against rapid-tap double completion.
  Future<bool> onLessonCompleted({
    required String lessonId,
    required int stars,
    required int xp,
    required int coins,
  }) async {
    final now = DateTime.now();
    if (_completedEventsThisSession.contains('lesson_$lessonId')) {
      dev.log('🛑 [ChildExperience] Suppressed duplicate lesson completion: $lessonId');
      return false;
    }
    if (_lastCompletionSubmissionTime != null &&
        now.difference(_lastCompletionSubmissionTime!) < const Duration(seconds: 2)) {
      dev.log('🛑 [ChildExperience] Suppressed rapid completion submission storm');
      return false;
    }

    _completedEventsThisSession.add('lesson_$lessonId');
    _lastCompletionSubmissionTime = now;

    await audioManager.playSound(SemanticSound.lessonComplete);
    // Routine lesson completion uses happy bounce / sparkle pose, NOT full backflip
    pipController.celebrateRoutineLesson(message: 'Adventure complete! 🌟');
    return true;
  }

  /// Tier 4: Major Achievement — World Unlocked.
  Future<bool> onWorldUnlocked({
    required String worldId,
    required String worldTitle,
  }) async {
    if (_completedEventsThisSession.contains('world_$worldId')) {
      dev.log('🛑 [ChildExperience] World $worldId already unlocked in this session');
      return false;
    }
    _completedEventsThisSession.add('world_$worldId');

    await audioManager.playSound(SemanticSound.worldUnlock);
    pipController.celebrateMajorMilestone(message: 'New World Unlocked: $worldTitle! 🗺️');
    return true;
  }

  /// Tier 4: Capstone Mission Completed.
  Future<bool> onMissionCompleted({required String missionId}) async {
    if (_completedEventsThisSession.contains('mission_$missionId')) {
      return false;
    }
    _completedEventsThisSession.add('mission_$missionId');

    await audioManager.playSound(SemanticSound.missionComplete);
    pipController.celebrateMajorMilestone(message: 'Level Mission Complete! 🏆');
    return true;
  }

  /// Cancels any active decorative animation or sound.
  void cancelActiveCelebration() {
    audioManager.stopAll();
    pipController.resetToIdle();
  }
}

/// Global provider for ChildExperienceController.
final childExperienceControllerProvider = Provider<ChildExperienceController>((ref) {
  final audio = ref.watch(childAudioManagerProvider);
  final pip = ref.watch(pipStateControllerProvider.notifier);
  return ChildExperienceController(
    audioManager: audio,
    pipController: pip,
    ref: ref,
  );
});
