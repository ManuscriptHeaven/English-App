import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/adaptive/learning_session.dart';
import '../../domain/adaptive/learning_session_summary.dart';
import '../../domain/adaptive/mastery_engine.dart';
import '../../domain/adaptive/session_pip_guide.dart';
import '../../domain/repositories/learning_session_repository.dart';
import '../../domain/repositories/vocabulary_mastery_repository.dart';

/// State representation of the active learning session runtime.
class SessionRuntimeState extends Equatable {
  final LearningSession? session;
  final bool isLoading;
  final String? errorMessage;
  final LearningSessionSummary? lastCompletedSummary;
  final int totalSessionCoinsEarned;
  final int totalSessionXpEarned;
  final int totalSessionStarsEarned;

  const SessionRuntimeState({
    this.session,
    this.isLoading = false,
    this.errorMessage,
    this.lastCompletedSummary,
    this.totalSessionCoinsEarned = 0,
    this.totalSessionXpEarned = 0,
    this.totalSessionStarsEarned = 0,
  });

  bool get hasActiveSession =>
      session != null &&
      (session!.status == SessionStatus.inProgress ||
          session!.status == SessionStatus.paused ||
          session!.status == SessionStatus.planned);

  SessionRuntimeState copyWith({
    LearningSession? session,
    bool? isLoading,
    String? errorMessage,
    LearningSessionSummary? lastCompletedSummary,
    int? totalSessionCoinsEarned,
    int? totalSessionXpEarned,
    int? totalSessionStarsEarned,
  }) {
    return SessionRuntimeState(
      session: session ?? this.session,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lastCompletedSummary: lastCompletedSummary ?? this.lastCompletedSummary,
      totalSessionCoinsEarned: totalSessionCoinsEarned ?? this.totalSessionCoinsEarned,
      totalSessionXpEarned: totalSessionXpEarned ?? this.totalSessionXpEarned,
      totalSessionStarsEarned: totalSessionStarsEarned ?? this.totalSessionStarsEarned,
    );
  }

  @override
  List<Object?> get props => [
        session,
        isLoading,
        errorMessage,
        lastCompletedSummary,
        totalSessionCoinsEarned,
        totalSessionXpEarned,
        totalSessionStarsEarned,
      ];
}

/// Manages active learning session transitions, pause/resume, reward idempotency,
/// vocabulary mastery recording, and session summary creation.
class SessionRuntimeController extends StateNotifier<SessionRuntimeState> {
  final ILearningSessionRepository sessionRepository;
  final IVocabularyMasteryRepository masteryRepository;
  final MasteryEngine masteryEngine;
  final SessionPipGuide pipGuide;

  SessionRuntimeState get currentState => state;

  SessionRuntimeController({
    required this.sessionRepository,
    required this.masteryRepository,
    this.masteryEngine = const MasteryEngine(),
    this.pipGuide = const SessionPipGuide(),
    SessionRuntimeState initialState = const SessionRuntimeState(),
  }) : super(initialState);

  /// Load any active session from storage for a child.
  Future<void> loadActiveSession(String childId) async {
    state = state.copyWith(isLoading: true);
    try {
      final active = await sessionRepository.getActiveSessionForChild(childId);
      state = state.copyWith(
        session: active,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load active session: $e',
      );
    }
  }

  /// Sets or starts a new session.
  Future<void> startSession(LearningSession session) async {
    final started = session.status == SessionStatus.planned
        ? session.start()
        : session;
    state = state.copyWith(
      session: started,
      errorMessage: null,
    );
    await sessionRepository.saveSession(started);
  }

  /// Pauses the active session.
  Future<void> pauseSession() async {
    final current = state.session;
    if (current == null) return;
    final paused = current.pause();
    state = state.copyWith(session: paused);
    await sessionRepository.saveSession(paused);
  }

  /// Resumes the active session.
  Future<void> resumeSession() async {
    final current = state.session;
    if (current == null) return;
    final resumed = current.resume();
    state = state.copyWith(session: resumed);
    await sessionRepository.saveSession(resumed);
  }

  /// Completes a specific activity (or the current activity) in the session.
  /// Handles reward idempotency, mastery updates, and final session closure.
  Future<void> completeActivity({
    String? activityId,
    double score = 1.0,
    bool isCorrect = true,
    bool usedHint = false,
    LearningEvidenceSource source = LearningEvidenceSource.unpromptedRecall,
    DateTime? completedAt,
  }) async {
    final current = state.session;
    if (current == null) return;

    final targetAct = activityId != null
        ? current.activities.firstWhere((a) => a.activityId == activityId, orElse: () => current.currentActivity!)
        : current.currentActivity;

    if (targetAct == null) return;

    final targetId = targetAct.activityId;
    final now = completedAt ?? DateTime.now();

    // 1. Advance activity inside the session
    var updatedSession = current.completeActivity(
      targetId,
      score: score,
      completedAt: now,
    );

    // 2. Idempotent Rewards for this activity
    final rewardKey = 'reward_act_${targetId}_${current.sessionId}';
    int earnedCoins = 0;
    int earnedXp = 0;
    if (!current.isRewardGranted(rewardKey)) {
      earnedCoins = 5;
      earnedXp = 15;
      updatedSession = updatedSession.grantReward(rewardKey);
    }

    // 3. Update Vocabulary Mastery for targeted vocabulary
    for (final vocabId in targetAct.targetVocabularyIds) {
      try {
        final existingMastery = await masteryRepository.getMastery(
          childId: current.childId,
          vocabularyId: vocabId,
        );

        final evidence = LearningEvidence(
          childId: current.childId,
          vocabularyId: vocabId,
          word: vocabId.replaceFirst('vocab_', ''),
          isCorrect: isCorrect,
          usedHint: usedHint,
          source: source,
          isIndependentRecall: !usedHint,
          timestamp: now,
        );

        final newMastery = masteryEngine.recordAttempt(
          currentMastery: existingMastery,
          evidence: evidence,
        );

        await masteryRepository.saveMastery(newMastery);
      } catch (_) {
        // Safe failover; do not block user flow
      }
    }

    // 4. If all activities are finished, close session and award bonus idempotently
    LearningSessionSummary? summary;
    int sessionStars = 0;

    if (updatedSession.isCompleted) {
      final completionRewardKey = 'reward_session_complete_${current.sessionId}';
      if (!updatedSession.isRewardGranted(completionRewardKey)) {
        earnedCoins += 20;
        earnedXp += 50;
        sessionStars = 3;
        updatedSession = updatedSession.grantReward(completionRewardKey);
      }

      summary = LearningSessionSummary.fromSession(
        session: updatedSession,
        overallAccuracy: score,
      );
    }

    state = state.copyWith(
      session: updatedSession,
      lastCompletedSummary: summary ?? state.lastCompletedSummary,
      totalSessionCoinsEarned: state.totalSessionCoinsEarned + earnedCoins,
      totalSessionXpEarned: state.totalSessionXpEarned + earnedXp,
      totalSessionStarsEarned: state.totalSessionStarsEarned + sessionStars,
    );

    await sessionRepository.saveSession(updatedSession);
  }

  /// Abandons or cancels the current session.
  Future<void> abandonSession() async {
    final current = state.session;
    if (current == null) return;
    final abandoned = current.markAbandoned();
    state = state.copyWith(session: abandoned);
    await sessionRepository.saveSession(abandoned);
  }
}
