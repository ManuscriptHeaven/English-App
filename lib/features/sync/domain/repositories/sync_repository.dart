import '../models/sync_operation.dart';
import '../models/sync_status.dart';

/// Abstract repository for persisting and querying the sync queue.
abstract class ISyncRepository {
  Future<void> enqueueOperation(SyncOperation op);
  Future<List<SyncOperation>> getPendingOperations({int limit = 50});
  Future<void> markOperationCompleted(String operationId);
  Future<void> markOperationFailed(String operationId, {int maxRetries = 3});
  Future<int> getPendingCount();
  Future<SyncStatusInfo> getSyncStatus();
}
