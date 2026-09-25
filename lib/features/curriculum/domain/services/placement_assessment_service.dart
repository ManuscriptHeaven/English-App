import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import '../models/learning_age_band.dart';
import '../models/placement_assessment.dart';

/// Single interactive response in the informal diagnostic journey with Pip.
class PlacementObservation extends Equatable {
  final String taskId;
  final int stageLevel; // 1 = word, 2 = phrase, 3 = sentence / dialogue
  final SkillDimension dimension;
  final bool isCorrect;
  final double responseTimeSeconds;
  final bool usedAudioClue;
  final bool expressedConfidence; // whether child answered decisively

  const PlacementObservation({
    required this.taskId,
    required this.stageLevel,
    required this.dimension,
    required this.isCorrect,
    this.responseTimeSeconds = 2.0,
    this.usedAudioClue = false,
    this.expressedConfidence = true,
  });

  @override
  List<Object?> get props => [
        taskId,
        stageLevel,
        dimension,
        isCorrect,
        responseTimeSeconds,
        usedAudioClue,
        expressedConfidence,
      ];
}

/// Evaluates child responses during an informal, playful placement exploration
/// to recommend initial curriculum entry across Levels 1, 2, and 3.
/// Strictly non-punitive and never framed as a test to the child.
class PlacementAssessmentService {
  const PlacementAssessmentService();

  /// Evaluates diagnostic observations and returns a comprehensive [PlacementResult].
  PlacementResult evaluatePlacement({
    required String childId,
    required int childAge,
    required List<PlacementObservation> observations,
  }) {
    final ageBand = LearningAgeBand.fromAge(childAge);

    if (observations.isEmpty) {
      return PlacementResult(
        childId: childId,
        recommendedLevelId: 'level_1_first_words',
        recommendedLevelOrder: 1,
        recommendedStartingWorldId: 'world_family',
        assignedAgeBand: ageBand,
        overallConfidence: 0.50,
        pedagogicalReasoning: 'No diagnostic interactions recorded. Starting gently at Level 1: First Words.',
        uncertainConceptAreas: const ['foundational_vocabulary'],
        assessedAt: DateTime.now(),
      );
    }

    // Tally by stage level
    int l1Attempts = 0, l1Successes = 0;
    int l2Attempts = 0, l2Successes = 0;
    int l3Attempts = 0, l3Successes = 0;

    final dimensionAttempts = <SkillDimension, int>{};
    final dimensionSuccesses = <SkillDimension, int>{};

    for (final obs in observations) {
      dimensionAttempts[obs.dimension] = (dimensionAttempts[obs.dimension] ?? 0) + 1;
      if (obs.isCorrect) {
        dimensionSuccesses[obs.dimension] = (dimensionSuccesses[obs.dimension] ?? 0) + 1;
      }

      if (obs.stageLevel == 1) {
        l1Attempts++;
        if (obs.isCorrect) l1Successes++;
      } else if (obs.stageLevel == 2) {
        l2Attempts++;
        if (obs.isCorrect) l2Successes++;
      } else if (obs.stageLevel >= 3) {
        l3Attempts++;
        if (obs.isCorrect) l3Successes++;
      }
    }

    final l1Ratio = l1Attempts > 0 ? l1Successes / l1Attempts : 0.0;
    final l2Ratio = l2Attempts > 0 ? l2Successes / l2Attempts : 0.0;
    final l3Ratio = l3Attempts > 0 ? l3Successes / l3Attempts : 0.0;

    // Dimension breakdown
    final dimensionScores = <PlacementDimensionScore>[];
    final strengths = <SkillDimension>[];
    final weaknesses = <SkillDimension>[];

    for (final dim in dimensionAttempts.keys) {
      final total = dimensionAttempts[dim]!;
      final correct = dimensionSuccesses[dim] ?? 0;
      final score = total > 0 ? correct / total : 0.0;
      final competent = score >= 0.70;

      dimensionScores.add(
        PlacementDimensionScore(
          dimension: dim,
          score: score,
          totalAttempts: total,
          demonstratedCompetence: competent,
        ),
      );

      if (competent) {
        strengths.add(dim);
      } else {
        weaknesses.add(dim);
      }
    }

    // Determine recommended level & uncertainty
    String recommendedLevelId;
    int recommendedLevelOrder;
    String startingWorldId;
    String reasoning;
    final uncertainAreas = <String>[];
    double confidence = 0.85;

    // Fast heuristic
    if (l3Attempts > 0 && l3Ratio >= 0.75 && l2Ratio >= 0.70 && l1Ratio >= 0.75) {
      // Demonstrated sentence capability
      recommendedLevelId = 'level_3_first_sentences';
      recommendedLevelOrder = 3;
      startingWorldId = 'world_food';
      reasoning = 'Child demonstrated comfortable sentence comprehension and phrase knowledge. Placed into Level 3: First Sentences.';
    } else if (l1Ratio >= 0.70 && (l2Ratio >= 0.60 || l2Attempts == 0)) {
      // Demonstrated solid single-word foundation, ready for word combination
      recommendedLevelId = 'level_2_first_phrases';
      recommendedLevelOrder = 2;
      startingWorldId = 'world_animal';
      reasoning = 'Child recognizes foundational everyday words and is ready to combine them into short phrases in Level 2.';
    } else {
      // Starting from first words
      recommendedLevelId = 'level_1_first_words';
      recommendedLevelOrder = 1;
      startingWorldId = 'world_family';
      reasoning = 'Child is beginning their English journey. Starting comfortably with Level 1: First Words.';
    }

    // Uncertainty detection
    // e.g. High latency or lucky guess where l3 is high but l1 was weak
    if (l3Ratio > 0.80 && l1Ratio < 0.50) {
      confidence = 0.55;
      uncertainAreas.add('inconsistent_mastery_profile');
      reasoning += ' (Flagged for early confirmation review due to uneven response consistency).';
    }

    final anyHesitation = observations.any((o) => o.responseTimeSeconds > 5.0 && !o.expressedConfidence);
    if (anyHesitation) {
      confidence = (confidence - 0.15).clamp(0.40, 1.0);
      uncertainAreas.add('response_latency_hesitation');
    }

    return PlacementResult(
      childId: childId,
      recommendedLevelId: recommendedLevelId,
      recommendedLevelOrder: recommendedLevelOrder,
      recommendedStartingWorldId: startingWorldId,
      assignedAgeBand: ageBand,
      skillStrengths: strengths,
      skillWeaknesses: weaknesses,
      overallConfidence: confidence,
      pedagogicalReasoning: reasoning,
      uncertainConceptAreas: uncertainAreas,
      dimensionScores: dimensionScores,
      assessedAt: DateTime.now(),
    );
  }
}
