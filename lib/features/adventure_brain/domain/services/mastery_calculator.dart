import 'package:kids_english_adventure/features/rewards/domain/models/child_progress.dart';
import '../models/content_mastery.dart';
import '../models/learning_signal.dart';
import '../models/skill_mastery.dart';

/// Pure, deterministic algorithm for content-level and skill-level mastery.
class MasteryCalculator {
  /// Computes updated ContentMastery based on a new LearningSignal.
  static ContentMastery updateContentMastery({
    ContentMastery? currentMastery,
    required LearningSignal signal,
    required DateTime now,
  }) {
    final prevScore = currentMastery?.masteryScore ?? 0.0;
    final prevConfidence = currentMastery?.confidence ?? 0.5;
    final prevAttempts = currentMastery?.attemptCount ?? 0;
    final prevCorrect = currentMastery?.correctCount ?? 0;
    final prevIncorrect = currentMastery?.incorrectCount ?? 0;

    final isCorrect = signal.score >= 0.70;
    double delta;

    if (isCorrect) {
      if (signal.attempts == 1) {
        // High quality first attempt success
        delta = 0.12 * prevConfidence;
      } else {
        // Correct after retries
        delta = 0.06 * prevConfidence;
      }

      // Bonus for repeated success
      if (prevCorrect > 2) {
        delta += 0.05;
      }
    } else {
      // Penalty proportional to attempts/errors
      delta = -0.10 * (signal.attempts > 1 ? 1.2 : 1.0);
    }

    final newScore = (prevScore + delta).clamp(0.0, 1.0);

    // Confidence increases with cumulative attempts, up to 1.0
    final newConfidence = (prevConfidence + 0.08).clamp(0.2, 1.0);

    final nextReviewDate = WordProgress.calculateNextReview(newScore, now);

    return ContentMastery(
      contentId: signal.contentId,
      skill: signal.skill,
      masteryScore: double.parse(newScore.toStringAsFixed(2)),
      confidence: double.parse(newConfidence.toStringAsFixed(2)),
      attemptCount: prevAttempts + 1,
      correctCount: isCorrect ? prevCorrect + 1 : prevCorrect,
      incorrectCount: isCorrect ? prevIncorrect : prevIncorrect + 1,
      lastAttemptAt: now,
      lastCorrectAt: isCorrect ? now : currentMastery?.lastCorrectAt,
      nextReviewAt: nextReviewDate,
      currentDifficultyLevel: signal.difficultyLevel,
    );
  }

  /// Applies spaced repetition decay to a ContentMastery if overdue.
  static ContentMastery applyTimeDecay({
    required ContentMastery mastery,
    required DateTime currentDate,
  }) {
    if (!mastery.isDueForReview(currentDate)) {
      return mastery;
    }

    final daysOverdue = currentDate.difference(mastery.nextReviewAt).inDays;
    if (daysOverdue <= 0) return mastery;

    // Gradual confidence decay (not immediate catastrophic forgetting)
    final confidencePenalty = (daysOverdue * 0.03).clamp(0.0, 0.35);
    final decayedConfidence = (mastery.confidence - confidencePenalty).clamp(0.2, 1.0);

    // Minor score adjustment only if significantly overdue (> 7 days)
    double decayedScore = mastery.masteryScore;
    if (daysOverdue > 7) {
      final scorePenalty = ((daysOverdue - 7) * 0.02).clamp(0.0, 0.20);
      decayedScore = (mastery.masteryScore - scorePenalty).clamp(0.0, 1.0);
    }

    return mastery.copyWith(
      confidence: double.parse(decayedConfidence.toStringAsFixed(2)),
      masteryScore: double.parse(decayedScore.toStringAsFixed(2)),
    );
  }

  /// Aggregates all content-level masteries into skill-level metrics.
  static Map<SkillType, SkillMastery> calculateSkillMasteries({
    required List<ContentMastery> contentMasteries,
    required DateTime now,
  }) {
    final Map<SkillType, List<ContentMastery>> grouped = {};

    for (final skill in SkillType.values) {
      grouped[skill] = [];
    }

    for (final cm in contentMasteries) {
      grouped[cm.skill]?.add(cm);
    }

    final Map<SkillType, SkillMastery> result = {};

    for (final entry in grouped.entries) {
      final skill = entry.key;
      final items = entry.value;

      if (items.isEmpty) {
        // Default baseline mastery for unpracticed skill
        result[skill] = SkillMastery(
          skill: skill,
          score: 0.50,
          totalItemsTracked: 0,
          masteredItemsCount: 0,
          weakItemsCount: 0,
          lastUpdated: now,
        );
      } else {
        final totalScore = items.fold<double>(0.0, (acc, item) => acc + item.masteryScore);
        final avgScore = (totalScore / items.length).clamp(0.0, 1.0);
        final masteredCount = items.where((i) => i.isMastered).length;
        final weakCount = items.where((i) => i.isWeak).length;

        result[skill] = SkillMastery(
          skill: skill,
          score: double.parse(avgScore.toStringAsFixed(2)),
          totalItemsTracked: items.length,
          masteredItemsCount: masteredCount,
          weakItemsCount: weakCount,
          lastUpdated: now,
        );
      }
    }

    return result;
  }
}
