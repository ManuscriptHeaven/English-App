import 'package:equatable/equatable.dart';

/// Progressive learning lifecycle states for a vocabulary item.
///
/// Refuses a binary "learned / not learned" threshold.
enum VocabularyLearningState {
  newWord,
  introduced,
  learning,
  practicing,
  familiar,
  mastered,
  reviewDue,
  struggling,
}

extension VocabularyLearningStateExtension on VocabularyLearningState {
  String get displayName {
    switch (this) {
      case VocabularyLearningState.newWord:
        return 'Brand New';
      case VocabularyLearningState.introduced:
        return 'Just Met';
      case VocabularyLearningState.learning:
        return 'Learning';
      case VocabularyLearningState.practicing:
        return 'Practicing';
      case VocabularyLearningState.familiar:
        return 'Familiar Friend';
      case VocabularyLearningState.mastered:
        return 'Mastered 🌟';
      case VocabularyLearningState.reviewDue:
        return 'Ready for Review 🔄';
      case VocabularyLearningState.struggling:
        return 'Needs Gentle Care 💛';
    }
  }

  String get emoji {
    switch (this) {
      case VocabularyLearningState.newWord:
        return '🌱';
      case VocabularyLearningState.introduced:
        return '👀';
      case VocabularyLearningState.learning:
        return '📖';
      case VocabularyLearningState.practicing:
        return '🎯';
      case VocabularyLearningState.familiar:
        return '⭐';
      case VocabularyLearningState.mastered:
        return '🏆';
      case VocabularyLearningState.reviewDue:
        return '⏰';
      case VocabularyLearningState.struggling:
        return '💡';
    }
  }
}

/// Comprehensive, multi-signal mastery tracking for an individual vocabulary item.
///
/// Strictly scoped to a single child explorer ([childId]) and vocabulary ID ([vocabularyId]).
class VocabularyMastery extends Equatable {
  final String childId;
  final String vocabularyId;
  final String word;
  final int exposureCount;
  final int correctAttempts;
  final int incorrectAttempts;
  final int consecutiveCorrect;
  final int consecutiveIncorrect;
  final int hintCount;
  final int pronunciationAttempts;
  final int pronunciationSuccesses;
  final int listeningRecognitionSuccess;
  final int comprehensionSuccess;
  final DateTime lastSeenAt;
  final DateTime? lastCorrectAt;
  final DateTime? lastIncorrectAt;
  final DateTime? lastReviewedAt;
  final DateTime nextReviewAt;
  final double masteryScore; // 0.0 to 1.0 (gradual, non-simplistic)
  final double confidenceLevel; // 0.0 to 1.0
  final VocabularyLearningState currentLearningState;

  const VocabularyMastery({
    required this.childId,
    required this.vocabularyId,
    required this.word,
    this.exposureCount = 0,
    this.correctAttempts = 0,
    this.incorrectAttempts = 0,
    this.consecutiveCorrect = 0,
    this.consecutiveIncorrect = 0,
    this.hintCount = 0,
    this.pronunciationAttempts = 0,
    this.pronunciationSuccesses = 0,
    this.listeningRecognitionSuccess = 0,
    this.comprehensionSuccess = 0,
    required this.lastSeenAt,
    this.lastCorrectAt,
    this.lastIncorrectAt,
    this.lastReviewedAt,
    required this.nextReviewAt,
    this.masteryScore = 0.0,
    this.confidenceLevel = 0.5,
    this.currentLearningState = VocabularyLearningState.newWord,
  });

  /// Total recorded interactive attempts.
  int get totalAttempts => correctAttempts + incorrectAttempts;

  /// Accuracy ratio (0.0 to 1.0) with zero-division safety.
  double get accuracyRatio =>
      totalAttempts == 0 ? 0.0 : (correctAttempts / totalAttempts);

  /// True when the item has achieved the mastered benchmark.
  bool get isMastered => currentLearningState == VocabularyLearningState.mastered;

  /// True when the child has hit repeated mistakes (>= 2 consecutive incorrect).
  bool get isStruggling =>
      consecutiveIncorrect >= 2 ||
      currentLearningState == VocabularyLearningState.struggling;

  /// True when current time has surpassed the scheduled review timestamp.
  bool isReviewDue(DateTime now) =>
      now.isAfter(nextReviewAt) ||
      currentLearningState == VocabularyLearningState.reviewDue;

  /// Creates an initial unexposed record for a newly introduced vocabulary word.
  factory VocabularyMastery.initial({
    required String childId,
    required String vocabularyId,
    required String word,
    DateTime? now,
  }) {
    final timestamp = now ?? DateTime.now();
    return VocabularyMastery(
      childId: childId,
      vocabularyId: vocabularyId,
      word: word,
      exposureCount: 0,
      lastSeenAt: timestamp,
      nextReviewAt: timestamp.add(const Duration(hours: 12)),
      masteryScore: 0.0,
      confidenceLevel: 0.3,
      currentLearningState: VocabularyLearningState.newWord,
    );
  }

