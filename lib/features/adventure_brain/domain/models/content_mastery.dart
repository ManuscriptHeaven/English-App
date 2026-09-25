import 'package:equatable/equatable.dart';
import 'learning_signal.dart';

/// Granular mastery model for a specific content unit (e.g. 'vocab_elephant', 'grammar_is_are').
class ContentMastery extends Equatable {
  final String contentId;
  final SkillType skill;
  final double masteryScore; // 0.0 to 1.0
  final double confidence; // 0.0 to 1.0
  final int attemptCount;
  final int correctCount;
  final int incorrectCount;
  final DateTime lastAttemptAt;
  final DateTime? lastCorrectAt;
  final DateTime nextReviewAt;
  final int currentDifficultyLevel; // 1 to 5

  const ContentMastery({
    required this.contentId,
    required this.skill,
    this.masteryScore = 0.0,
    this.confidence = 0.5,
    this.attemptCount = 0,
    this.correctCount = 0,
    this.incorrectCount = 0,
    required this.lastAttemptAt,
    this.lastCorrectAt,
    required this.nextReviewAt,
    this.currentDifficultyLevel = 1,
  });

  bool get isWeak => masteryScore < 0.45;
  bool get isProficient => masteryScore >= 0.70;
  bool get isMastered => masteryScore >= 0.90;

  bool isDueForReview(DateTime currentDate) {
    return currentDate.isAfter(nextReviewAt) || currentDate.isAtSameMomentAs(nextReviewAt);
  }

  ContentMastery copyWith({
    String? contentId,
    SkillType? skill,
    double? masteryScore,
    double? confidence,
    int? attemptCount,
    int? correctCount,
    int? incorrectCount,
    DateTime? lastAttemptAt,
    DateTime? lastCorrectAt,
    DateTime? nextReviewAt,
    int? currentDifficultyLevel,
  }) {
    return ContentMastery(
      contentId: contentId ?? this.contentId,
      skill: skill ?? this.skill,
      masteryScore: masteryScore ?? this.masteryScore,
      confidence: confidence ?? this.confidence,
      attemptCount: attemptCount ?? this.attemptCount,
      correctCount: correctCount ?? this.correctCount,
      incorrectCount: incorrectCount ?? this.incorrectCount,
      lastAttemptAt: lastAttemptAt ?? this.lastAttemptAt,
      lastCorrectAt: lastCorrectAt ?? this.lastCorrectAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      currentDifficultyLevel: currentDifficultyLevel ?? this.currentDifficultyLevel,
    );
  }

  Map<String, dynamic> toJson() => {
        'contentId': contentId,
        'skill': skill.name,
        'masteryScore': masteryScore,
        'confidence': confidence,
        'attemptCount': attemptCount,
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
        'lastAttemptAt': lastAttemptAt.toIso8601String(),
        'lastCorrectAt': lastCorrectAt?.toIso8601String(),
        'nextReviewAt': nextReviewAt.toIso8601String(),
        'currentDifficultyLevel': currentDifficultyLevel,
      };

  factory ContentMastery.fromJson(Map<String, dynamic> json) => ContentMastery(
        contentId: json['contentId'] as String,
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.vocabulary,
        ),
        masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.5,
        attemptCount: json['attemptCount'] as int? ?? 0,
        correctCount: json['correctCount'] as int? ?? 0,
        incorrectCount: json['incorrectCount'] as int? ?? 0,
        lastAttemptAt: DateTime.parse(json['lastAttemptAt'] as String),
        lastCorrectAt: json['lastCorrectAt'] != null
            ? DateTime.parse(json['lastCorrectAt'] as String)
            : null,
        nextReviewAt: DateTime.parse(json['nextReviewAt'] as String),
        currentDifficultyLevel: json['currentDifficultyLevel'] as int? ?? 1,
      );

  @override
  List<Object?> get props => [
        contentId,
        skill,
        masteryScore,
        confidence,
        attemptCount,
        correctCount,
        incorrectCount,
        lastAttemptAt,
        lastCorrectAt,
        nextReviewAt,
        currentDifficultyLevel,
      ];
}
