import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/story.dart';
import '../../domain/repositories/story_repository.dart';
import '../../data/mock_story_repository.dart';

final storyRepositoryProvider = Provider<IStoryRepository>((ref) {
  return MockStoryRepository();
});

final storiesForWorldProvider = FutureProvider.family<List<Story>, String>((ref, worldId) async {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.getStoriesForWorld(worldId);
});

final storyDetailProvider = FutureProvider.family<Story?, String>((ref, storyId) async {
  final repo = ref.watch(storyRepositoryProvider);
  return repo.getStoryById(storyId);
});
