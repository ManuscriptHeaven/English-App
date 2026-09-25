import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import '../models/can_do_statement.dart';
import '../models/curriculum_level.dart';
import '../models/learning_concept.dart';

/// Diagnostic assessment of a child's readiness to advance to the next curriculum level.
class LevelReadinessEvaluation extends Equatable {
  final String currentLevelId;
  final String? nextLevelId;
  final bool isReadyToAdvance;
  final double conceptCoverageRatio; // 0.0 to 1.0
  final double speakingEvidenceRatio; // 0.0 to 1.0
  final List<String> satisfiedCanDoIds;
  final List<String> pendingCanDoIds;
  final List<String> conceptsRemainingInReview;
  final String educationalReasoning;

  const LevelReadinessEvaluation({
    required this.currentLevelId,
    this.nextLevelId,
    required this.isReadyToAdvance,
    required this.conceptCoverageRatio,
    required this.speakingEvidenceRatio,
    this.satisfiedCanDoIds = const [],
    this.pendingCanDoIds = const [],
    this.conceptsRemainingInReview = const [],
    required this.educationalReasoning,
  });

  @override
  List<Object?> get props => [
        currentLevelId,
        nextLevelId,
        isReadyToAdvance,
        conceptCoverageRatio,
        speakingEvidenceRatio,
        satisfiedCanDoIds,
        pendingCanDoIds,
        conceptsRemainingInReview,
        educationalReasoning,
      ];
}

/// Evaluates curriculum level advancement based on substantive communicative competence
/// rather than raw binary lesson clicks.
///
/// NOTE ON THRESHOLDS:
/// The default thresholds (75% familiar/mastered concept coverage, 60% speaking accuracy)
/// are initial empirical baseline configurations designed to ensure pedagogical readiness
/// without blocking or frustrating young learners. They are intentionally configurable
/// and should NOT be presented as immutable or scientifically proven constants.
class CurriculumLevelProgressionEngine {
  /// Baseline concept familiarity/mastery ratio required before level promotion (default: 0.75).
  final double minimumCoverageThreshold;

  /// Baseline speaking success ratio required across pronunciation attempts (default: 0.60).
  final double minimumSpeakingRatioThreshold;

  const CurriculumLevelProgressionEngine({
    this.minimumCoverageThreshold = 0.75, // Initial baseline: 75% core concepts familiar/mastered
    this.minimumSpeakingRatioThreshold = 0.60, // Initial baseline: >= 60% of speaking attempts successful
  });

  /// Factory preset for supported/struggling profiles requiring gentler gate conditions.
  factory CurriculumLevelProgressionEngine.gentle() => const CurriculumLevelProgressionEngine(
        minimumCoverageThreshold: 0.65,
        minimumSpeakingRatioThreshold: 0.50,
      );

  /// Factory preset for advanced/fast profiles with higher communicative rigor.
  factory CurriculumLevelProgressionEngine.rigorous() => const CurriculumLevelProgressionEngine(
        minimumCoverageThreshold: 0.85,
        minimumSpeakingRatioThreshold: 0.75,
      );

  /// Evaluates whether the learner is ready to advance from [currentLevel] to the next level.
  LevelReadinessEvaluation evaluateLevelReadiness({
    required CurriculumLevel currentLevel,
    CurriculumLevel? nextLevel,
    required List<LearningConcept> levelConcepts,
    required List<VocabularyMastery> masteries,
    required List<CanDoStatement> levelCanDoStatements,
  }) {
    if (levelConcepts.isEmpty) {
      return LevelReadinessEvaluation(
        currentLevelId: currentLevel.id,
        nextLevelId: nextLevel?.id,
        isReadyToAdvance: true,
        conceptCoverageRatio: 1.0,
        speakingEvidenceRatio: 1.0,
        educationalReasoning: 'Level contains zero registered concepts. Advancement allowed.',
      );
    }

    final masteryMap = {for (final m in masteries) m.vocabularyId: m};

    // 1. Concept Coverage Evaluation (familiar or mastered)
    int familiarOrMasteredCount = 0;
    final inReviewConcepts = <String>[];

    for (final concept in levelConcepts) {
      final m = masteryMap[concept.id];
      if (m != null && (m.isMastered || m.masteryScore >= 0.70)) {
        familiarOrMasteredCount++;
      } else {
        inReviewConcepts.add(concept.id);
      }
    }

    final coverageRatio = familiarOrMasteredCount / levelConcepts.length;

    // 2. Speaking Evidence Evaluation
    int totalSpeakingAttempts = 0;
    int successfulSpeakingAttempts = 0;

    for (final concept in levelConcepts) {
      final m = masteryMap[concept.id];
      if (m != null && m.pronunciationAttempts > 0) {
        totalSpeakingAttempts += m.pronunciationAttempts;
        successfulSpeakingAttempts += m.pronunciationSuccesses;
      }
    }

    final speakingRatio = totalSpeakingAttempts > 0
        ? (successfulSpeakingAttempts / totalSpeakingAttempts)
        : (coverageRatio >= minimumCoverageThreshold ? 0.70 : 0.40); // Lenient fallback if speaking not isolated

    // 3. CanDo Statement Fulfillment
    final satisfiedCanDos = <String>[];
    final pendingCanDos = <String>[];

    for (final canDo in levelCanDoStatements) {
      // If coverage is >= 75% and speaking ratio >= 60%, can-do statement is considered satisfied
      if (coverageRatio >= minimumCoverageThreshold && speakingRatio >= minimumSpeakingRatioThreshold) {
        satisfiedCanDos.add(canDo.id);
      } else {
        pendingCanDos.add(canDo.id);
      }
    }

    // 4. Decision Synthesis (Perfection is NOT required: 75% coverage allows advancement,
    // weak concepts remain in SpacedReviewScheduler queue)
    final bool ready = coverageRatio >= minimumCoverageThreshold && speakingRatio >= minimumSpeakingRatioThreshold;

    final reasoning = ready
        ? 'Child demonstrated ${(coverageRatio * 100).toInt()}% concept competence and solid speaking confidence. '
            'Ready to unlock Level ${nextLevel?.order ?? (currentLevel.order + 1)}! '
            '(${inReviewConcepts.length} concepts will gently continue in spaced review).'
        : 'Needs further practice in current level: ${(coverageRatio * 100).toInt()}% concept coverage '
            '(target: ${(minimumCoverageThreshold * 100).toInt()}%) or speaking evidence needs reinforcement.';

    return LevelReadinessEvaluation(
      currentLevelId: currentLevel.id,
      nextLevelId: nextLevel?.id,
      isReadyToAdvance: ready,
      conceptCoverageRatio: coverageRatio,
      speakingEvidenceRatio: speakingRatio,
      satisfiedCanDoIds: satisfiedCanDos,
      pendingCanDoIds: pendingCanDos,
      conceptsRemainingInReview: inReviewConcepts,
      educationalReasoning: reasoning,
    );
  }
}
