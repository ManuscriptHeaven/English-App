import '../domain/models/sync_operation.dart';
import '../domain/models/sync_status.dart';
import '../domain/repositories/sync_repository.dart';

/// In-memory/local repository implementation for offline sync queue management.
class LocalSyncRepository implements ISyncRepository {
  final Map<String, SyncOperation> _queue = {};
  DateTime? _lastSyncedAt;
  bool _isOnline = true;

  void setOnline(bool online) {
    _isOnline = online;
  }

  @override
  Future<void> enqueueOperation(SyncOperation op) async {
    _queue[op.id] = op;
  }

  @override
  Future<List<SyncOperation>> getPendingOperations({int limit = 50}) async {
    return _queue.values
        .where((op) => op.syncStatus == SyncOpStatus.pending)
        .take(limit)
        .toList();
  }

  @override
  Future<void> markOperationCompleted(String operationId) async {
    final op = _queue[operationId];
    if (op != null) {
      _queue[operationId] = op.copyWith(syncStatus: SyncOpStatus.synced);
      _lastSyncedAt = DateTime.now();
    }
  }

  @override
  Future<void> markOperationFailed(String operationId, {int maxRetries = 3}) async {
    final op = _queue[operationId];
    if (op != null) {
      final newRetries = op.retryCount + 1;
      _queue[operationId] = op.copyWith(
        retryCount: newRetries,
        lastAttemptAt: DateTime.now(),
        syncStatus: newRetries >= maxRetries ? SyncOpStatus.failed : SyncOpStatus.pending,
      );
    }
  }

  @override
  Future<int> getPendingCount() async {
    return _queue.values.where((op) => op.syncStatus == SyncOpStatus.pending).length;
  }

  @override
  Future<SyncStatusInfo> getSyncStatus() async {
    if (!_isOnline) {
      return SyncStatusInfo(
        state: SyncState.offline,
        pendingCount: await getPendingCount(),
        lastSyncedAt: _lastSyncedAt,
      );
    }

    final pending = await getPendingCount();
    if (pending > 0) {
      return SyncStatusInfo(
        state: SyncState.pending,
        pendingCount: pending,
        lastSyncedAt: _lastSyncedAt,
      );
    }

    return SyncStatusInfo(
      state: SyncState.synced,
      pendingCount: 0,
      lastSyncedAt: _lastSyncedAt ?? DateTime.now(),
    );
  }
}
