import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import '../models/conversation.dart';
import '../models/conversation_option.dart';
import '../models/conversation_turn.dart';

/// State and logic coordinator for interactive scripted conversations.
class ConversationEngine {
  final Conversation conversation;
  int _currentTurnIndex = 0;
  int _attemptCount = 0;
  bool _isCompleted = false;
  final List<LearningSignal> _recordedSignals = [];

  ConversationEngine({required this.conversation});

  int get currentTurnIndex => _currentTurnIndex;
  int get attemptCount => _attemptCount;
  bool get isCompleted => _isCompleted;
  List<LearningSignal> get recordedSignals => List.unmodifiable(_recordedSignals);

  ConversationTurn? get currentTurn {
    if (_isCompleted || _currentTurnIndex >= conversation.turns.length) {
      return null;
    }
    return conversation.turns[_currentTurnIndex];
  }

  /// Evaluates tap choice response.
  bool submitChoice(ConversationOption option) {
    _attemptCount++;
    final isCorrect = option.isCorrect;

    _recordSignal(
      isCorrect: isCorrect,
      score: isCorrect ? 1.0 : 0.4,
    );

    if (isCorrect) {
      _advanceTurn();
    }
    return isCorrect;
  }

  /// Evaluates speech response against the expected sentence.
  double submitSpeech(String spokenText) {
    _attemptCount++;
    final turn = currentTurn;
    if (turn == null) return 0.0;

    final normalizedSpoken = _normalizeText(spokenText);
    final normalizedExpected = _normalizeText(turn.expectedResponse);

    double similarity = 0.0;
    if (normalizedSpoken == normalizedExpected) {
      similarity = 1.0;
    } else if (normalizedSpoken.contains(normalizedExpected) ||
        normalizedExpected.contains(normalizedSpoken)) {
      similarity = 0.8;
    } else {
      similarity = 0.3;
    }

    final isCorrect = similarity >= 0.7;
    _recordSignal(
      isCorrect: isCorrect,
      score: similarity,
    );

    if (isCorrect) {
      _advanceTurn();
    }
    return similarity;
  }

  void _recordSignal({required bool isCorrect, required double score}) {
    final turn = currentTurn;
    if (turn == null) return;

    final signal = LearningSignal(
      id: 'sig_conv_${DateTime.now().microsecondsSinceEpoch}',
      childId: 'active_child',
      contentId: '${conversation.id}_turn_$_currentTurnIndex',
      activityId: 'activity_weather_conversation',
      worldId: 'world_nature',
      skill: conversation.skill,
      score: score,
      attempts: _attemptCount,
      responseTimeMs: 2500,
      timestamp: DateTime.now(),
      mistakeType: isCorrect ? MistakeType.none : MistakeType.pronunciationSimilarity,
    );
    _recordedSignals.add(signal);
  }

  void _advanceTurn() {
    final turn = currentTurn;
    _attemptCount = 0;
    if (turn?.nextTurnIndex != null) {
      _currentTurnIndex = turn!.nextTurnIndex!;
    } else {
      _currentTurnIndex++;
    }

    if (_currentTurnIndex >= conversation.turns.length) {
      _isCompleted = true;
    }
  }

  static String _normalizeText(String input) {
    return input
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s']"), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
}
