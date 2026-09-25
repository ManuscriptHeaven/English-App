/// Deterministic conflict resolution rules for multi-device offline sync.
class SyncConflictResolver {
  /// Determines whether an incoming cloud record should supersede the local record.
  static bool shouldApplyCloudUpdate({
    required String entityType,
    required Map<String, dynamic> localRecord,
    required Map<String, dynamic> cloudRecord,
  }) {
    // Rule 1: LearningSignals and Sessions are append-only
    if (entityType == 'learning_signal' || entityType == 'learning_session') {
      return false; // Existing signals are immutable
    }

    // Rule 2: Rewards check for duplicate event IDs
    if (entityType == 'reward_transaction') {
      final localTxId = localRecord['id'] as String?;
      final cloudTxId = cloudRecord['id'] as String?;
      if (localTxId != null && localTxId == cloudTxId) {
        return false; // Idempotent: already processed
      }
    }

    // Rule 3: Mutable profile and settings use latest updatedAt timestamp
    final localTimeStr = localRecord['updatedAt'] as String?;
    final cloudTimeStr = cloudRecord['updatedAt'] as String?;

    if (localTimeStr == null) return true;
    if (cloudTimeStr == null) return false;

    final localTime = DateTime.tryParse(localTimeStr) ?? DateTime(1970);
    final cloudTime = DateTime.tryParse(cloudTimeStr) ?? DateTime(1970);

    return cloudTime.isAfter(localTime);
  }

  /// Verifies reward idempotency by checking if an event has already been granted.
  static bool isRewardAlreadyProcessed(List<String> processedEventIds, String newEventId) {
    return processedEventIds.contains(newEventId);
  }
}
