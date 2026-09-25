import 'package:equatable/equatable.dart';

/// Runtime session tracking child performance in a mini-game.
class GameSession extends Equatable {
  final String sessionId;
  final String gameId;
  final String childId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int mistakes;
  final int durationSeconds;
  final int starsAwarded;
  final int xpEarned;
  final int coinsEarned;
  final bool isCompleted;
  final DateTime startedAt;

  const GameSession({
    required this.sessionId,
    required this.gameId,
    required this.childId,
    this.score = 0,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.mistakes = 0,
    this.durationSeconds = 0,
    this.starsAwarded = 0,
    this.xpEarned = 0,
    this.coinsEarned = 0,
    this.isCompleted = false,
    required this.startedAt,
  });

  GameSession copyWith({
    String? sessionId,
    String? gameId,
    String? childId,
    int? score,
    int? totalQuestions,
    int? correctAnswers,
    int? mistakes,
    int? durationSeconds,
    int? starsAwarded,
    int? xpEarned,
    int? coinsEarned,
    bool? isCompleted,
    DateTime? startedAt,
  }) {
    return GameSession(
      sessionId: sessionId ?? this.sessionId,
      gameId: gameId ?? this.gameId,
      childId: childId ?? this.childId,
      score: score ?? this.score,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      mistakes: mistakes ?? this.mistakes,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      starsAwarded: starsAwarded ?? this.starsAwarded,
      xpEarned: xpEarned ?? this.xpEarned,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      isCompleted: isCompleted ?? this.isCompleted,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'sessionId': sessionId,
        'gameId': gameId,
        'childId': childId,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'mistakes': mistakes,
        'durationSeconds': durationSeconds,
        'starsAwarded': starsAwarded,
        'xpEarned': xpEarned,
        'coinsEarned': coinsEarned,
        'isCompleted': isCompleted,
        'startedAt': startedAt.toIso8601String(),
      };

  factory GameSession.fromJson(Map<String, dynamic> json) => GameSession(
        sessionId: json['sessionId'] as String,
        gameId: json['gameId'] as String,
        childId: json['childId'] as String,
        score: json['score'] as int? ?? 0,
        totalQuestions: json['totalQuestions'] as int? ?? 0,
        correctAnswers: json['correctAnswers'] as int? ?? 0,
        mistakes: json['mistakes'] as int? ?? 0,
        durationSeconds: json['durationSeconds'] as int? ?? 0,
        starsAwarded: json['starsAwarded'] as int? ?? 0,
        xpEarned: json['xpEarned'] as int? ?? 0,
        coinsEarned: json['coinsEarned'] as int? ?? 0,
        isCompleted: json['isCompleted'] as bool? ?? false,
        startedAt: DateTime.parse(json['startedAt'] as String),
      );

  @override
  List<Object?> get props => [
        sessionId,
        gameId,
        childId,
        score,
        totalQuestions,
        correctAnswers,
        mistakes,
        durationSeconds,
        starsAwarded,
        xpEarned,
        coinsEarned,
        isCompleted,
        startedAt,
      ];
}
