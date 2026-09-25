import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/world.dart';
import '../../domain/models/lesson.dart';
import '../../domain/repositories/world_repository.dart';
import '../../data/mock_world_repository.dart';

final worldRepositoryProvider = Provider<IWorldRepository>((ref) {
  return MockWorldRepository();
});

final worldsListProvider = FutureProvider<List<World>>((ref) async {
  final repo = ref.watch(worldRepositoryProvider);
  return repo.getAllWorlds();
});

final selectedWorldIdProvider = StateProvider<String>((ref) => 'world_animal');

final selectedWorldProvider = FutureProvider<World?>((ref) async {
  final repo = ref.watch(worldRepositoryProvider);
  final id = ref.watch(selectedWorldIdProvider);
  return repo.getWorldById(id);
});

final worldDetailProvider = FutureProvider.family<World?, String>((ref, id) async {
  final repo = ref.watch(worldRepositoryProvider);
  return repo.getWorldById(id);
});

final lessonDetailProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final repo = ref.watch(worldRepositoryProvider);
  return repo.getLessonById(lessonId);
});
