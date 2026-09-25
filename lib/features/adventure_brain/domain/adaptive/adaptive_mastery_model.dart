import 'dart:math' as math;
import 'package:equatable/equatable.dart';
import '../models/learning_signal.dart';

/// Multi-signal, non-simplistic mastery tracking for a child's learning journey.
///
/// Unlike a binary threshold (e.g. "3 correct = mastered"), this model evolves
/// gradually across multiple exposure types: comprehension, retention, hints,
/// consecutive errors, and pronunciation.
class AdaptiveContentMastery extends Equatable {
  final String contentId;
  final SkillType skill;
  final int correctAttempts;
  final int incorrectAttempts;
  final int consecutiveErrors;
  final int hintUsageCount;
  final int vocabularyExposureCount;
  final DateTime lastPracticedTime;
  final double comprehensionScore; // 0.0 to 1.0
  final int pronunciationAttempts;
  final int activityCompletions;
  final int averageResponseSpeedMs;
  final double masteryScore; // 0.0 to 1.0 (gradual, multi-signal)

  const AdaptiveContentMastery({
    required this.contentId,
    required this.skill,
    this.correctAttempts = 0,
    this.incorrectAttempts = 0,
    this.consecutiveErrors = 0,
    this.hintUsageCount = 0,
    this.vocabularyExposureCount = 0,
    required this.lastPracticedTime,
    this.comprehensionScore = 0.5,
    this.pronunciationAttempts = 0,
    this.activityCompletions = 0,
    this.averageResponseSpeedMs = 0,
    this.masteryScore = 0.0,
  });

  /// Total recorded interaction attempts for this content.
  int get totalAttempts => correctAttempts + incorrectAttempts;

  /// Accuracy ratio (0.0 to 1.0) with safe handling for zero attempts.
  double get accuracyRatio =>
      totalAttempts == 0 ? 0.0 : correctAttempts / totalAttempts;

  bool get isWeak => masteryScore < 0.45;
  bool get isDeveloping => masteryScore >= 0.45 && masteryScore < 0.75;
  bool get isMastered => masteryScore >= 0.85;
  bool get isStruggling => consecutiveErrors >= 3;

  /// Computes a gradual mastery score based on multiple signals.
  ///
  /// Signals integrated:
  /// - Base accuracy ratio (weight: 40%)
  /// - Practice depth / exposure log-scale (weight: 25%)
  /// - Comprehension consistency (weight: 20%)
  /// - Hint penalty & error streak dampener (-0.05 per consecutive error)
  /// - Pronunciation bonus (+5% if spoken practice attempted)
  static double computeGradualMastery({
    required int correct,
    required int incorrect,
    required int consecutiveErrors,
    required int hints,
    required int exposures,
    required double comprehension,
    required int pronunciations,
    required int completions,
  }) {
    final total = correct + incorrect;
    if (total == 0 && exposures == 0) return 0.0;

    // 1. Accuracy component (0.0 - 0.40)
    final accuracy = total > 0 ? (correct / total) : 0.0;
    final accuracyComponent = accuracy * 0.40;

    // 2. Exposure depth component (0.0 - 0.25) using diminishing returns
    // 1 exposure ~ 0.08, 3 exposures ~ 0.16, 6+ exposures ~ 0.25
    final exposureFactor = (math.log(exposures + 1) / math.log(8)).clamp(0.0, 1.0);
    final exposureComponent = exposureFactor * 0.25;

    // 3. Comprehension component (0.0 - 0.20)
    final comprehensionComponent = comprehension.clamp(0.0, 1.0) * 0.20;

    // 4. Activity completion bonus (0.0 - 0.10)
    final completionFactor = (completions / 3.0).clamp(0.0, 1.0);
    final completionComponent = completionFactor * 0.10;

    // 5. Pronunciation bonus (up to 0.05)
    final pronunciationBonus = pronunciations > 0 ? 0.05 : 0.0;

    // 6. Penalty for consecutive error streaks and excessive hints
    final errorPenalty = (consecutiveErrors * 0.04).clamp(0.0, 0.20);
    final hintPenalty = (hints * 0.02).clamp(0.0, 0.10);

    final rawScore = accuracyComponent +
        exposureComponent +
        comprehensionComponent +
        completionComponent +
        pronunciationBonus -
        errorPenalty -
        hintPenalty;

    return double.parse(rawScore.clamp(0.0, 1.0).toStringAsFixed(2));
  }

