import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local_sync_repository.dart';
import '../../domain/models/sync_status.dart';
import '../../domain/repositories/sync_repository.dart';
import '../../domain/services/sync_service.dart';

final syncRepositoryProvider = Provider<ISyncRepository>((ref) {
  return LocalSyncRepository();
});

final syncServiceProvider = Provider<SyncService>((ref) {
  final repo = ref.watch(syncRepositoryProvider);
  return SyncService(repo);
});

final syncStatusProvider = FutureProvider<SyncStatusInfo>((ref) async {
  final syncService = ref.watch(syncServiceProvider);
  return syncService.getStatus();
});
