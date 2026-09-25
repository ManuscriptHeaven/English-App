import 'dart:math' as math;
import 'skill_dimension.dart';
import 'vocabulary_mastery.dart';

/// Configurable pedagogical parameters for the mastery scoring engine.
///
/// Keeps weights and thresholds in one place rather than scattering magic numbers.
class MasteryScoringConfig {
  final double independentRecallGain;
  final double assistedRecallGain;
  final double errorPenalty;
  final double consecutiveErrorMultiplier;
  final double hintPenaltyPerUse;
  final double listeningSuccessBonus;
  final double pronunciationSuccessBonus;
  final double comprehensionSuccessBonus;
  final double dailyDecayRate;
  final double maxTimeDecayPenalty;
  final int minIndependentRecallsForMastery;
  final double masteryThreshold;
  final double familiarThreshold;
  final double practicingThreshold;
  final double learningThreshold;
  final double? assistedErrorPenalty;
  final double? firstErrorPenalty;
  final bool applyHintPenaltyOnError;
  final int returneeGraceDaysThreshold;
  final double returneeGraceErrorDampening;

  const MasteryScoringConfig({
    this.independentRecallGain = 0.14,
    this.assistedRecallGain = 0.05,
    this.errorPenalty = 0.12,
    this.consecutiveErrorMultiplier = 1.3,
    this.hintPenaltyPerUse = 0.04,
    this.listeningSuccessBonus = 0.06,
    this.pronunciationSuccessBonus = 0.05,
    this.comprehensionSuccessBonus = 0.07,
    this.dailyDecayRate = 0.02,
    this.maxTimeDecayPenalty = 0.30,
    this.minIndependentRecallsForMastery = 5,
    this.masteryThreshold = 0.85,
    this.familiarThreshold = 0.65,
    this.practicingThreshold = 0.40,
    this.learningThreshold = 0.20,
    this.assistedErrorPenalty = 0.06,
    this.firstErrorPenalty,
    this.applyHintPenaltyOnError = false,
    this.returneeGraceDaysThreshold = 7,
    this.returneeGraceErrorDampening = 0.50,
  });

  static const MasteryScoringConfig standard = MasteryScoringConfig();
}

/// Cross-context evidence sources reflecting cognitive depth of learning interactions.
enum LearningEvidenceSource {
  passiveExposure,
  promptedRecall,
  audioRecognition,
  imageRecognition,
  unpromptedRecall,
  sentenceContext,
  storyContext,
  spokenProduction,
}

extension LearningEvidenceSourceExtension on LearningEvidenceSource {
  /// Pedagogical weighting multiplier based on interactive and contextual depth.
  double get weightMultiplier {
    switch (this) {
      case LearningEvidenceSource.passiveExposure:
        return 0.35;
      case LearningEvidenceSource.promptedRecall:
        return 0.70;
      case LearningEvidenceSource.audioRecognition:
        return 0.85;
      case LearningEvidenceSource.imageRecognition:
        return 0.90;
      case LearningEvidenceSource.unpromptedRecall:
        return 1.00;
      case LearningEvidenceSource.sentenceContext:
        return 1.10;
      case LearningEvidenceSource.storyContext:
        return 1.15;
      case LearningEvidenceSource.spokenProduction:
        return 1.25;
    }
  }
}

/// Learning evidence presented to the [MasteryEngine] when a child interacts.
class LearningEvidence {
  final String childId;
  final String vocabularyId;
  final String word;
  final bool isCorrect;
  final bool usedHint;
  final SkillDimension dimension;
  final LearningEvidenceSource source;
  final bool isIndependentRecall;
  final bool practicedPronunciation;
  final bool pronunciationAccurate;
  final bool listeningTested;
  final bool listeningSuccess;
  final bool comprehensionTested;
  final bool comprehensionSuccess;
  final int responseDurationMs;
  final DateTime timestamp;

  const LearningEvidence({
    required this.childId,
    required this.vocabularyId,
    required this.word,
    required this.isCorrect,
    this.usedHint = false,
    this.dimension = SkillDimension.vocabularyRecall,
    this.source = LearningEvidenceSource.unpromptedRecall,
    this.isIndependentRecall = false,
    this.practicedPronunciation = false,
    this.pronunciationAccurate = false,
    this.listeningTested = false,
    this.listeningSuccess = false,
    this.comprehensionTested = false,
    this.comprehensionSuccess = false,
    this.responseDurationMs = 0,
    required this.timestamp,
  });
}

/// Pure domain scoring engine for child vocabulary and skill mastery.
class MasteryEngine {
  final MasteryScoringConfig config;

  const MasteryEngine({this.config = MasteryScoringConfig.standard});

