import '../models/sync_operation.dart';
import '../models/sync_status.dart';
import '../repositories/sync_repository.dart';

/// Background synchronization engine managing offline queue execution and multi-device restore.
class SyncService {
  final ISyncRepository _repository;

  SyncService(this._repository);

  Future<void> enqueueChange({
    required String childId,
    required String entityType,
    required String entityId,
    required SyncOperationType operationType,
    required Map<String, dynamic> payload,
  }) async {
    final op = SyncOperation(
      id: 'sync_op_${DateTime.now().microsecondsSinceEpoch}',
      childId: childId,
      entityType: entityType,
      entityId: entityId,
      operationType: operationType,
      payload: payload,
      createdAt: DateTime.now(),
    );
    await _repository.enqueueOperation(op);
  }

  Future<int> processPendingQueue() async {
    final ops = await _repository.getPendingOperations();
    int successCount = 0;

    for (final op in ops) {
      try {
        // Simulate cloud upload & confirmation
        await _repository.markOperationCompleted(op.id);
        successCount++;
      } catch (e) {
        await _repository.markOperationFailed(op.id);
      }
    }

    return successCount;
  }

  Future<SyncStatusInfo> getStatus() => _repository.getSyncStatus();
}
