import 'dart:async';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_session.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_session_summary.dart';
import 'ai_analytics_service.dart';
import 'ai_conversation_state_machine.dart';
import 'ai_response_validator.dart';
import 'ai_safety_guard.dart';
import 'ai_usage_manager.dart';
import 'i_ai_provider.dart';
import 'mock_ai_provider.dart';
import 'scripted_dialogue_engine.dart';

/// Production-hardened coordinator managing safe, curriculum-bounded AI interactions.
class AiTutorService {
  final IAiProvider _provider;
  final AiUsageManager _usageManager;
  final AiAnalyticsService _analyticsService;
  final List<LearningSignal> _emittedSignals = [];
  final List<AiConversationSession> _completedSessions = [];
  final Map<String, AiConversationStateMachine> _sessionStateMachines = {};

  AiTutorService({
    IAiProvider? provider,
    AiUsageManager? usageManager,
    AiAnalyticsService? analyticsService,
  })  : _provider = provider ?? const MockAiProvider(),
        _usageManager = usageManager ?? AiUsageManager(),
        _analyticsService = analyticsService ?? AiAnalyticsService();

  List<LearningSignal> get emittedSignals => List.unmodifiable(_emittedSignals);
  List<AiConversationSession> get completedSessions => List.unmodifiable(_completedSessions);
  AiUsageManager get usageManager => _usageManager;
  AiAnalyticsService get analytics => _analyticsService;

  /// Begins a new session and initializes its state machine.
  AiConversationSession startSession({
    required String childId,
    required AiCurriculumContext context,
    required AiParentSettings settings,
  }) {
    final now = DateTime.now();
    final session = AiConversationSession(
      id: 'session_ai_${now.microsecondsSinceEpoch}',
      childId: childId,
      worldId: context.currentWorldId,
      lessonId: context.currentLessonId,
      mode: context.mode,
      objective: context.conversationObjective,
      startedAt: now,
      skill: context.targetSkill,
      targetVocabulary: context.targetVocabulary,
      targetGrammar: context.targetGrammar,
      targetValue: context.targetValueId,
    );

    _sessionStateMachines[session.id] = AiConversationStateMachine(maxTurns: settings.dailyTurnsLimit);
    _usageManager.recordSessionStart(childId);
    _analyticsService.logSessionStarted(
      childId: childId,
      mode: context.mode.name,
      worldId: context.currentWorldId,
    );

    return session;
  }

  /// Processes child turn through safety, generation, validation, and learning signal pipelines.
  Future<AiConversationTurn> processChildTurn({
    required String sessionId,
    required String childId,
    required String childInput,
    required AiCurriculumContext context,
    required AiParentSettings settings,
    required List<String> turnHistory,
    AiInputType inputType = AiInputType.speech,
  }) async {
    final now = DateTime.now();
    final isSpoken = inputType == AiInputType.speech;
    final stateMachine = _sessionStateMachines.putIfAbsent(sessionId, () => AiConversationStateMachine());

    // 1. Deterministic Safety Guard Pre-filter
    final safetyCheck = AiSafetyGuard.inspectInput(childInput, childId: childId);
    if (!safetyCheck.isSafe) {
      _usageManager.recordTurn(
        childId: childId,
        isSuccess: false,
        isFallback: true,
      );
      _analyticsService.logSafetyTriggered(childId: childId, category: safetyCheck.blockedReason ?? 'safety_triggered');

      return AiConversationTurn(
        id: 'turn_${now.microsecondsSinceEpoch}',
        sessionId: sessionId,
        speaker: AiSpeaker.character,
        text: safetyCheck.redirectMessage,
        timestamp: now,
        inputType: inputType,
        validationStatus: AiValidationStatus.rejectedSafety,
      );
    }

    // 2. Budget & Parent Policy Check
    if (!_usageManager.canPerformTurn(childId: childId, settings: settings) || !settings.aiTutorEnabled) {
      _usageManager.recordTurn(
        childId: childId,
        isSuccess: true,
        isFallback: true,
      );

      final fallbackScript = ScriptedDialogueEngine.processTurn(
        childInput: safetyCheck.sanitizedInput,
        context: context,
        turnIndex: turnHistory.length,
        currentState: stateMachine.currentState,
      );

      return AiConversationTurn(
        id: 'turn_${now.microsecondsSinceEpoch}',
        sessionId: sessionId,
        speaker: AiSpeaker.character,
        text: fallbackScript.text,
        timestamp: now,
        inputType: inputType,
        validationStatus: AiValidationStatus.fallbackApplied,
      );
    }

    // 3. Provider Generation with Safe Retry & Timeout Guard (4-sec limit)
    String rawResponse;
    bool fallbackNeeded = false;

    try {
      rawResponse = await _generateWithRetry(
        childInput: safetyCheck.sanitizedInput,
        context: context,
        turnHistory: turnHistory,
      );
    } catch (_) {
      fallbackNeeded = true;
      _analyticsService.logFallbackTriggered(childId: childId, reason: 'provider_timeout_or_offline');

      // Transition smoothly to deterministic scripted dialogue
      final fallbackScript = ScriptedDialogueEngine.processTurn(
        childInput: safetyCheck.sanitizedInput,
        context: context,
        turnIndex: turnHistory.length,
        currentState: stateMachine.currentState,
      );
      rawResponse = fallbackScript.text;
    }

    // 4. Post-generation Response Validation & Islamic Integrity Guard
    final validation = AiResponseValidator.validate(
      rawResponse: rawResponse,
      context: context,
      defaultFallback: "Great effort! Let's practice saying our favorite words together!",
    );

    // 5. Pedagogical State Machine Update
    final isAccurateTurn = validation.isValid && !fallbackNeeded;
    stateMachine.transition(
      isAccurate: isAccurateTurn,
      currentTurnCount: turnHistory.length ~/ 2,
    );

    // 6. Emit Learning Signal into Adventure Brain
    final signalId = 'sig_ai_${now.microsecondsSinceEpoch}';
    final signal = LearningSignal(
      id: signalId,
      childId: childId,
      skill: context.targetSkill,
      contentId: 'ai_${context.currentWorldId}_${context.mode.name}',
      activityId: 'activity_talk_with_pip',
      worldId: context.currentWorldId,
      score: isAccurateTurn ? 0.95 : 0.65,
      attempts: 1,
      responseTimeMs: 1200,
      timestamp: now,
      mistakeType: isAccurateTurn ? MistakeType.none : MistakeType.pronunciationSimilarity,
    );
    _emittedSignals.add(signal);

    // 7. Record usage and educational analytics
    _usageManager.recordTurn(
      childId: childId,
      isSuccess: isAccurateTurn,
      isFallback: fallbackNeeded || !validation.isValid,
    );

    _analyticsService.logTurnCompleted(
      childId: childId,
      mode: context.mode.name,
      isSpoken: isSpoken,
      isSuccess: isAccurateTurn,
    );

    return AiConversationTurn(
      id: 'turn_${now.microsecondsSinceEpoch}',
      sessionId: sessionId,
      speaker: AiSpeaker.character,
      text: validation.sanitizedResponse,
      timestamp: now,
      inputType: inputType,
      validationStatus: fallbackNeeded ? AiValidationStatus.fallbackApplied : validation.status,
      learningSignalId: signalId,
      confidenceScore: isAccurateTurn ? 0.95 : 0.65,
    );
  }

