import 'package:equatable/equatable.dart';
import 'learning_session.dart';

/// Structured post-session summary capturing child achievements and parent insights.
class LearningSessionSummary extends Equatable {
  final String sessionId;
  final String childId;
  final int completedActivitiesCount;
  final int totalActivitiesCount;
  final List<String> wordsIntroduced;
  final List<String> wordsReviewed;
  final List<String> wordsMastered;
  final double overallAccuracy;
  final int durationMinutes;
  final String encouragementNote;
  final String parentInsight;
  final int starsEarned;
  final DateTime completedAt;

  const LearningSessionSummary({
    required this.sessionId,
    required this.childId,
    required this.completedActivitiesCount,
    required this.totalActivitiesCount,
    this.wordsIntroduced = const [],
    this.wordsReviewed = const [],
    this.wordsMastered = const [],
    this.overallAccuracy = 1.0,
    required this.durationMinutes,
    required this.encouragementNote,
    required this.parentInsight,
    this.starsEarned = 3,
    required this.completedAt,
  });

  /// Generate a summary from a completed [LearningSession].
  factory LearningSessionSummary.fromSession({
    required LearningSession session,
    List<String> wordsMastered = const [],
    double overallAccuracy = 1.0,
  }) {
    final completedCount = session.completedCount;
    final totalCount = session.totalCount;
    final duration = session.actualDurationSeconds > 0
        ? (session.actualDurationSeconds / 60).ceil()
        : session.totalEstimatedMinutes;

    // Stars earned based on completion percentage & accuracy
    int stars = 1;
    if (session.progressPercentage >= 0.5) stars = 2;
    if (session.progressPercentage >= 0.8 && overallAccuracy >= 0.7) stars = 3;

    final introCount = session.targetVocabularyIds.length;
    final reviewCount = session.reviewVocabularyIds.length;

    final encouragement = completedCount == totalCount
        ? 'Superstar explorer! You completed all adventures today! ⭐'
        : 'Great exploration! Every step makes you stronger! 🐾';

    final insight = StringBuffer('Practiced ')
      ..write('$completedCount of $totalCount activities. ');
    if (introCount > 0) {
      insight.write('Explored $introCount new concepts. ');
    }
    if (reviewCount > 0) {
      insight.write('Reinforced $reviewCount previously learned words. ');
    }
    if (session.confidenceProtectionApplied) {
      insight.write('Confidence support was active to maintain joyful momentum.');
    } else {
      insight.write('Demonstrated strong independence and engagement.');
    }

    return LearningSessionSummary(
      sessionId: session.sessionId,
      childId: session.childId,
      completedActivitiesCount: completedCount,
      totalActivitiesCount: totalCount,
      wordsIntroduced: session.targetVocabularyIds,
      wordsReviewed: session.reviewVocabularyIds,
      wordsMastered: wordsMastered,
      overallAccuracy: overallAccuracy,
      durationMinutes: duration,
      encouragementNote: encouragement,
      parentInsight: insight.toString().trim(),
      starsEarned: stars,
      completedAt: session.completedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'childId': childId,
        'completedActivitiesCount': completedActivitiesCount,
        'totalActivitiesCount': totalActivitiesCount,
        'wordsIntroduced': wordsIntroduced,
        'wordsReviewed': wordsReviewed,
        'wordsMastered': wordsMastered,
        'overallAccuracy': overallAccuracy,
        'durationMinutes': durationMinutes,
        'encouragementNote': encouragementNote,
        'parentInsight': parentInsight,
        'starsEarned': starsEarned,
        'completedAt': completedAt.toIso8601String(),
      };

  factory LearningSessionSummary.fromJson(Map<String, dynamic> json) => LearningSessionSummary(
        sessionId: json['sessionId'] as String,
        childId: json['childId'] as String,
        completedActivitiesCount: json['completedActivitiesCount'] as int? ?? 0,
        totalActivitiesCount: json['totalActivitiesCount'] as int? ?? 0,
        wordsIntroduced: (json['wordsIntroduced'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        wordsReviewed: (json['wordsReviewed'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        wordsMastered: (json['wordsMastered'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        overallAccuracy: (json['overallAccuracy'] as num?)?.toDouble() ?? 1.0,
        durationMinutes: json['durationMinutes'] as int? ?? 5,
        encouragementNote: json['encouragementNote'] as String? ?? 'Great job!',
        parentInsight: json['parentInsight'] as String? ?? '',
        starsEarned: json['starsEarned'] as int? ?? 3,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  @override
  List<Object?> get props => [
        sessionId,
        childId,
        completedActivitiesCount,
        totalActivitiesCount,
        wordsIntroduced,
        wordsReviewed,
        wordsMastered,
        overallAccuracy,
        durationMinutes,
        encouragementNote,
        parentInsight,
        starsEarned,
        completedAt,
      ];
}
