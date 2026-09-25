import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'ai_mode.dart';

/// Reason why an AI conversation session completed.
enum AiSessionCompletionReason {
  objectiveMet,
  turnBudgetReached,
  timeBudgetReached,
  disengaged,
  userEnded,
  timeout,
  safetyRedirected;
}

/// Bounded session container tracking educational AI practice lifecycle.
class AiConversationSession extends Equatable {
  final String id;
  final String childId;
  final String worldId;
  final String lessonId;
  final AiMode mode;
  final String objective;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int turnCount;
  final int spokenTurns;
  final int successfulTurns;
  final int fallbackTurns;
  final List<String> targetVocabulary;
  final String? targetGrammar;
  final String? targetValue;
  final List<LearningSignal> learningSignals;
  final double score; // 0.0 to 1.0
  final bool completed;
  final SkillType skill;
  final String? valueId;
  final String providerName;
  final bool fallbackUsed;
  final double averageAccuracy;
  final AiSessionCompletionReason? completionReason;

  const AiConversationSession({
    required this.id,
    required this.childId,
    required this.worldId,
    required this.lessonId,
    required this.mode,
    required this.objective,
    required this.startedAt,
    this.endedAt,
    this.turnCount = 0,
    this.spokenTurns = 0,
    this.successfulTurns = 0,
    this.fallbackTurns = 0,
    this.targetVocabulary = const [],
    this.targetGrammar,
    this.targetValue,
    this.learningSignals = const [],
    this.score = 1.0,
    this.completed = false,
    required this.skill,
    this.valueId,
    this.providerName = 'mock_ai_provider',
    this.fallbackUsed = false,
    this.averageAccuracy = 1.0,
    this.completionReason,
  });

  AiConversationSession copyWith({
    DateTime? endedAt,
    int? turnCount,
    int? spokenTurns,
    int? successfulTurns,
    int? fallbackTurns,
    List<String>? targetVocabulary,
    String? targetGrammar,
    String? targetValue,
    List<LearningSignal>? learningSignals,
    double? score,
    bool? completed,
    bool? fallbackUsed,
    double? averageAccuracy,
    AiSessionCompletionReason? completionReason,
  }) {
    return AiConversationSession(
      id: id,
      childId: childId,
      worldId: worldId,
      lessonId: lessonId,
      mode: mode,
      objective: objective,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      turnCount: turnCount ?? this.turnCount,
      spokenTurns: spokenTurns ?? this.spokenTurns,
      successfulTurns: successfulTurns ?? this.successfulTurns,
      fallbackTurns: fallbackTurns ?? this.fallbackTurns,
      targetVocabulary: targetVocabulary ?? this.targetVocabulary,
      targetGrammar: targetGrammar ?? this.targetGrammar,
      targetValue: targetValue ?? this.targetValue,
      learningSignals: learningSignals ?? this.learningSignals,
      score: score ?? this.score,
      completed: completed ?? this.completed,
      skill: skill,
      valueId: valueId,
      providerName: providerName,
      fallbackUsed: fallbackUsed ?? this.fallbackUsed,
      averageAccuracy: averageAccuracy ?? this.averageAccuracy,
      completionReason: completionReason ?? this.completionReason,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'childId': childId,
        'worldId': worldId,
        'lessonId': lessonId,
        'mode': mode.name,
        'objective': objective,
        'startedAt': startedAt.toIso8601String(),
        'endedAt': endedAt?.toIso8601String(),
        'turnCount': turnCount,
        'spokenTurns': spokenTurns,
        'successfulTurns': successfulTurns,
        'fallbackTurns': fallbackTurns,
        'targetVocabulary': targetVocabulary,
        'targetGrammar': targetGrammar,
        'targetValue': targetValue,
        'learningSignals': learningSignals.map((s) => s.toJson()).toList(),
        'score': score,
        'completed': completed,
        'skill': skill.name,
        'valueId': valueId,
        'providerName': providerName,
        'fallbackUsed': fallbackUsed,
        'averageAccuracy': averageAccuracy,
        'completionReason': completionReason?.name,
      };

  factory AiConversationSession.fromJson(Map<String, dynamic> json) => AiConversationSession(
        id: json['id'] as String,
        childId: json['childId'] as String,
        worldId: json['worldId'] as String,
        lessonId: json['lessonId'] as String,
        mode: AiMode.values.firstWhere(
          (e) => e.name == json['mode'],
          orElse: () => AiMode.vocabularyTalk,
        ),
        objective: json['objective'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
        turnCount: json['turnCount'] as int? ?? 0,
        spokenTurns: json['spokenTurns'] as int? ?? 0,
        successfulTurns: json['successfulTurns'] as int? ?? 0,
        fallbackTurns: json['fallbackTurns'] as int? ?? 0,
        targetVocabulary: (json['targetVocabulary'] as List<dynamic>?)?.cast<String>() ?? const [],
        targetGrammar: json['targetGrammar'] as String?,
        targetValue: json['targetValue'] as String?,
        learningSignals: (json['learningSignals'] as List<dynamic>?)
                ?.map((s) => LearningSignal.fromJson(s as Map<String, dynamic>))
                .toList() ??
            const [],
        score: (json['score'] as num?)?.toDouble() ?? 1.0,
        completed: json['completed'] as bool? ?? false,
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.speaking,
        ),
        valueId: json['valueId'] as String?,
        providerName: json['providerName'] as String? ?? 'mock_ai_provider',
        fallbackUsed: json['fallbackUsed'] as bool? ?? false,
        averageAccuracy: (json['averageAccuracy'] as num?)?.toDouble() ?? 1.0,
        completionReason: json['completionReason'] != null
            ? AiSessionCompletionReason.values.firstWhere(
                (e) => e.name == json['completionReason'],
                orElse: () => AiSessionCompletionReason.userEnded,
              )
            : null,
      );

  @override
  List<Object?> get props => [
        id,
        childId,
        worldId,
        lessonId,
        mode,
        objective,
        startedAt,
        endedAt,
        turnCount,
        spokenTurns,
        successfulTurns,
        fallbackTurns,
        targetVocabulary,
        targetGrammar,
        targetValue,
        learningSignals,
        score,
        completed,
        skill,
        valueId,
        providerName,
        fallbackUsed,
        averageAccuracy,
        completionReason,
      ];
}
