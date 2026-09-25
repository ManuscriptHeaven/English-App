/// Distinct pedagogical states for controlled AI conversation progression.
enum ConversationState {
  intro,
  prompt,
  childResponse,
  feedback,
  scaffold,
  retry,
  success,
  review,
  complete;
}

/// Deterministic state machine governing session pacing, scaffolding, and completion.
class AiConversationStateMachine {
  ConversationState _currentState;
  int _consecutiveFailures = 0;
  int _consecutiveSuccesses = 0;
  final int maxTurns;

  AiConversationStateMachine({
    ConversationState initialState = ConversationState.intro,
    this.maxTurns = 5,
  }) : _currentState = initialState;

  ConversationState get currentState => _currentState;
  int get consecutiveFailures => _consecutiveFailures;
  int get consecutiveSuccesses => _consecutiveSuccesses;

  /// Transitions the state machine after evaluating child response accuracy.
  ConversationState transition({
    required bool isAccurate,
    required int currentTurnCount,
    bool isUserEnding = false,
  }) {
    if (isUserEnding || currentTurnCount >= maxTurns) {
      _currentState = ConversationState.complete;
      return _currentState;
    }

    if (isAccurate) {
      _consecutiveSuccesses++;
      _consecutiveFailures = 0;
      if (currentTurnCount + 1 >= maxTurns) {
        _currentState = ConversationState.complete;
      } else {
        _currentState = ConversationState.success;
      }
    } else {
      _consecutiveFailures++;
      _consecutiveSuccesses = 0;
      if (_consecutiveFailures >= 2) {
        // Trigger scaffolding helper hint
        _currentState = ConversationState.scaffold;
      } else {
        _currentState = ConversationState.retry;
      }
    }

    return _currentState;
  }

  void reset() {
    _currentState = ConversationState.intro;
    _consecutiveFailures = 0;
    _consecutiveSuccesses = 0;
  }
}
