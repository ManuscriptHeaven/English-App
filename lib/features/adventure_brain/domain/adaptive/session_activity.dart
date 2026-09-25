import 'package:equatable/equatable.dart';

/// Activity category within an adaptive learning session progression.
enum SessionActivityType {
  warmUp,
  vocabularyDiscovery,
  interactiveGame,
  storyReader,
  conversationPip,
  reviewChallenge,
  celebration,
}

/// Adaptive scaffolding / support level provided during an activity.
enum SupportLevel {
  maximum,
  guided,
  independent,
  challenge,
}

/// Represents a single activity within an orchestrated [LearningSession].
class SessionActivity extends Equatable {
  final String activityId;
  final String title;
  final String subtitle;
  final SessionActivityType activityType;
  final String worldId;
  final String unitId;
  final List<String> targetVocabularyIds;
  final int difficultyLevel; // 1 to 5
  final SupportLevel supportLevel;
  final int estimatedDurationMinutes;
  final String pedagogicalIntent;
  final String pipPrompt;
  final String routePath;
  final bool isCompleted;
  final double? score;
  final DateTime? completedAt;

  const SessionActivity({
    required this.activityId,
    required this.title,
    this.subtitle = '',
    required this.activityType,
    required this.worldId,
    this.unitId = 'unit_1',
    this.targetVocabularyIds = const [],
    this.difficultyLevel = 2,
    this.supportLevel = SupportLevel.guided,
    this.estimatedDurationMinutes = 3,
    required this.pedagogicalIntent,
    required this.pipPrompt,
    required this.routePath,
    this.isCompleted = false,
    this.score,
    this.completedAt,
  });

  SessionActivity markCompleted({double? score, DateTime? completedAt}) {
    return copyWith(
      isCompleted: true,
      score: score ?? this.score ?? 1.0,
      completedAt: completedAt ?? DateTime.now(),
    );
  }

  SessionActivity copyWith({
    String? activityId,
    String? title,
    String? subtitle,
    SessionActivityType? activityType,
    String? worldId,
    String? unitId,
    List<String>? targetVocabularyIds,
    int? difficultyLevel,
    SupportLevel? supportLevel,
    int? estimatedDurationMinutes,
    String? pedagogicalIntent,
    String? pipPrompt,
    String? routePath,
    bool? isCompleted,
    double? score,
    DateTime? completedAt,
  }) {
    return SessionActivity(
      activityId: activityId ?? this.activityId,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      activityType: activityType ?? this.activityType,
      worldId: worldId ?? this.worldId,
      unitId: unitId ?? this.unitId,
      targetVocabularyIds: targetVocabularyIds ?? this.targetVocabularyIds,
      difficultyLevel: difficultyLevel ?? this.difficultyLevel,
      supportLevel: supportLevel ?? this.supportLevel,
      estimatedDurationMinutes: estimatedDurationMinutes ?? this.estimatedDurationMinutes,
      pedagogicalIntent: pedagogicalIntent ?? this.pedagogicalIntent,
      pipPrompt: pipPrompt ?? this.pipPrompt,
      routePath: routePath ?? this.routePath,
      isCompleted: isCompleted ?? this.isCompleted,
      score: score ?? this.score,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'activityId': activityId,
        'title': title,
        'subtitle': subtitle,
        'activityType': activityType.name,
        'worldId': worldId,
        'unitId': unitId,
        'targetVocabularyIds': targetVocabularyIds,
        'difficultyLevel': difficultyLevel,
        'supportLevel': supportLevel.name,
        'estimatedDurationMinutes': estimatedDurationMinutes,
        'pedagogicalIntent': pedagogicalIntent,
        'pipPrompt': pipPrompt,
        'routePath': routePath,
        'isCompleted': isCompleted,
        'score': score,
        'completedAt': completedAt?.toIso8601String(),
      };

  factory SessionActivity.fromJson(Map<String, dynamic> json) => SessionActivity(
        activityId: json['activityId'] as String,
        title: json['title'] as String? ?? 'Adventure Activity',
        subtitle: json['subtitle'] as String? ?? '',
        activityType: SessionActivityType.values.firstWhere(
          (e) => e.name == json['activityType'],
          orElse: () => SessionActivityType.interactiveGame,
        ),
        worldId: json['worldId'] as String? ?? 'world_animal',
        unitId: json['unitId'] as String? ?? 'unit_1',
        targetVocabularyIds: (json['targetVocabularyIds'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            const [],
        difficultyLevel: json['difficultyLevel'] as int? ?? 2,
        supportLevel: SupportLevel.values.firstWhere(
          (e) => e.name == json['supportLevel'],
          orElse: () => SupportLevel.guided,
        ),
        estimatedDurationMinutes: json['estimatedDurationMinutes'] as int? ?? 3,
        pedagogicalIntent: json['pedagogicalIntent'] as String? ?? '',
        pipPrompt: json['pipPrompt'] as String? ?? "Let's explore!",
        routePath: json['routePath'] as String? ?? '/adventure',
        isCompleted: json['isCompleted'] as bool? ?? false,
        score: (json['score'] as num?)?.toDouble(),
        completedAt: json['completedAt'] != null
            ? DateTime.tryParse(json['completedAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [
        activityId,
        title,
        subtitle,
        activityType,
        worldId,
        unitId,
        targetVocabularyIds,
        difficultyLevel,
        supportLevel,
        estimatedDurationMinutes,
        pedagogicalIntent,
        pipPrompt,
        routePath,
        isCompleted,
        score,
        completedAt,
      ];
}
