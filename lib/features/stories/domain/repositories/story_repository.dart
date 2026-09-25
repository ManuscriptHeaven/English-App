import 'package:kids_english_adventure/features/stories/domain/models/story.dart';

/// Abstract repository for querying and reading interactive storybooks.
abstract class IStoryRepository {
  Future<List<Story>> getStoriesForWorld(String worldId);
  Future<Story?> getStoryById(String id);
}
