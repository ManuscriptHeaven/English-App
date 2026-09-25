/// Supported curriculum-focused conversation modes for the AI Tutor.
enum AiMode {
  vocabularyTalk,
  grammarTalk,
  dailyEnglish,
  storyTalk,
  mannersTalk,
  speakingChallenge,
  reviewTalk;

  String get displayName {
    switch (this) {
      case AiMode.vocabularyTalk:
        return 'Vocabulary Talk 🗣️';
      case AiMode.grammarTalk:
        return 'Grammar Talk ✍️';
      case AiMode.dailyEnglish:
        return 'Daily English ☀️';
      case AiMode.storyTalk:
        return 'Story Talk 📖';
      case AiMode.mannersTalk:
        return 'Manners Talk 🤲';
      case AiMode.speakingChallenge:
        return 'Speaking Challenge 🎙️';
      case AiMode.reviewTalk:
        return 'Review Practice 🧠';
    }
  }

  String get description {
    switch (this) {
      case AiMode.vocabularyTalk:
        return 'Practice target words in simple, fun sentences.';
      case AiMode.grammarTalk:
        return 'Explore singular, plural, and sentence structures.';
      case AiMode.dailyEnglish:
        return 'Casual cheerful check-ins about day, feelings, and nature.';
      case AiMode.storyTalk:
        return 'Discuss characters, events, and lessons from our stories.';
      case AiMode.mannersTalk:
        return 'Reflect on kindness, cleanliness, sharing, and gratitude.';
      case AiMode.speakingChallenge:
        return 'Speak aloud complete sentences and earn bonus stars!';
      case AiMode.reviewTalk:
        return 'Practice and reinforce concepts identified by the Adventure Brain.';
    }
  }
}
