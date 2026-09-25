import 'package:equatable/equatable.dart';

/// Pedagogical interventions that Adventure Brain can prescribe for a learner.
enum AdaptiveAction {
  advance,                  // Advance to the next curriculum step
  practiceAgain,            // Immediate reinforcement with alternate format
  reviewLater,              // Schedule spaced review
  simplify,                 // Reduce cognitive load / provide stronger visual scaffolding
  giveHint,                 // Provide an audio/character prompt hint
  switchActivityType,       // Alternate to a game or picture book to sustain engagement
  recommendWeakVocabulary,  // Prescribe targeted reinforcement for struggling item
}

/// A structured pedagogical decision produced by the adaptive learning engine.
class AdaptiveDecision extends Equatable {
  final AdaptiveAction action;
  final String rationale;
  final String? targetContentId;
  final String? targetActivityId;
  final int suggestedScaffoldingLevel; // 1 (none) to 3 (heavy scaffolding)
  final int suggestedDifficulty; // 1 to 5
  final String childFriendlyExplanation;

  const AdaptiveDecision({
    required this.action,
    required this.rationale,
    this.targetContentId,
    this.targetActivityId,
    this.suggestedScaffoldingLevel = 1,
    this.suggestedDifficulty = 2,
    this.childFriendlyExplanation = "Let's explore our next adventure! 🌟",
  });

  @override
  List<Object?> get props => [
        action,
        rationale,
        targetContentId,
        targetActivityId,
        suggestedScaffoldingLevel,
        suggestedDifficulty,
        childFriendlyExplanation,
      ];
}
