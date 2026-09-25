import 'dart:developer' as dev;

/// Abstract interface for recording child educational telemetry and engagement events.
abstract class IAnalyticsService {
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters});
  Future<void> logLessonStarted({required String lessonId, required String worldId});
  Future<void> logLessonCompleted({
    required String lessonId,
    required String worldId,
    required int stars,
    required int xpEarned,
  });
  Future<void> logWordLearned({required String wordId, required String childId});
  Future<void> logStoryCompleted({required String storyId, required String childId});
  Future<void> logValueReinforced({required String valueId, required String context});
}

/// In-memory / Console implementation for Phase 01.
class MockAnalyticsService implements IAnalyticsService {
  @override
  Future<void> logEvent(String eventName, {Map<String, dynamic>? parameters}) async {
    dev.log('📊 [Analytics] Event: $eventName | Params: $parameters');
  }

  @override
  Future<void> logLessonStarted({required String lessonId, required String worldId}) async {
    await logEvent('lesson_started', parameters: {'lesson_id': lessonId, 'world_id': worldId});
  }

  @override
  Future<void> logLessonCompleted({
    required String lessonId,
    required String worldId,
    required int stars,
    required int xpEarned,
  }) async {
    await logEvent('lesson_completed', parameters: {
      'lesson_id': lessonId,
      'world_id': worldId,
      'stars': stars,
      'xp_earned': xpEarned,
    });
  }

  @override
  Future<void> logWordLearned({required String wordId, required String childId}) async {
    await logEvent('word_learned', parameters: {'word_id': wordId, 'child_id': childId});
  }

  @override
  Future<void> logStoryCompleted({required String storyId, required String childId}) async {
    await logEvent('story_completed', parameters: {'story_id': storyId, 'child_id': childId});
  }

  @override
  Future<void> logValueReinforced({required String valueId, required String context}) async {
    await logEvent('value_reinforced', parameters: {'value_id': valueId, 'context': context});
  }
}
