import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';
import '../../domain/models/world.dart';
import '../../domain/models/lesson.dart';
import '../../domain/repositories/world_repository.dart';
import '../../data/v2_curriculum_world_repository.dart';

final worldRepositoryProvider = Provider<IWorldRepository>((ref) {
  return V2CurriculumWorldRepository();
});

final worldsListProvider = FutureProvider<List<World>>((ref) async {
  final repo = ref.watch(worldRepositoryProvider);
  final child = ref.watch(activeChildProfileProvider);
  final track = child != null ? CurriculumTrack.forAge(child.age) : CurriculumTrack.track1LittleListeners;

  if (repo is V2CurriculumWorldRepository) {
    return repo.getWorldsForTrack(track);
  }
  return repo.getAllWorlds();
});

final selectedWorldIdProvider = StateProvider<String>((ref) {
  final child = ref.watch(activeChildProfileProvider);
  final track = child != null ? CurriculumTrack.forAge(child.age) : CurriculumTrack.track1LittleListeners;
  return V2CurriculumWorldRepository.defaultWorldIdForTrack(track);
});

final selectedWorldProvider = FutureProvider<World?>((ref) async {
  final repo = ref.watch(worldRepositoryProvider);
  final id = ref.watch(selectedWorldIdProvider);
  final world = await repo.getWorldById(id);
  if (world != null) return world;

  // Fallback to track's default world if selected ID is invalid
  final child = ref.watch(activeChildProfileProvider);
  final track = child != null ? CurriculumTrack.forAge(child.age) : CurriculumTrack.track1LittleListeners;
  final defaultId = V2CurriculumWorldRepository.defaultWorldIdForTrack(track);
  return repo.getWorldById(defaultId);
});

final worldDetailProvider = FutureProvider.family<World?, String>((ref, id) async {
  final repo = ref.watch(worldRepositoryProvider);
  return repo.getWorldById(id);
});

final lessonDetailProvider = FutureProvider.family<Lesson?, String>((ref, lessonId) async {
  final repo = ref.watch(worldRepositoryProvider);
  return repo.getLessonById(lessonId);
});
