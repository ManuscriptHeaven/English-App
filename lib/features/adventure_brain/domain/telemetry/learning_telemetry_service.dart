import 'learning_event.dart';

/// Abstract service contract for child learning telemetry events.
abstract class LearningTelemetryService {
  /// Records a single typed learning event.
  void recordEvent(LearningEvent event);

  /// Retrieves events for a specific child, optionally filtered by event type, activity, or time.
  List<LearningEvent> getEventsForChild(
    String childId, {
    LearningEventType? type,
    String? activityId,
    DateTime? since,
  });

  /// Counts events of a given type for a specific child.
  int countEventsForChild(
    String childId, {
    required LearningEventType type,
    String? activityId,
  });

  /// Clears all stored events for a child (e.g. on profile reset or deletion).
  void clearEventsForChild(String childId);
}

/// In-memory implementation of [LearningTelemetryService] with strict child isolation.
class InMemoryLearningTelemetryService implements LearningTelemetryService {
  final Map<String, List<LearningEvent>> _childEvents = {};

  @override
  void recordEvent(LearningEvent event) {
    _childEvents.putIfAbsent(event.childId, () => []).add(event);
  }

  @override
  List<LearningEvent> getEventsForChild(
    String childId, {
    LearningEventType? type,
    String? activityId,
    DateTime? since,
  }) {
    final list = _childEvents[childId] ?? [];
    return list.where((event) {
      if (type != null && event.eventType != type) return false;
      if (activityId != null && event.activityId != activityId) return false;
      if (since != null && event.timestamp.isBefore(since)) return false;
      return true;
    }).toList();
  }

  @override
  int countEventsForChild(
    String childId, {
    required LearningEventType type,
    String? activityId,
  }) {
    return getEventsForChild(childId, type: type, activityId: activityId).length;
  }

  @override
  void clearEventsForChild(String childId) {
    _childEvents.remove(childId);
  }
}
