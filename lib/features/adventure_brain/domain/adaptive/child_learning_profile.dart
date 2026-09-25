import 'package:equatable/equatable.dart';
import 'activity_variety_engine.dart';
import 'skill_dimension.dart';
import 'vocabulary_mastery.dart';

/// Aggregated, derived learning profile for a child explorer.
///
/// Computes a holistic snapshot of vocabulary mastery distribution,
/// individual skill strengths, and review needs directly from factual learning records.
class ChildLearningProfile extends Equatable {
  final String childId;
  final double overallMasteryScore; // 0.0 to 1.0
  final Map<VocabularyLearningState, int> stateDistribution;
  final Map<SkillDimension, SkillCompetency> skillCompetencies;
  final SkillDimension? strongestDimension;
  final SkillDimension? weakestDimension;
  final String currentWorldId;
  final int learningStreakDays;
  final int reviewDueCount;
  final List<String> strugglingVocabulary;
  final List<String> masteredVocabulary;
  final List<ActivityCategory> recentActivityCategories;
  final double recentAccuracy;
  final int totalWordsTracked;

  const ChildLearningProfile({
    required this.childId,
    required this.overallMasteryScore,
    required this.stateDistribution,
    required this.skillCompetencies,
    this.strongestDimension,
    this.weakestDimension,
    required this.currentWorldId,
    required this.learningStreakDays,
    required this.reviewDueCount,
    required this.strugglingVocabulary,
    required this.masteredVocabulary,
    required this.recentActivityCategories,
    required this.recentAccuracy,
    required this.totalWordsTracked,
  });

  /// Factory aggregating raw [VocabularyMastery] items into a unified profile.
  factory ChildLearningProfile.fromMasteries({
    required String childId,
    required List<VocabularyMastery> masteries,
    required String currentWorldId,
    required int streakDays,
    List<ActivityCategory> recentActivities = const [],
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();

    final distribution = <VocabularyLearningState, int>{
      for (final s in VocabularyLearningState.values) s: 0,
    };

    final struggling = <String>[];
    final mastered = <String>[];
    double totalScore = 0.0;
    int totalCorrect = 0;
    int totalAttempts = 0;

    for (final m in masteries) {
      distribution[m.currentLearningState] =
          (distribution[m.currentLearningState] ?? 0) + 1;
      totalScore += m.masteryScore;
      totalCorrect += m.correctAttempts;
      totalAttempts += m.totalAttempts;

      if (m.isStruggling) {
        struggling.add(m.word.isNotEmpty ? m.word : m.vocabularyId);
      }
      if (m.isMastered) {
        mastered.add(m.word.isNotEmpty ? m.word : m.vocabularyId);
      }
    }

    final avgScore = masteries.isEmpty ? 0.0 : totalScore / masteries.length;
    final accuracy = totalAttempts == 0 ? 0.0 : totalCorrect / totalAttempts;
    final dueCount = masteries.where((m) => m.isReviewDue(timestamp)).length;

    // Aggregate skill competencies
    final skills = <SkillDimension, SkillCompetency>{};
    for (final dim in SkillDimension.values) {
      double dimScore = avgScore;
      if (dim == SkillDimension.listening) {
        final listeningTotal = masteries.fold<int>(
            0, (sum, m) => sum + m.listeningRecognitionSuccess);
        dimScore = (dimScore * 0.5) + (listeningTotal > 0 ? 0.4 : 0.0);
      } else if (dim == SkillDimension.pronunciation) {
        final pronunAttempts = masteries.fold<int>(
            0, (sum, m) => sum + m.pronunciationAttempts);
        final pronunSuccess = masteries.fold<int>(
            0, (sum, m) => sum + m.pronunciationSuccesses);
        dimScore = pronunAttempts == 0
            ? avgScore
            : (pronunSuccess / pronunAttempts).clamp(0.0, 1.0);
      }

      skills[dim] = SkillCompetency(
        dimension: dim,
        score: double.parse(dimScore.clamp(0.0, 1.0).toStringAsFixed(2)),
        totalInteractions: masteries.length,
        successfulInteractions: totalCorrect,
        lastAssessedAt: timestamp,
      );
    }

    // Identify strongest and weakest dimensions
    SkillDimension? strongest;
    SkillDimension? weakest;
    double maxScore = -1.0;
    double minScore = 2.0;

    for (final entry in skills.entries) {
      if (entry.value.score > maxScore) {
        maxScore = entry.value.score;
        strongest = entry.key;
      }
      if (entry.value.score < minScore) {
        minScore = entry.value.score;
        weakest = entry.key;
      }
    }

    return ChildLearningProfile(
      childId: childId,
      overallMasteryScore: double.parse(avgScore.toStringAsFixed(2)),
      stateDistribution: distribution,
      skillCompetencies: skills,
      strongestDimension: strongest,
      weakestDimension: weakest,
      currentWorldId: currentWorldId,
      learningStreakDays: streakDays,
      reviewDueCount: dueCount,
      strugglingVocabulary: struggling,
      masteredVocabulary: mastered,
      recentActivityCategories: recentActivities,
      recentAccuracy: double.parse(accuracy.toStringAsFixed(2)),
      totalWordsTracked: masteries.length,
    );
  }

  /// Formatted English summary for parent reports.
  String get parentSummary {
    return 'Mastered: ${masteredVocabulary.length} words | Due for Review: $reviewDueCount | Accuracy: ${(recentAccuracy * 100).round()}%';
  }

  @override
  List<Object?> get props => [
        childId,
        overallMasteryScore,
        stateDistribution,
        skillCompetencies,
        strongestDimension,
        weakestDimension,
        currentWorldId,
        learningStreakDays,
        reviewDueCount,
        strugglingVocabulary,
        masteredVocabulary,
        recentActivityCategories,
        recentAccuracy,
        totalWordsTracked,
      ];
}