  /// Attempts generation with a 1-time immediate retry before declaring fallback.
  Future<String> _generateWithRetry({
    required String childInput,
    required AiCurriculumContext context,
    required List<String> turnHistory,
  }) async {
    try {
      return await _provider
          .generateResponse(
            childInput: childInput,
            context: context,
            recentTurnHistory: turnHistory,
          )
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      // 1-time retry
      return await _provider
          .generateResponse(
            childInput: childInput,
            context: context,
            recentTurnHistory: turnHistory,
          )
          .timeout(const Duration(seconds: 4));
    }
  }

  /// Evaluates speech input pronunciation.
  Future<ChildResponseAnalysis> analyzeSpeechInput({
    required String spokenText,
    required String expectedTarget,
    required AiCurriculumContext context,
  }) async {
    try {
      return await _provider
          .analyzeChildResponse(
            childResponse: spokenText,
            targetPhrase: expectedTarget,
            context: context,
          )
          .timeout(const Duration(seconds: 4));
    } catch (_) {
      final match = spokenText.toLowerCase().trim() == expectedTarget.toLowerCase().trim();
      return ChildResponseAnalysis(
        isAccurate: match,
        score: match ? 0.95 : 0.65,
        encouragingFeedback: match ? 'Awesome pronunciation! 🌟' : 'Good try! Let\'s say: "$expectedTarget"',
      );
    }
  }

  /// Ends session and generates educational summary.
  AiSessionSummary endSession(
    AiConversationSession session, {
    AiSessionCompletionReason reason = AiSessionCompletionReason.objectiveMet,
    List<String> repeatedMistakes = const [],
  }) {
    final endedSession = session.copyWith(
      endedAt: DateTime.now(),
      completed: true,
      completionReason: reason,
    );

    _completedSessions.add(endedSession);
    _sessionStateMachines.remove(session.id);

    final summary = AiSessionSummary.generate(
      sessionId: session.id,
      childId: session.childId,
      mode: session.mode,
      totalTurns: session.turnCount,
      spokenTurns: session.spokenTurns,
      successfulTurns: session.successfulTurns,
      targetVocabulary: session.targetVocabulary,
      targetGrammar: session.targetGrammar,
      repeatedMistakes: repeatedMistakes,
      fallbackUsed: session.fallbackUsed,
    );

    _analyticsService.logSessionCompleted(
      childId: session.childId,
      totalTurns: session.turnCount,
      score: summary.speakingAccuracy,
      fallbackUsed: session.fallbackUsed,
    );

    return summary;
  }
}
