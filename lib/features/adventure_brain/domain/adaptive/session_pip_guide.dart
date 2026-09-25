import 'session_activity.dart';
import 'learning_session.dart';

/// Provides child-safe, deterministic, encouraging dialogue lines from Pip the Companion.
class SessionPipGuide {
  const SessionPipGuide();

  /// Welcoming kick-off dialogue when starting a session.
  String getWelcomeDialogue({
    required String childName,
    required LearningSession session,
  }) {
    if (session.confidenceProtectionApplied) {
      return "Hi $childName! Pip is so happy to play with you today! Let's have fun together! 🌟";
    }
    if (session.reviewVocabularyIds.isNotEmpty && session.targetVocabularyIds.isEmpty) {
      return "Welcome back, $childName! Let's show Pip what you remember! 🐾";
    }
    if (session.targetVocabularyIds.isNotEmpty) {
      return "Ready for a new adventure, $childName? Let's explore new words! 🚀";
    }
    return "Let's explore together, $childName! Pip is by your side! ✨";
  }

  /// Transition dialogue moving into the next activity.
  String getTransitionDialogue({
    required SessionActivity nextActivity,
    required int completedIndex,
    required int totalActivities,
  }) {
    final remaining = totalActivities - completedIndex;
    final prefix = remaining == 1 ? "Last stop! " : "Great job! ";

    switch (nextActivity.activityType) {
      case SessionActivityType.warmUp:
        return "$prefix Let's warm up our ears and eyes! 🎧";
      case SessionActivityType.vocabularyDiscovery:
        return "$prefix Look! Brand new animal friends are waiting to meet you! 🐘";
      case SessionActivityType.interactiveGame:
        return "$prefix Time for a super fun game! Can you find them all? 🔍";
      case SessionActivityType.storyReader:
        return "$prefix Storytime with Pip! Let's listen to a fun tale! 📖";
      case SessionActivityType.conversationPip:
        return "$prefix Talk to Pip! Tell me what you see! 🎙️";
      case SessionActivityType.reviewChallenge:
        return "$prefix Let's do a quick lightning challenge! You've got this! ⚡";
      case SessionActivityType.celebration:
        return "$prefix Woohoo! Time to celebrate your great work! 🎉";
    }
  }

  /// Calming/encouraging dialogue if child encounters difficulty.
  String getEncouragementDialogue({required String childName}) {
    return "Don't worry, $childName! Learning takes practice, and Pip is right here with you! 💛";
  }

  /// Resume dialogue when continuing a previously paused session.
  String getResumeDialogue({required String childName}) {
    return "Welcome back, $childName! Pip kept our adventure safe. Let's keep exploring! 🎒";
  }

  /// Celebration dialogue when finishing the entire session.
  String getCompletionDialogue({
    required String childName,
    required int starsEarned,
  }) {
    if (starsEarned >= 3) {
      return "INCREDIBLE, $childName! You earned 3 shiny stars! You're a true English explorer! ⭐⭐⭐";
    }
    return "Hooray, $childName! You finished today's mission! Pip is so proud of you! 🐾✨";
  }
}
