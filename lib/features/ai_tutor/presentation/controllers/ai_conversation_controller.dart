import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_session.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_session_summary.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_tutor_service.dart';

class AiConversationState extends Equatable {
  final AiConversationSession session;
  final List<AiConversationTurn> turns;
  final bool isGenerating;
  final bool isListening;
  final String? currentFeedback;
  final bool isSessionComplete;
  final AiSessionSummary? sessionSummary;
  final List<String> repeatedMistakes;

  const AiConversationState({
    required this.session,
    this.turns = const [],
    this.isGenerating = false,
    this.isListening = false,
    this.currentFeedback,
    this.isSessionComplete = false,
    this.sessionSummary,
    this.repeatedMistakes = const [],
  });

  AiConversationState copyWith({
    AiConversationSession? session,
    List<AiConversationTurn>? turns,
    bool? isGenerating,
    bool? isListening,
    String? currentFeedback,
    bool? isSessionComplete,
    AiSessionSummary? sessionSummary,
    List<String>? repeatedMistakes,
  }) {
    return AiConversationState(
      session: session ?? this.session,
      turns: turns ?? this.turns,
      isGenerating: isGenerating ?? this.isGenerating,
      isListening: isListening ?? this.isListening,
      currentFeedback: currentFeedback,
      isSessionComplete: isSessionComplete ?? this.isSessionComplete,
      sessionSummary: sessionSummary ?? this.sessionSummary,
      repeatedMistakes: repeatedMistakes ?? this.repeatedMistakes,
    );
  }

  @override
  List<Object?> get props => [
        session,
        turns,
        isGenerating,
        isListening,
        currentFeedback,
        isSessionComplete,
        sessionSummary,
        repeatedMistakes,
      ];
}

class AiConversationController extends StateNotifier<AiConversationState> {
  final AiTutorService tutorService;
  final AiCurriculumContext context;
  final AiParentSettings settings;

  AiConversationState get currentState => state;

  AiConversationController({
    required this.tutorService,
    required this.context,
    required this.settings,
    required AiConversationSession initialSession,
    String initialPrompt = "Hello explorer! What would you like to practice today?",
  }) : super(
          AiConversationState(
            session: initialSession,
            turns: [
              AiConversationTurn(
                id: 'turn_init_0',
                sessionId: initialSession.id,
                speaker: AiSpeaker.character,
                text: initialPrompt,
                timestamp: DateTime.now(),
                validationStatus: AiValidationStatus.passed,
              ),
            ],
          ),
        );

  void setListening(bool listening) {
    state = state.copyWith(isListening: listening);
  }

  Future<void> submitChildInput({
    required String text,
    AiInputType inputType = AiInputType.speech,
  }) async {
    if (state.isGenerating || text.trim().isEmpty) return;

    final isSpoken = inputType == AiInputType.speech;
    final childTurn = AiConversationTurn(
      id: 'turn_child_${DateTime.now().microsecondsSinceEpoch}',
      sessionId: state.session.id,
      speaker: AiSpeaker.child,
      text: text.trim(),
      timestamp: DateTime.now(),
      inputType: inputType,
      validationStatus: AiValidationStatus.passed,
    );

    final updatedTurns = List<AiConversationTurn>.from(state.turns)..add(childTurn);
    state = state.copyWith(
      turns: updatedTurns,
      isGenerating: true,
      currentFeedback: null,
    );

    // Call service to process turn
    final history = updatedTurns.map((t) => '${t.speaker.name}: ${t.text}').toList();
    final characterTurn = await tutorService.processChildTurn(
      sessionId: state.session.id,
      childId: state.session.childId,
      childInput: text.trim(),
      context: context,
      settings: settings,
      turnHistory: history,
      inputType: inputType,
    );

    final isSuccess = characterTurn.validationStatus == AiValidationStatus.passed;
    final isFallback = characterTurn.validationStatus == AiValidationStatus.fallbackApplied;

    final nextTurns = List<AiConversationTurn>.from(updatedTurns)..add(characterTurn);
    final updatedSession = state.session.copyWith(
      turnCount: state.session.turnCount + 1,
      spokenTurns: isSpoken ? state.session.spokenTurns + 1 : state.session.spokenTurns,
      successfulTurns: isSuccess ? state.session.successfulTurns + 1 : state.session.successfulTurns,
      fallbackTurns: isFallback ? state.session.fallbackTurns + 1 : state.session.fallbackTurns,
      fallbackUsed: state.session.fallbackUsed || isFallback,
    );

    // Intelligent stopping: age-based or turn budget reached
    final maxAllowedTurns = context.childAge <= 4 ? 4 : 6;
    final isMaxTurnsReached = updatedSession.turnCount >= maxAllowedTurns;

    AiSessionSummary? summary;
    if (isMaxTurnsReached) {
      summary = tutorService.endSession(
        updatedSession,
        reason: AiSessionCompletionReason.objectiveMet,
        repeatedMistakes: state.repeatedMistakes,
      );
    }

    state = state.copyWith(
      session: updatedSession,
      turns: nextTurns,
      isGenerating: false,
      isSessionComplete: isMaxTurnsReached,
      sessionSummary: summary,
    );
  }

  void endSessionEarly() {
    final summary = tutorService.endSession(
      state.session,
      reason: AiSessionCompletionReason.userEnded,
      repeatedMistakes: state.repeatedMistakes,
    );
    state = state.copyWith(
      isSessionComplete: true,
      sessionSummary: summary,
    );
  }
}
