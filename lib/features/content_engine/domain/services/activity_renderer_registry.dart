import '../models/activity_type.dart';

/// Registry mapping generic ActivityType to modular UI renderers.
class ActivityRendererRegistry {
  static final Map<ActivityType, String> _rendererMap = {
    ActivityType.vocabularyDiscovery: 'DiscoveryRenderer',
    ActivityType.flashcard: 'FlashcardRenderer',
    ActivityType.pictureMatch: 'PictureMatchRenderer',
    ActivityType.imageHunt: 'HuntGameRenderer',
    ActivityType.listenAndChoose: 'ListenChooseRenderer',
    ActivityType.wordMatch: 'WordMatchRenderer',
    ActivityType.sentenceBuilder: 'SentenceBuilderRenderer',
    ActivityType.fillBlank: 'FillBlankRenderer',
    ActivityType.multipleChoice: 'MultipleChoiceRenderer',
    ActivityType.sorting: 'SortingRenderer',
    ActivityType.scenarioChoice: 'ScenarioDilemmaRenderer',
    ActivityType.dialogue: 'DialogueRenderer',
    ActivityType.story: 'StoryRenderer',
    ActivityType.storyQuiz: 'StoryQuizRenderer',
    ActivityType.speaking: 'SpeakingLabRenderer',
    ActivityType.reading: 'StoryRenderer',
    ActivityType.review: 'AdaptiveReviewRenderer',
    ActivityType.reward: 'ChallengeRewardRenderer',
  };

  /// Returns true if a renderer exists for the activity type.
  static bool hasRenderer(ActivityType type) {
    return _rendererMap.containsKey(type);
  }

  /// Returns the registered renderer identifier for the given activity type.
  static String getRendererName(ActivityType type) {
    return _rendererMap[type] ?? 'GenericActivityRenderer';
  }

  /// All supported activity types in the current registry.
  static List<ActivityType> get supportedTypes => _rendererMap.keys.toList();
}
