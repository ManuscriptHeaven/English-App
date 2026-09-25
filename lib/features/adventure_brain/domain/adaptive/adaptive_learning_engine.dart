import 'adaptive_decision.dart';
import 'adaptive_mastery_model.dart';

/// Pure, deterministic pedagogical decision engine for adaptive personalization.
class AdaptiveLearningEngine {
  /// Evaluates an [AdaptiveContentMastery] snapshot to prescribe the optimal learning intervention.
  static AdaptiveDecision evaluateIntervention({
    required AdaptiveContentMastery mastery,
    int? childAge,
    int sessionItemCount = 1,
  }) {
    // 1. Critical struggle: multiple consecutive errors
    if (mastery.isStruggling) {
      return AdaptiveDecision(
        action: AdaptiveAction.simplify,
        targetContentId: mastery.contentId,
        suggestedScaffoldingLevel: 3,
        suggestedDifficulty: 1,
        rationale:
            'Child has ${mastery.consecutiveErrors} consecutive errors on "${mastery.contentId}". Simplifying choices and adding strong visual cues.',
        childFriendlyExplanation:
            'Pip says: "Let\'s look closely together! I\'m here to help you! 🦜✨"',
      );
    }

    // 2. Immediate hesitation / single mistake
    if (mastery.consecutiveErrors == 1 && mastery.totalAttempts > 1) {
      return AdaptiveDecision(
        action: AdaptiveAction.giveHint,
        targetContentId: mastery.contentId,
        suggestedScaffoldingLevel: 2,
        rationale:
            'Single mistake observed on "${mastery.contentId}". Providing audio-visual hint.',
        childFriendlyExplanation:
            'Pip says: "Listen carefully to the sound! You can do it! 🎧"',
      );
    }

    // 3. High mastery achieved
    if (mastery.isMastered) {
      return AdaptiveDecision(
        action: AdaptiveAction.advance,
        targetContentId: mastery.contentId,
        suggestedScaffoldingLevel: 1,
        suggestedDifficulty: 3,
        rationale:
            'High mastery score (${mastery.masteryScore}) with ${mastery.correctAttempts} correct responses. Ready to advance.',
        childFriendlyExplanation:
            'MashaAllah! You mastered this! Let\'s unlock the next adventure! 🚀🌟',
      );
    }

    // 4. Critical weakness
    if (mastery.isWeak) {
      return AdaptiveDecision(
        action: AdaptiveAction.recommendWeakVocabulary,
        targetContentId: mastery.contentId,
        suggestedScaffoldingLevel: 2,
        suggestedDifficulty: 1,
        rationale:
            'Mastery score (${mastery.masteryScore}) is below proficient threshold (< 0.45). Prescribing targeted reinforcement.',
        childFriendlyExplanation:
            'Let\'s practice our animal friend words once more! 🐾',
      );
    }

    // 5. Developing content: consolidate with practice
    if (mastery.isDeveloping) {
      // If child has done 4+ items in this format, suggest switching activity to maintain joy
      if (sessionItemCount >= 4) {
        return AdaptiveDecision(
          action: AdaptiveAction.switchActivityType,
          targetContentId: mastery.contentId,
          suggestedScaffoldingLevel: 1,
          rationale:
              'Skill is developing (${mastery.masteryScore}), but session duration warrants switching to an interactive game to sustain joy.',
          childFriendlyExplanation:
              'Let\'s play a fun game with these words! 🎮',
        );
      }

      return AdaptiveDecision(
        action: AdaptiveAction.practiceAgain,
        targetContentId: mastery.contentId,
        suggestedScaffoldingLevel: 1,
        rationale:
            'Content is developing (${mastery.masteryScore}). Prescribing immediate reinforcement.',
        childFriendlyExplanation:
            'Great job! Let\'s try saying it one more time! 🎙️',
      );
    }

    // 6. Good proficiency: review later
    return AdaptiveDecision(
      action: AdaptiveAction.reviewLater,
      targetContentId: mastery.contentId,
      suggestedScaffoldingLevel: 1,
      rationale:
          'Content is proficient (${mastery.masteryScore}). Scheduling spaced retention review.',
      childFriendlyExplanation:
          'Awesome learning! We will review this again soon! 🧠',
    );
  }
}
