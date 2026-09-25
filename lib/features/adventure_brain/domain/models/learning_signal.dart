import 'package:equatable/equatable.dart';

/// Skill areas supported by the Kids English Adventure learning engine.
enum SkillType {
  vocabulary,
  grammar,
  phonics,
  listening,
  speaking,
  reading,
  writing,
  manners,
}

/// Mistake categorization for diagnostic feedback and scaffolding.
enum MistakeType {
  none,
  audioMiscomprehension,
  visualConfusion,
  grammarAgreement, // e.g. using 'are' instead of 'is'
  spellingPhonetic,
  pronunciationSimilarity,
  timeout,
  wrongCategory,
}

/// Reusable learning signal captured upon every interaction/attempt.
class LearningSignal extends Equatable {
  final String id;
  final String childId;
  final SkillType skill;
  final String contentId; // e.g. 'vocab_elephant', 'grammar_is_are'
  final String activityId; // e.g. 'activity_animal_hunt'
  final String worldId; // e.g. 'world_animal'
  final double score; // 0.0 to 1.0
  final double accuracy; // 0.0 to 1.0
  final int attempts;
  final int responseTimeMs;
  final bool completed;
  final DateTime timestamp;
  final int difficultyLevel; // 1 to 5
  final MistakeType mistakeType;

  const LearningSignal({
    required this.id,
    required this.childId,
    required this.skill,
    required this.contentId,
    required this.activityId,
    required this.worldId,
    this.score = 1.0,
    this.accuracy = 1.0,
    this.attempts = 1,
    this.responseTimeMs = 0,
    this.completed = true,
    required this.timestamp,
    this.difficultyLevel = 1,
    this.mistakeType = MistakeType.none,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'skill': skill.name,
        'contentId': contentId,
        'activityId': activityId,
        'worldId': worldId,
        'score': score,
        'accuracy': accuracy,
        'attempts': attempts,
        'responseTimeMs': responseTimeMs,
        'completed': completed,
        'timestamp': timestamp.toIso8601String(),
        'difficultyLevel': difficultyLevel,
        'mistakeType': mistakeType.name,
      };

  factory LearningSignal.fromJson(Map<String, dynamic> json) => LearningSignal(
        id: json['id'] as String,
        childId: json['childId'] as String,
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.vocabulary,
        ),
        contentId: json['contentId'] as String,
        activityId: json['activityId'] as String,
        worldId: json['worldId'] as String,
        score: (json['score'] as num?)?.toDouble() ?? 1.0,
        accuracy: (json['accuracy'] as num?)?.toDouble() ?? 1.0,
        attempts: json['attempts'] as int? ?? 1,
        responseTimeMs: json['responseTimeMs'] as int? ?? 0,
        completed: json['completed'] as bool? ?? true,
        timestamp: DateTime.parse(json['timestamp'] as String),
        difficultyLevel: json['difficultyLevel'] as int? ?? 1,
        mistakeType: MistakeType.values.firstWhere(
          (e) => e.name == json['mistakeType'],
          orElse: () => MistakeType.none,
        ),
      );

  @override
  List<Object?> get props => [
        id,
        childId,
        skill,
        contentId,
        activityId,
        worldId,
        score,
        accuracy,
        attempts,
        responseTimeMs,
        completed,
        timestamp,
        difficultyLevel,
        mistakeType,
      ];
}
