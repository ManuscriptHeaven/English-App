import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/islamic_value.dart';
import '../../domain/models/manner.dart';
import '../../domain/models/value_connection.dart';
import '../../domain/repositories/islamic_values_repository.dart';
import '../../data/mock_islamic_values_repository.dart';

final islamicValuesRepositoryProvider = Provider<IIslamicValuesRepository>((ref) {
  return MockIslamicValuesRepository();
});

final allIslamicValuesProvider = FutureProvider<List<IslamicValue>>((ref) async {
  final repo = ref.watch(islamicValuesRepositoryProvider);
  return repo.getAllValues();
});

final allMannersProvider = FutureProvider<List<Manner>>((ref) async {
  final repo = ref.watch(islamicValuesRepositoryProvider);
  return repo.getAllManners();
});

final worldValueConnectionsProvider = FutureProvider.family<List<ValueConnection>, String>((ref, worldId) async {
  final repo = ref.watch(islamicValuesRepositoryProvider);
  return repo.getValueConnectionsForWorld(worldId);
});