  VocabularyMastery copyWith({
    String? childId,
    String? vocabularyId,
    String? word,
    int? exposureCount,
    int? correctAttempts,
    int? incorrectAttempts,
    int? consecutiveCorrect,
    int? consecutiveIncorrect,
    int? hintCount,
    int? pronunciationAttempts,
    int? pronunciationSuccesses,
    int? listeningRecognitionSuccess,
    int? comprehensionSuccess,
    DateTime? lastSeenAt,
    DateTime? lastCorrectAt,
    DateTime? lastIncorrectAt,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    double? masteryScore,
    double? confidenceLevel,
    VocabularyLearningState? currentLearningState,
  }) {
    return VocabularyMastery(
      childId: childId ?? this.childId,
      vocabularyId: vocabularyId ?? this.vocabularyId,
      word: word ?? this.word,
      exposureCount: exposureCount ?? this.exposureCount,
      correctAttempts: correctAttempts ?? this.correctAttempts,
      incorrectAttempts: incorrectAttempts ?? this.incorrectAttempts,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      consecutiveIncorrect: consecutiveIncorrect ?? this.consecutiveIncorrect,
      hintCount: hintCount ?? this.hintCount,
      pronunciationAttempts:
          pronunciationAttempts ?? this.pronunciationAttempts,
      pronunciationSuccesses:
          pronunciationSuccesses ?? this.pronunciationSuccesses,
      listeningRecognitionSuccess:
          listeningRecognitionSuccess ?? this.listeningRecognitionSuccess,
      comprehensionSuccess: comprehensionSuccess ?? this.comprehensionSuccess,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      lastCorrectAt: lastCorrectAt ?? this.lastCorrectAt,
      lastIncorrectAt: lastIncorrectAt ?? this.lastIncorrectAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      masteryScore: masteryScore ?? this.masteryScore,
      confidenceLevel: confidenceLevel ?? this.confidenceLevel,
      currentLearningState: currentLearningState ?? this.currentLearningState,
    );
  }

  Map<String, dynamic> toJson() => {
        'childId': childId,
        'vocabularyId': vocabularyId,
        'word': word,
        'exposureCount': exposureCount,
        'correctAttempts': correctAttempts,
        'incorrectAttempts': incorrectAttempts,
        'consecutiveCorrect': consecutiveCorrect,
        'consecutiveIncorrect': consecutiveIncorrect,
        'hintCount': hintCount,
        'pronunciationAttempts': pronunciationAttempts,
        'pronunciationSuccesses': pronunciationSuccesses,
        'listeningRecognitionSuccess': listeningRecognitionSuccess,
        'comprehensionSuccess': comprehensionSuccess,
        'lastSeenAt': lastSeenAt.toIso8601String(),
        'lastCorrectAt': lastCorrectAt?.toIso8601String(),
        'lastIncorrectAt': lastIncorrectAt?.toIso8601String(),
        'lastReviewedAt': lastReviewedAt?.toIso8601String(),
        'nextReviewAt': nextReviewAt.toIso8601String(),
        'masteryScore': masteryScore,
        'confidenceLevel': confidenceLevel,
        'currentLearningState': currentLearningState.name,
      };

  factory VocabularyMastery.fromJson(Map<String, dynamic> json) =>
      VocabularyMastery(
        childId: json['childId'] as String,
        vocabularyId: json['vocabularyId'] as String,
        word: json['word'] as String? ?? '',
        exposureCount: json['exposureCount'] as int? ?? 0,
        correctAttempts: json['correctAttempts'] as int? ?? 0,
        incorrectAttempts: json['incorrectAttempts'] as int? ?? 0,
        consecutiveCorrect: json['consecutiveCorrect'] as int? ?? 0,
        consecutiveIncorrect: json['consecutiveIncorrect'] as int? ?? 0,
        hintCount: json['hintCount'] as int? ?? 0,
        pronunciationAttempts: json['pronunciationAttempts'] as int? ?? 0,
        pronunciationSuccesses: json['pronunciationSuccesses'] as int? ?? 0,
        listeningRecognitionSuccess:
            json['listeningRecognitionSuccess'] as int? ?? 0,
        comprehensionSuccess: json['comprehensionSuccess'] as int? ?? 0,
        lastSeenAt: DateTime.parse(
          json['lastSeenAt'] as String? ?? DateTime.now().toIso8601String(),
        ),
        lastCorrectAt: json['lastCorrectAt'] != null
            ? DateTime.tryParse(json['lastCorrectAt'] as String)
            : null,
        lastIncorrectAt: json['lastIncorrectAt'] != null
            ? DateTime.tryParse(json['lastIncorrectAt'] as String)
            : null,
        lastReviewedAt: json['lastReviewedAt'] != null
            ? DateTime.tryParse(json['lastReviewedAt'] as String)
            : null,
        nextReviewAt: DateTime.parse(
          json['nextReviewAt'] as String? ??
              DateTime.now().add(const Duration(hours: 12)).toIso8601String(),
        ),
        masteryScore: (json['masteryScore'] as num?)?.toDouble() ?? 0.0,
        confidenceLevel: (json['confidenceLevel'] as num?)?.toDouble() ?? 0.5,
        currentLearningState: VocabularyLearningState.values.firstWhere(
          (s) => s.name == json['currentLearningState'],
          orElse: () => VocabularyLearningState.newWord,
        ),
      );

  @override
  List<Object?> get props => [
        childId,
        vocabularyId,
        word,
        exposureCount,
        correctAttempts,
        incorrectAttempts,
        consecutiveCorrect,
        consecutiveIncorrect,
        hintCount,
        pronunciationAttempts,
        pronunciationSuccesses,
        listeningRecognitionSuccess,
        comprehensionSuccess,
        lastSeenAt,
        lastCorrectAt,
        lastIncorrectAt,
        lastReviewedAt,
        nextReviewAt,
        masteryScore,
        confidenceLevel,
        currentLearningState,
      ];
}
