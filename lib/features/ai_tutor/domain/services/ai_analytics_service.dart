/// Educational analytics event record for AI Tutor interactions.
class EducationalAnalyticsEvent {
  final String eventName;
  final String childId;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  const EducationalAnalyticsEvent({
    required this.eventName,
    required this.childId,
    required this.timestamp,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'eventName': eventName,
        'childId': childId,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };
}

/// Lightweight privacy-preserving analytics tracking for educational efficacy.
class AiAnalyticsService {
  final List<EducationalAnalyticsEvent> _events = [];

  List<EducationalAnalyticsEvent> get recordedEvents => List.unmodifiable(_events);

  void logEvent(String eventName, {required String childId, Map<String, dynamic> metadata = const {}}) {
    _events.add(
      EducationalAnalyticsEvent(
        eventName: eventName,
        childId: childId,
        timestamp: DateTime.now(),
        metadata: metadata,
      ),
    );
  }

  void logSessionStarted({required String childId, required String mode, required String worldId}) {
    logEvent('ai_session_started', childId: childId, metadata: {'mode': mode, 'worldId': worldId});
  }

  void logTurnCompleted({required String childId, required String mode, required bool isSpoken, required bool isSuccess}) {
    logEvent('ai_turn_completed', childId: childId, metadata: {'mode': mode, 'isSpoken': isSpoken, 'isSuccess': isSuccess});
    if (isSpoken) {
      logEvent('speaking_attempt', childId: childId, metadata: {'success': isSuccess});
      if (isSuccess) {
        logEvent('speaking_success', childId: childId);
      }
    }
  }

  void logSessionCompleted({required String childId, required int totalTurns, required double score, required bool fallbackUsed}) {
    logEvent('ai_session_completed', childId: childId, metadata: {'totalTurns': totalTurns, 'score': score, 'fallbackUsed': fallbackUsed});
  }

  void logFallbackTriggered({required String childId, required String reason}) {
    logEvent('ai_fallback_used', childId: childId, metadata: {'reason': reason});
  }

  void logSafetyTriggered({required String childId, required String category}) {
    logEvent('ai_safety_triggered', childId: childId, metadata: {'category': category});
  }

  void clear() {
    _events.clear();
  }
}
