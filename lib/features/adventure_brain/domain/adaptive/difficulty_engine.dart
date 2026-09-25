import 'vocabulary_mastery.dart';

/// Difficulty tiers dynamically applied across games, quizzes, and activities.
enum AdaptiveDifficultyTier {
  support,
  easy,
  standard,
  challenge,
}

extension AdaptiveDifficultyTierExtension on AdaptiveDifficultyTier {
  String get displayName {
    switch (this) {
      case AdaptiveDifficultyTier.support:
        return 'Gentle Support';
      case AdaptiveDifficultyTier.easy:
        return 'Easy Explorer';
      case AdaptiveDifficultyTier.standard:
        return 'Standard Adventure';
      case AdaptiveDifficultyTier.challenge:
        return 'Super Challenge';
    }
  }

  /// Number of choices presented in multiple-choice games (like Animal Hunt).
  int get choiceCount {
    switch (this) {
      case AdaptiveDifficultyTier.support:
        return 2;
      case AdaptiveDifficultyTier.easy:
        return 3;
      case AdaptiveDifficultyTier.standard:
        return 3;
      case AdaptiveDifficultyTier.challenge:
        return 4;
    }
  }

  /// Delay in seconds before a subtle visual hint is presented automatically.
  int get autoHintDelaySeconds {
    switch (this) {
      case AdaptiveDifficultyTier.support:
        return 4;
      case AdaptiveDifficultyTier.easy:
        return 7;
      case AdaptiveDifficultyTier.standard:
        return 12;
      case AdaptiveDifficultyTier.challenge:
        return 20;
    }
  }

  /// Positive, encouraging Pip explanation for the child (never frames help as failure).
  String get pipEncouragementMessage {
    switch (this) {
      case AdaptiveDifficultyTier.support:
        return 'Pip has a clue for you! Let\'s look together! ✨';
      case AdaptiveDifficultyTier.easy:
        return 'You\'re doing so great! Here come some fun choices! 🌟';
      case AdaptiveDifficultyTier.standard:
        return 'Ready for our next adventure? Let\'s go! 🚀';
      case AdaptiveDifficultyTier.challenge:
        return 'Wow, look at you! You\'re a star explorer! 🏆';
    }
  }
}

/// Pure domain engine determining appropriate difficulty adjustments.
class DifficultyEngine {
  const DifficultyEngine();

  /// Resolves the optimal difficulty tier based on the child's recent performance.
  AdaptiveDifficultyTier resolveDifficulty({
    required int childAge,
    required List<VocabularyMastery> recentMasteries,
    int consecutiveCorrect = 0,
    int consecutiveErrors = 0,
  }) {
    // 1. Critical struggle: immediate gentle support
    if (consecutiveErrors >= 2) {
      return AdaptiveDifficultyTier.support;
    }

    // 2. Very young toddlers (age 3-4) default to easy or support
    if (childAge <= 4) {
      if (consecutiveCorrect >= 4) {
        return AdaptiveDifficultyTier.standard;
      }
      return AdaptiveDifficultyTier.easy;
    }

    // 3. High accuracy streak with multiple mastered words enables challenge
    if (consecutiveCorrect >= 5) {
      final masteredCount =
          recentMasteries.where((m) => m.isMastered).length;
      if (masteredCount >= 3) {
        return AdaptiveDifficultyTier.challenge;
      }
      return AdaptiveDifficultyTier.standard;
    }

    // 4. Developing learners with solid momentum
    if (consecutiveCorrect >= 2) {
      return AdaptiveDifficultyTier.standard;
    }

    // 5. Default baseline
    return AdaptiveDifficultyTier.standard;
  }
}
