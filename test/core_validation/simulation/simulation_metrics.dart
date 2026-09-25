import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

/// Records a single step in a vocabulary item's longitudinal mastery path.
class MasteryTrajectoryStep {
  final String childId;
  final String vocabularyId;
  final String word;
  final DateTime timestamp;
  final double scoreBefore;
  final double scoreAfter;
  final VocabularyLearningState stateBefore;
  final VocabularyLearningState stateAfter;
  final bool isCorrect;
  final bool usedHint;
  final String source;
  final String reason;

  const MasteryTrajectoryStep({
    required this.childId,
    required this.vocabularyId,
    required this.word,
    required this.timestamp,
    required this.scoreBefore,
    required this.scoreAfter,
    required this.stateBefore,
    required this.stateAfter,
    required this.isCorrect,
    required this.usedHint,
    required this.source,
    required this.reason,
  });

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'vocabularyId': vocabularyId,
        'word': word,
        'timestamp': timestamp.toIso8601String(),
        'scoreBefore': scoreBefore,
        'scoreAfter': scoreAfter,
        'stateBefore': stateBefore.name,
        'stateAfter': stateAfter.name,
        'isCorrect': isCorrect,
        'usedHint': usedHint,
        'source': source,
        'reason': reason,
      };

  String toCsvLine() =>
      '"$childId","$vocabularyId","$word","${timestamp.toIso8601String()}",'
      '${scoreBefore.toStringAsFixed(2)},${scoreAfter.toStringAsFixed(2)},'
      '"${stateBefore.name}","${stateAfter.name}",$isCorrect,$usedHint,"$source","$reason"';
}

/// Aggregated telemetry and analytical observations collected during a simulation run.
class SimulationMetrics {
  final String profileName;
  final int seed;
  final DateTime startTime;
  DateTime endTime;

  int totalAttempts = 0;
  int correctAttempts = 0;
  int hintsUsed = 0;
  int micFailures = 0;

  final List<MasteryTrajectoryStep> trajectorySteps = [];
  final List<Map<String, dynamic>> confidenceEvents = [];
  final List<Map<String, dynamic>> difficultyEvents = [];
  final List<String> sessionSignatures = [];
  final List<String> recommendationSignatures = [];

  final Map<String, int> difficultyTiers = {
    'support': 0,
    'easy': 0,
    'standard': 0,
    'challenge': 0,
  };

  final Map<String, int> sessionLengths = {
    'micro': 0,
    'short': 0,
    'standard': 0,
    'extended': 0,
  };

  final Map<String, int> activityTypes = {};

  int sessionsStarted = 0;
  int sessionsCompleted = 0;
  int sessionsAbandoned = 0;

  int newWordCount = 0;
  int reviewWordCount = 0;

  // Concept ID -> DateTime of first familiarity / first mastery
  final Map<String, DateTime> firstSeenAt = {};
  final Map<String, DateTime> firstFamiliarAt = {};
  final Map<String, DateTime> firstMasteredAt = {};

  SimulationMetrics({
    required this.profileName,
    required this.seed,
    required this.startTime,
  }) : endTime = startTime;

  double get accuracy => totalAttempts > 0 ? (correctAttempts / totalAttempts) : 0.0;
  double get hintRate => totalAttempts > 0 ? (hintsUsed / totalAttempts) : 0.0;
  double get newToReviewRatio => reviewWordCount > 0 ? (newWordCount / reviewWordCount) : (newWordCount.toDouble());
  int get conceptsFamiliarCount => firstFamiliarAt.length;
  int get conceptsMasteredCount => firstMasteredAt.length;

  void recordTrajectory(MasteryTrajectoryStep step) {
    trajectorySteps.add(step);
    firstSeenAt.putIfAbsent(step.vocabularyId, () => step.timestamp);

    if (step.stateAfter == VocabularyLearningState.familiar && !firstFamiliarAt.containsKey(step.vocabularyId)) {
      firstFamiliarAt[step.vocabularyId] = step.timestamp;
    }
    if (step.stateAfter == VocabularyLearningState.mastered && !firstMasteredAt.containsKey(step.vocabularyId)) {
      firstMasteredAt[step.vocabularyId] = step.timestamp;
    }
  }

  void recordConfidenceIntervention({
    required String trigger,
    required String intervention,
    required DateTime timestamp,
  }) {
    confidenceEvents.add({
      'trigger': trigger,
      'intervention': intervention,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  void recordDifficulty({
    required String tier,
    required int difficultyLevel,
    required DateTime timestamp,
  }) {
    difficultyTiers[tier] = (difficultyTiers[tier] ?? 0) + 1;
    difficultyEvents.add({
      'tier': tier,
      'level': difficultyLevel,
      'timestamp': timestamp.toIso8601String(),
    });
  }

  void recordSession({
    required String lengthCategory,
    required List<String> activityTypeNames,
    required int newWords,
    required int reviewWords,
    required bool completed,
    required bool abandoned,
  }) {
    sessionsStarted++;
    if (completed) sessionsCompleted++;
    if (abandoned) sessionsAbandoned++;

    sessionLengths[lengthCategory] = (sessionLengths[lengthCategory] ?? 0) + 1;
    newWordCount += newWords;
    reviewWordCount += reviewWords;

    for (final act in activityTypeNames) {
      activityTypes[act] = (activityTypes[act] ?? 0) + 1;
    }

    final signature = '${lengthCategory}_${activityTypeNames.join("_")}';
    sessionSignatures.add(signature);
  }

  /// Calculates loop repetitions in generated recommendations.
  Map<String, int> detectLoops(List<String> items, {int windowSize = 3}) {
    final loopCounts = <String, int>{};
    if (items.length < windowSize * 2) return loopCounts;

    for (int i = 0; i <= items.length - windowSize * 2; i++) {
      final windowA = items.sublist(i, i + windowSize).join('|');
      final windowB = items.sublist(i + windowSize, i + windowSize * 2).join('|');
      if (windowA == windowB) {
        loopCounts[windowA] = (loopCounts[windowA] ?? 0) + 1;
      }
    }
    return loopCounts;
  }

  Map<String, dynamic> toJsonSummary() {
    return {
      'profileName': profileName,
      'seed': seed,
      'durationDays': endTime.difference(startTime).inDays,
      'totalAttempts': totalAttempts,
      'correctAttempts': correctAttempts,
      'hintsUsed': hintsUsed,
      'accuracy': double.parse(accuracy.toStringAsFixed(3)),
      'hintRate': double.parse(hintRate.toStringAsFixed(3)),
      'sessionsStarted': sessionsStarted,
      'sessionsCompleted': sessionsCompleted,
      'sessionsAbandoned': sessionsAbandoned,
      'newWordsCount': newWordCount,
      'reviewWordsCount': reviewWordCount,
      'newToReviewRatio': double.parse(newToReviewRatio.toStringAsFixed(2)),
      'difficultyDistribution': difficultyTiers,
      'sessionLengthDistribution': sessionLengths,
      'activityDistribution': activityTypes,
      'confidenceInterventionsCount': confidenceEvents.length,
      'conceptsMasteredCount': firstMasteredAt.length,
      'conceptsFamiliarCount': firstFamiliarAt.length,
    };
  }

  String toTrajectoriesCsv() {
    final buffer = StringBuffer();
    buffer.writeln('childId,vocabularyId,word,timestamp,scoreBefore,scoreAfter,stateBefore,stateAfter,isCorrect,usedHint,source,reason');
    for (final s in trajectorySteps) {
      buffer.writeln(s.toCsvLine());
    }
    return buffer.toString();
  }
}
