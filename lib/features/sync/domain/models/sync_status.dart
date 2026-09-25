/// Real-time status of background cloud synchronization.
enum SyncState {
  synced,
  syncing,
  offline,
  pending,
  failed,
}

/// Sync status view model.
class SyncStatusInfo {
  final SyncState state;
  final int pendingCount;
  final DateTime? lastSyncedAt;
  final String? message;

  const SyncStatusInfo({
    this.state = SyncState.synced,
    this.pendingCount = 0,
    this.lastSyncedAt,
    this.message,
  });

  String get displayLabel {
    switch (state) {
      case SyncState.synced:
        return 'Synced ✓';
      case SyncState.syncing:
        return 'Syncing...';
      case SyncState.offline:
        return 'Offline';
      case SyncState.pending:
        return '$pendingCount items pending sync';
      case SyncState.failed:
        return 'Sync needs attention';
    }
  }
}