  /// Creates an updated copy of this mastery record incorporating a new attempt.
  AdaptiveContentMastery recordAttempt({
    required bool isCorrect,
    bool usedHint = false,
    bool practicedPronunciation = false,
    double? newComprehensionScore,
    bool completedActivity = false,
    int responseTimeMs = 0,
    required DateTime now,
  }) {
    final newCorrect = isCorrect ? correctAttempts + 1 : correctAttempts;
    final newIncorrect = isCorrect ? incorrectAttempts : incorrectAttempts + 1;
    final newStreakErrors = isCorrect ? 0 : consecutiveErrors + 1;
    final newHints = usedHint ? hintUsageCount + 1 : hintUsageCount;
    final newExposures = vocabularyExposureCount + 1;
    final newPronunciations = practicedPronunciation
        ? pronunciationAttempts + 1
        : pronunciationAttempts;
    final newCompletions =
        completedActivity ? activityCompletions + 1 : activityCompletions;
    final updatedComprehension = newComprehensionScore != null
        ? ((comprehensionScore * 0.7) + (newComprehensionScore * 0.3)).clamp(0.0, 1.0)
        : comprehensionScore;

    final newSpeed = averageResponseSpeedMs == 0
        ? responseTimeMs
        : ((averageResponseSpeedMs * 0.6) + (responseTimeMs * 0.4)).round();

    final newScore = computeGradualMastery(
      correct: newCorrect,
      incorrect: newIncorrect,
      consecutiveErrors: newStreakErrors,
      hints: newHints,
      exposures: newExposures,
      comprehension: updatedComprehension,
      pronunciations: newPronunciations,
      completions: newCompletions,
    );

    return copyWith(
      correctAttempts: newCorrect,
      incorrectAttempts: newIncorrect,
      consecutiveErrors: newStreakErrors,
      hintUsageCount: newHints,
      vocabularyExposureCount: newExposures,
      lastPracticedTime: now,
      comprehensionScore: double.parse(updatedComprehension.toStringAsFixed(2)),
      pronunciationAttempts: newPronunciations,
      activityCompletions: newCompletions,
      averageResponseSpeedMs: newSpeed,
      masteryScore: newScore,
    );
  }

  AdaptiveContentMastery copyWith({
    String? contentId,
    SkillType? skill,
    int? correctAttempts,
    int? incorrectAttempts,
    int? consecutiveErrors,
    int? hintUsageCount,
    int? vocabularyExposureCount,
    DateTime? lastPracticedTime,
    double? comprehensionScore,
    int? pronunciationAttempts,
    int? activityCompletions,
    int? averageResponseSpeedMs,
    double? masteryScore,
  }) {
    return AdaptiveContentMastery(
      contentId: contentId ?? this.contentId,
      skill: skill ?? this.skill,
      correctAttempts: correctAttempts ?? this.correctAttempts,
      incorrectAttempts: incorrectAttempts ?? this.incorrectAttempts,
      consecutiveErrors: consecutiveErrors ?? this.consecutiveErrors,
      hintUsageCount: hintUsageCount ?? this.hintUsageCount,
      vocabularyExposureCount:
          vocabularyExposureCount ?? this.vocabularyExposureCount,
      lastPracticedTime: lastPracticedTime ?? this.lastPracticedTime,
      comprehensionScore: comprehensionScore ?? this.comprehensionScore,
      pronunciationAttempts:
          pronunciationAttempts ?? this.pronunciationAttempts,
      activityCompletions: activityCompletions ?? this.activityCompletions,
      averageResponseSpeedMs:
          averageResponseSpeedMs ?? this.averageResponseSpeedMs,
      masteryScore: masteryScore ?? this.masteryScore,
    );
  }

  Map<String, dynamic> toJson() => {
        'contentId': contentId,
        'skill': skill.name,
        'correctAttempts': correctAttempts,
        'incorrectAttempts': incorrectAttempts,
        'consecutiveErrors': consecutiveErrors,
        'hintUsageCount': hintUsageCount,
        'vocabularyExposureCount': vocabularyExposureCount,
        'lastPracticedTime': lastPracticedTime.toIso8601String(),
        'comprehensionScore': comprehensionScore,
        'pronunciationAttempts': pronunciationAttempts,
        'activityCompletions': activityCompletions,
        'averageResponseSpeedMs': averageResponseSpeedMs,
        'masteryScore': masteryScore,
      };

  factory AdaptiveContentMastery.fromJson(Map<String, dynamic> json) =>
      AdaptiveContentMastery(
        contentId: json['contentId'] as String,
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.vocabulary,
        ),
        correctAttempts: json['correctAttempts'] as int? ?? 0,
        incorrectAttempts: json['incorrectAttempts'] as int? ?? 0,
        consecutiveErrors: json['consecutiveErrors'] as int? ?? 0,
        hintUsageCount: json['hintUsageCount'] as int? ?? 0,
        vocabularyExposureCount: json['vocabularyExposureCount'] as int? ?? 0,
        lastPracticedTime: DateTime.parse(
            json['lastPracticedTime'] as String? ?? DateTime.now().toIso8601String()),
        comprehensionScore:
            (json['comprehensionScore'] as num?)?.toDouble() ?? 0.5,
        pronunciationAttempts: json['pronunciationAttempts'] as int? ?? 0,
        activityCompletions: json['activityCompletions'] as int? ?? 0,
        averageResponseSpeedMs: json['averageResponseSpeedMs'] as int? ?? 0,
        masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
      );

  @override
  List<Object?> get props => [
        contentId,
        skill,
        correctAttempts,
        incorrectAttempts,
        consecutiveErrors,
        hintUsageCount,
        vocabularyExposureCount,
        lastPracticedTime,
        comprehensionScore,
        pronunciationAttempts,
        activityCompletions,
        averageResponseSpeedMs,
        masteryScore,
      ];
}
