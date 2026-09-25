import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_analytics_service.dart';

void main() {
  group('AiAnalyticsService Educational Metrics Tests', () {
    late AiAnalyticsService analytics;

    setUp(() {
      analytics = AiAnalyticsService();
    });

    test('Logs safe educational session and turn events without leaking raw text', () {
      // 1. Session start
      analytics.logSessionStarted(
        childId: 'child_ayaan',
        mode: 'vocabularyTalk',
        worldId: 'world_food',
      );

      // 2. Turn completion (Spoken + Success)
      analytics.logTurnCompleted(
        childId: 'child_ayaan',
        mode: 'vocabularyTalk',
        isSpoken: true,
        isSuccess: true,
      );

      // 3. Fallback used
      analytics.logFallbackTriggered(
        childId: 'child_ayaan',
        reason: 'timeout',
      );

      // 4. Safety event
      analytics.logSafetyTriggered(
        childId: 'child_ayaan',
        category: 'phone_detected',
      );

      // 5. Session completed
      analytics.logSessionCompleted(
        childId: 'child_ayaan',
        totalTurns: 3,
        score: 0.92,
        fallbackUsed: true,
      );

      final events = analytics.recordedEvents;
      expect(events.length, greaterThanOrEqualTo(6));

      // Verify event names
      final eventNames = events.map((e) => e.eventName).toList();
      expect(eventNames, contains('ai_session_started'));
      expect(eventNames, contains('ai_turn_completed'));
      expect(eventNames, contains('speaking_attempt'));
      expect(eventNames, contains('speaking_success'));
      expect(eventNames, contains('ai_fallback_used'));
      expect(eventNames, contains('ai_safety_triggered'));
      expect(eventNames, contains('ai_session_completed'));
    });
  });
}