  /// Evaluates learning evidence against an existing (or fresh) [VocabularyMastery]
  /// and produces a newly calibrated [VocabularyMastery].
  VocabularyMastery recordAttempt({
    VocabularyMastery? currentMastery,
    required LearningEvidence evidence,
  }) {
    final prev = currentMastery ??
        VocabularyMastery.initial(
          childId: evidence.childId,
          vocabularyId: evidence.vocabularyId,
          word: evidence.word,
          now: evidence.timestamp,
        );

    // Apply time decay first if the word was not practiced recently
    final decayed = applyTimeDecay(mastery: prev, currentDate: evidence.timestamp);

    // 1. Update counters
    final newExposures = decayed.exposureCount + 1;
    final newCorrect = evidence.isCorrect ? decayed.correctAttempts + 1 : decayed.correctAttempts;
    final newIncorrect = evidence.isCorrect ? decayed.incorrectAttempts : decayed.incorrectAttempts + 1;
    final newStreakCorrect = evidence.isCorrect ? decayed.consecutiveCorrect + 1 : 0;
    final newStreakIncorrect = evidence.isCorrect ? 0 : decayed.consecutiveIncorrect + 1;
    final newHints = evidence.usedHint ? decayed.hintCount + 1 : decayed.hintCount;

    final newPronunAttempts = evidence.practicedPronunciation
        ? decayed.pronunciationAttempts + 1
        : decayed.pronunciationAttempts;
    final newPronunSuccess = (evidence.practicedPronunciation && evidence.pronunciationAccurate)
        ? decayed.pronunciationSuccesses + 1
        : decayed.pronunciationSuccesses;

    final newListeningSuccess = (evidence.listeningTested && evidence.listeningSuccess)
        ? decayed.listeningRecognitionSuccess + 1
        : decayed.listeningRecognitionSuccess;

    final newComprehensionSuccess = (evidence.comprehensionTested && evidence.comprehensionSuccess)
        ? decayed.comprehensionSuccess + 1
        : decayed.comprehensionSuccess;

    // 2. Compute delta
    double delta = 0.0;
    if (evidence.isCorrect) {
      if (evidence.isIndependentRecall && !evidence.usedHint) {
        // Full independent recall reward
        delta += config.independentRecallGain;
        if (newStreakCorrect >= 3) {
          delta += 0.03; // Consistency streak bonus
        }
      } else if (evidence.usedHint) {
        // Assisted success: dampened gain
        delta += config.assistedRecallGain;
      } else {
        // Standard recognition/discovery success
        delta += (config.independentRecallGain + config.assistedRecallGain) / 2;
      }

      // Bonus across activity dimensions
      if (evidence.listeningSuccess) {
        delta += config.listeningSuccessBonus;
      }
      if (evidence.pronunciationAccurate) {
        delta += config.pronunciationSuccessBonus;
      }
      if (evidence.comprehensionSuccess) {
        delta += config.comprehensionSuccessBonus;
      }

      // Weight delta by learning evidence context
      delta *= evidence.source.weightMultiplier;
    } else {
      // Mistake penalty, magnified if repeated
      double basePenalty = config.errorPenalty;
      if (evidence.usedHint && config.assistedErrorPenalty != null) {
        basePenalty = config.assistedErrorPenalty!;
      } else if (newStreakIncorrect == 1 && config.firstErrorPenalty != null) {
        basePenalty = config.firstErrorPenalty!;
      }

      // Check returnee grace: if days since last practice meets threshold
      final daysSinceLastSeen = evidence.timestamp.difference(decayed.lastSeenAt).inDays;
      final isReturneeGrace = config.returneeGraceDaysThreshold > 0 &&
          daysSinceLastSeen >= config.returneeGraceDaysThreshold &&
          decayed.exposureCount > 0;

      double penaltyMultiplier = math.min(
        3.0,
        1.0 + (newStreakIncorrect - 1) * (config.consecutiveErrorMultiplier - 1.0),
      );

      if (isReturneeGrace) {
        penaltyMultiplier = 1.0;
        basePenalty *= config.returneeGraceErrorDampening;
      }

      delta -= (basePenalty * penaltyMultiplier);
      if (evidence.usedHint && config.applyHintPenaltyOnError) {
        delta -= config.hintPenaltyPerUse;
      }
    }

    // 3. Clamped new score
    final updatedScore = (decayed.masteryScore + delta).clamp(0.0, 1.0);
    final roundedScore = double.parse(updatedScore.toStringAsFixed(2));

    // 4. Update confidence level
    double confidenceDelta = evidence.isCorrect ? 0.08 : -0.06;
    if (newStreakCorrect >= 3) confidenceDelta += 0.04;
    final updatedConfidence = (decayed.confidenceLevel + confidenceDelta).clamp(0.2, 1.0);
    final roundedConfidence = double.parse(updatedConfidence.toStringAsFixed(2));

    // 5. Determine new learning state
    final nextState = _resolveLearningState(
      currentScore: roundedScore,
      correctAttempts: newCorrect,
      consecutiveIncorrect: newStreakIncorrect,
      consecutiveCorrect: newStreakCorrect,
      hintCount: newHints,
      totalAttempts: newCorrect + newIncorrect,
      now: evidence.timestamp,
    );

    // 6. Schedule next review interval based on state and correctness
    final nextReview = _calculateNextReview(
      state: nextState,
      isCorrect: evidence.isCorrect,
      now: evidence.timestamp,
    );

    return decayed.copyWith(
      exposureCount: newExposures,
      correctAttempts: newCorrect,
      incorrectAttempts: newIncorrect,
      consecutiveCorrect: newStreakCorrect,
      consecutiveIncorrect: newStreakIncorrect,
      hintCount: newHints,
      pronunciationAttempts: newPronunAttempts,
      pronunciationSuccesses: newPronunSuccess,
      listeningRecognitionSuccess: newListeningSuccess,
      comprehensionSuccess: newComprehensionSuccess,
      lastSeenAt: evidence.timestamp,
      lastCorrectAt: evidence.isCorrect ? evidence.timestamp : decayed.lastCorrectAt,
      lastIncorrectAt: evidence.isCorrect ? decayed.lastIncorrectAt : evidence.timestamp,
      lastReviewedAt: evidence.timestamp,
      nextReviewAt: nextReview,
      masteryScore: roundedScore,
      confidenceLevel: roundedConfidence,
      currentLearningState: nextState,
    );
  }

