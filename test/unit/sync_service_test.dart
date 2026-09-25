import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/sync/data/local_sync_repository.dart';
import 'package:kids_english_adventure/features/sync/domain/models/sync_operation.dart';
import 'package:kids_english_adventure/features/sync/domain/models/sync_status.dart';
import 'package:kids_english_adventure/features/sync/domain/services/sync_conflict_resolver.dart';
import 'package:kids_english_adventure/features/sync/domain/services/sync_service.dart';

void main() {
  group('Cloud Sync & Conflict Resolution Tests', () {
    late LocalSyncRepository repo;
    late SyncService syncService;

    setUp(() {
      repo = LocalSyncRepository();
      syncService = SyncService(repo);
    });

    test('Enqueues offline activity completion operations into sync queue', () async {
      expect(await repo.getPendingCount(), equals(0));

      await syncService.enqueueChange(
        childId: 'child_ayaan',
        entityType: 'learning_signal',
        entityId: 'sig_food_apple_01',
        operationType: SyncOperationType.create,
        payload: {'score': 1.0, 'attempts': 1},
      );

      expect(await repo.getPendingCount(), equals(1));
      final status = await syncService.getStatus();
      expect(status.state, equals(SyncState.pending));
      expect(status.pendingCount, equals(1));
    });

    test('Processes pending queue and marks status as Synced when online', () async {
      await syncService.enqueueChange(
        childId: 'child_ayaan',
        entityType: 'learning_signal',
        entityId: 'sig_food_banana_02',
        operationType: SyncOperationType.create,
        payload: {'score': 1.0},
      );

      final processed = await syncService.processPendingQueue();
      expect(processed, equals(1));
      expect(await repo.getPendingCount(), equals(0));

      final status = await syncService.getStatus();
      expect(status.state, equals(SyncState.synced));
    });

    test('Reflects Offline sync state when device has no internet', () async {
      repo.setOnline(false);
      final status = await syncService.getStatus();
      expect(status.state, equals(SyncState.offline));
    });

    test('Conflict Resolver keeps append-only learning signals immutable', () {
      final shouldUpdate = SyncConflictResolver.shouldApplyCloudUpdate(
        entityType: 'learning_signal',
        localRecord: {'id': 'sig_1', 'score': 0.8},
        cloudRecord: {'id': 'sig_1', 'score': 0.5},
      );
      expect(shouldUpdate, isFalse);
    });

    test('Conflict Resolver prevents duplicate reward event IDs (Idempotency)', () {
      final processedRewards = ['evt_world_1_challenge', 'evt_world_2_challenge'];
      expect(
        SyncConflictResolver.isRewardAlreadyProcessed(processedRewards, 'evt_world_1_challenge'),
        isTrue,
      );
      expect(
        SyncConflictResolver.isRewardAlreadyProcessed(processedRewards, 'evt_world_4_challenge'),
        isFalse,
      );
    });

    test('Conflict Resolver updates child profile when cloud timestamp is newer', () {
      final shouldUpdate = SyncConflictResolver.shouldApplyCloudUpdate(
        entityType: 'child_profile',
        localRecord: {'id': 'child_ayaan', 'updatedAt': '2026-08-22T01:00:00.000Z'},
        cloudRecord: {'id': 'child_ayaan', 'updatedAt': '2026-08-22T02:00:00.000Z'},
      );
      expect(shouldUpdate, isTrue);
    });
  });
}
