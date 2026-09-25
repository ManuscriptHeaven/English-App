import 'package:equatable/equatable.dart';

/// Granular mastery tracking for individual vocabulary words.
class WordProgress extends Equatable {
  final String wordId;
  final int timesSeen;
  final int timesCorrect;
  final int timesIncorrect;
  final double masteryLevel; // 0.0 to 1.0
  final DateTime lastReviewed;
  final DateTime nextReviewDate;

  const WordProgress({
    required this.wordId,
    this.timesSeen = 0,
    this.timesCorrect = 0,
    this.timesIncorrect = 0,
    this.masteryLevel = 0.0,
    required this.lastReviewed,
    required this.nextReviewDate,
  });

  /// Deterministic Spaced Repetition Scheduling Rule
  static DateTime calculateNextReview(double mastery, DateTime fromDate) {
    if (mastery < 0.4) {
      return fromDate.add(const Duration(days: 1));
    } else if (mastery < 0.7) {
      return fromDate.add(const Duration(days: 3));
    } else if (mastery < 0.9) {
      return fromDate.add(const Duration(days: 7));
    } else {
      return fromDate.add(const Duration(days: 14));
    }
  }

  bool isDueForReview(DateTime currentDate) {
    return currentDate.isAfter(nextReviewDate) || currentDate.isAtSameMomentAs(nextReviewDate);
  }

  Map<String, dynamic> toJson() => {
        'wordId': wordId,
        'timesSeen': timesSeen,
        'timesCorrect': timesCorrect,
        'timesIncorrect': timesIncorrect,
        'masteryLevel': masteryLevel,
        'lastReviewed': lastReviewed.toIso8601String(),
        'nextReviewDate': nextReviewDate.toIso8601String(),
      };

  factory WordProgress.fromJson(Map<String, dynamic> json) => WordProgress(
        wordId: json['wordId'] as String,
        timesSeen: json['timesSeen'] as int? ?? 0,
        timesCorrect: json['timesCorrect'] as int? ?? 0,
        timesIncorrect: json['timesIncorrect'] as int? ?? 0,
        masteryLevel: (json['masteryLevel'] as num?)?.toDouble() ?? 0.0,
        lastReviewed: DateTime.parse(json['lastReviewed'] as String),
        nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      );

  @override
  List<Object?> get props => [
        wordId,
        timesSeen,
        timesCorrect,
        timesIncorrect,
        masteryLevel,
        lastReviewed,
        nextReviewDate,
      ];
}

/// Mastery tracking for grammar topics.
class GrammarProgress extends Equatable {
  final String grammarId;
  final int exercisesCompleted;
  final int accuracyPercentage;
  final double masteryScore;
  final DateTime lastPracticed;

  const GrammarProgress({
    required this.grammarId,
    this.exercisesCompleted = 0,
    this.accuracyPercentage = 0,
    this.masteryScore = 0.0,
    required this.lastPracticed,
  });

  Map<String, dynamic> toJson() => {
        'grammarId': grammarId,
        'exercisesCompleted': exercisesCompleted,
        'accuracyPercentage': accuracyPercentage,
        'masteryScore': masteryScore,
        'lastPracticed': lastPracticed.toIso8601String(),
      };

  factory GrammarProgress.fromJson(Map<String, dynamic> json) => GrammarProgress(
        grammarId: json['grammarId'] as String,
        exercisesCompleted: json['exercisesCompleted'] as int? ?? 0,
        accuracyPercentage: json['accuracyPercentage'] as int? ?? 0,
        masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
        lastPracticed: DateTime.parse(json['lastPracticed'] as String),
      );

  @override
  List<Object?> get props => [grammarId, exercisesCompleted, accuracyPercentage, masteryScore, lastPracticed];
}

/// Completion record for a lesson.
class LessonProgress extends Equatable {
  final String lessonId;
  final int stars;
  final int score;
  final int attempts;
  final int timeSpentSeconds;
  final bool isCompleted;
  final DateTime completedAt;