  /// Calculates gradual time decay if the vocabulary has had a long gap since practice.
  VocabularyMastery applyTimeDecay({
    required VocabularyMastery mastery,
    required DateTime currentDate,
  }) {
    final daysSincePractice = currentDate.difference(mastery.lastSeenAt).inDays;
    if (daysSincePractice <= 2) return mastery;

    // Decay rate scales gently after 2 days of inactivity
    final inactiveDays = daysSincePractice - 2;
    final decayAmount = math.min(
      config.maxTimeDecayPenalty,
      inactiveDays * config.dailyDecayRate,
    );

    final decayedScore = (mastery.masteryScore - decayAmount).clamp(0.0, 1.0);
    final decayedConfidence = (mastery.confidenceLevel - (decayAmount * 0.5)).clamp(0.2, 1.0);

    // If review is overdue by time, mark reviewDue state
    VocabularyLearningState state = mastery.currentLearningState;
    if (currentDate.isAfter(mastery.nextReviewAt) &&
        state != VocabularyLearningState.struggling &&
        state != VocabularyLearningState.newWord) {
      state = VocabularyLearningState.reviewDue;
    }

    return mastery.copyWith(
      masteryScore: double.parse(decayedScore.toStringAsFixed(2)),
      confidenceLevel: double.parse(decayedConfidence.toStringAsFixed(2)),
      currentLearningState: state,
    );
  }

  VocabularyLearningState _resolveLearningState({
    required double currentScore,
    required int correctAttempts,
    required int consecutiveIncorrect,
    required int consecutiveCorrect,
    required int hintCount,
    required int totalAttempts,
    required DateTime now,
  }) {
    // 1. Struggle takes priority
    if (consecutiveIncorrect >= 2) {
      return VocabularyLearningState.struggling;
    }

    // 2. Mastered requires high score, multiple independent recalls, and high consistency
    final independentRecalls = math.max(0, correctAttempts - hintCount);
    if (currentScore >= config.masteryThreshold &&
        independentRecalls >= config.minIndependentRecallsForMastery &&
        consecutiveCorrect >= 2) {
      return VocabularyLearningState.mastered;
    }

    // 3. Familiar
    if (currentScore >= config.familiarThreshold && correctAttempts >= 3) {
      return VocabularyLearningState.familiar;
    }

    // 4. Practicing
    if (currentScore >= config.practicingThreshold && correctAttempts >= 2) {
      return VocabularyLearningState.practicing;
    }

    // 5. Learning
    if (currentScore >= config.learningThreshold || correctAttempts >= 1) {
      return VocabularyLearningState.learning;
    }

    // 6. Introduced
    if (totalAttempts > 0) {
      return VocabularyLearningState.introduced;
    }

    return VocabularyLearningState.newWord;
  }

  DateTime _calculateNextReview({
    required VocabularyLearningState state,
    required bool isCorrect,
    required DateTime now,
  }) {
    if (!isCorrect) {
      // Bring review forward immediately for wrong responses (4 to 8 hours)
      return now.add(const Duration(hours: 6));
    }

    switch (state) {
      case VocabularyLearningState.newWord:
      case VocabularyLearningState.introduced:
        return now.add(const Duration(hours: 12));
      case VocabularyLearningState.learning:
        return now.add(const Duration(hours: 24));
      case VocabularyLearningState.practicing:
        return now.add(const Duration(days: 2));
      case VocabularyLearningState.familiar:
        return now.add(const Duration(days: 5));
      case VocabularyLearningState.mastered:
        return now.add(const Duration(days: 14));
      case VocabularyLearningState.reviewDue:
      case VocabularyLearningState.struggling:
        return now.add(const Duration(hours: 8));
    }
  }
}
