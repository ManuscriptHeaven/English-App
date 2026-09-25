import '../domain/adaptive/learning_session.dart';
import '../domain/repositories/learning_session_repository.dart';

/// Thread-safe in-memory implementation of [ILearningSessionRepository]
/// enforcing strict child profile isolation.
class MockLearningSessionRepository implements ILearningSessionRepository {
  // childId -> (sessionId -> LearningSession)
  final Map<String, Map<String, LearningSession>> _storage = {};

  @override
  Future<LearningSession?> getActiveSessionForChild(String childId) async {
    final childSessions = _storage[childId];
    if (childSessions == null || childSessions.isEmpty) return null;

    // Find any session that is inProgress, paused, or planned
    for (final session in childSessions.values) {
      if (session.status == SessionStatus.inProgress ||
          session.status == SessionStatus.paused ||
          session.status == SessionStatus.planned) {
        return session;
      }
    }
    return null;
  }

  @override
  Future<List<LearningSession>> getSessionHistoryForChild(String childId) async {
    final childSessions = _storage[childId];
    if (childSessions == null) return [];
    final list = childSessions.values.toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> saveSession(LearningSession session) async {
    final childSessions = _storage.putIfAbsent(session.childId, () => {});
    childSessions[session.sessionId] = session;
  }

  @override
  Future<void> deleteSession(String sessionId, String childId) async {
    _storage[childId]?.remove(sessionId);
  }

  @override
  Future<void> clearSessionsForChild(String childId) async {
    _storage.remove(childId);
  }
}