  const LessonProgress({
    required this.lessonId,
    this.stars = 0,
    this.score = 0,
    this.attempts = 1,
    this.timeSpentSeconds = 0,
    this.isCompleted = true,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'lessonId': lessonId,
        'stars': stars,
        'score': score,
        'attempts': attempts,
        'timeSpentSeconds': timeSpentSeconds,
        'isCompleted': isCompleted,
        'completedAt': completedAt.toIso8601String(),
      };

  factory LessonProgress.fromJson(Map<String, dynamic> json) => LessonProgress(
        lessonId: json['lessonId'] as String,
        stars: json['stars'] as int? ?? 0,
        score: json['score'] as int? ?? 0,
        attempts: json['attempts'] as int? ?? 1,
        timeSpentSeconds: json['timeSpentSeconds'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? true,
        completedAt: DateTime.parse(json['completedAt'] as String),
      );

  @override
  List<Object?> get props => [
        lessonId,
        stars,
        score,
        attempts,
        timeSpentSeconds,
        isCompleted,
        completedAt,
      ];
}

/// Comprehensive progress domain model for a child.
class ChildProgress extends Equatable {
  final String childId;
  final int totalLessonsCompleted;
  final int totalStoriesRead;
  final int totalGamesPlayed;
  final int totalMinutesSpent;
  final Map<String, WordProgress> wordProgressMap;
  final Map<String, GrammarProgress> grammarProgressMap;
  final Map<String, LessonProgress> lessonProgressMap;
  final List<String> practicedValuesIds;

  const ChildProgress({
    required this.childId,
    this.totalLessonsCompleted = 0,
    this.totalStoriesRead = 0,
    this.totalGamesPlayed = 0,
    this.totalMinutesSpent = 0,
    this.wordProgressMap = const {},
    this.grammarProgressMap = const {},
    this.lessonProgressMap = const {},
    this.practicedValuesIds = const [],
  });

  ChildProgress copyWith({
    String? childId,
    int? totalLessonsCompleted,
    int? totalStoriesRead,
    int? totalGamesPlayed,
    int? totalMinutesSpent,
    Map<String, WordProgress>? wordProgressMap,
    Map<String, GrammarProgress>? grammarProgressMap,
    Map<String, LessonProgress>? lessonProgressMap,
    List<String>? practicedValuesIds,
  }) {
    return ChildProgress(
      childId: childId ?? this.childId,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      totalStoriesRead: totalStoriesRead ?? this.totalStoriesRead,
      totalGamesPlayed: totalGamesPlayed ?? this.totalGamesPlayed,
      totalMinutesSpent: totalMinutesSpent ?? this.totalMinutesSpent,
      wordProgressMap: wordProgressMap ?? this.wordProgressMap,
      grammarProgressMap: grammarProgressMap ?? this.grammarProgressMap,
      lessonProgressMap: lessonProgressMap ?? this.lessonProgressMap,
      practicedValuesIds: practicedValuesIds ?? this.practicedValuesIds,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'totalLessonsCompleted': totalLessonsCompleted,
        'totalStoriesRead': totalStoriesRead,
        'totalGamesPlayed': totalGamesPlayed,
        'totalMinutesSpent': totalMinutesSpent,
        'wordProgressMap': wordProgressMap.map((k, v) => MapEntry(k, v.toJson())),
        'grammarProgressMap': grammarProgressMap.map((k, v) => MapEntry(k, v.toJson())),
        'lessonProgressMap': lessonProgressMap.map((k, v) => MapEntry(k, v.toJson())),
        'practicedValuesIds': practicedValuesIds,
      };

  factory ChildProgress.fromJson(Map<String, dynamic> json) => ChildProgress(
        childId: json['childId'] as String,
        totalLessonsCompleted: json['totalLessonsCompleted'] as int? ?? 0,
        totalStoriesRead: json['totalStoriesRead'] as int? ?? 0,
        totalGamesPlayed: json['totalGamesPlayed'] as int? ?? 0,
        totalMinutesSpent: json['totalMinutesSpent'] as int? ?? 0,
        wordProgressMap: (json['wordProgressMap'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, WordProgress.fromJson(v as Map<String, dynamic>)),
            ) ??
            const {},
        grammarProgressMap: (json['grammarProgressMap'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, GrammarProgress.fromJson(v as Map<String, dynamic>)),
            ) ??
            const {},
        lessonProgressMap: (json['lessonProgressMap'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, LessonProgress.fromJson(v as Map<String, dynamic>)),
            ) ??
            const {},
        practicedValuesIds: (json['practicedValuesIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  @override
  List<Object?> get props => [
        childId,
        totalLessonsCompleted,
        totalStoriesRead,
        totalGamesPlayed,
        totalMinutesSpent,
        wordProgressMap,
        grammarProgressMap,
        lessonProgressMap,
        practicedValuesIds,
      ];
}
