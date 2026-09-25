import '../adaptive/learning_session.dart';

/// Abstract contract for persisting and retrieving child learning sessions.
abstract class ILearningSessionRepository {
  /// Retrieves the current active or in-progress session for a child, if any.
  Future<LearningSession?> getActiveSessionForChild(String childId);

  /// Retrieves past completed or recorded sessions for a child.
  Future<List<LearningSession>> getSessionHistoryForChild(String childId);

  /// Saves or updates a learning session.
  Future<void> saveSession(LearningSession session);

  /// Deletes a specific session.
  Future<void> deleteSession(String sessionId, String childId);

  /// Clears all sessions for a specific child (child data isolation / deletion).
  Future<void> clearSessionsForChild(String childId);
}
