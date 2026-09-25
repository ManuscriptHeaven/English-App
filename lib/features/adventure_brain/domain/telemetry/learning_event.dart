import 'package:equatable/equatable.dart';

/// All typed learning event types in the Kids English Adventure learning engine.
enum LearningEventType {
  lessonStarted,
  lessonCompleted,
  vocabularyViewed,
  vocabularyAudioPlayed,
  vocabularyRepeated,
  answerCorrect,
  answerIncorrect,
  hintUsed,
  storyStarted,
  storyCompleted,
  comprehensionCorrect,
  comprehensionIncorrect,
  microphoneAttempt,
  pronunciationAttempt,
  rewardEarned,
  activityAbandoned,
}

/// A strongly-typed learning telemetry event capturing child interactions.
///
/// Designed to be decoupled from presentation widgets and analytics vendors.
class LearningEvent extends Equatable {
  final String id;
  final LearningEventType eventType;
  final String childId;
  final String worldId;
  final String lessonId;
  final String activityId;
  final String? vocabularyId;
  final DateTime timestamp;
  final int attemptNumber;
  final int responseDurationMs;
  final Map<String, dynamic> metadata;

  const LearningEvent({
    required this.id,
    required this.eventType,
    required this.childId,
    this.worldId = '',
    this.lessonId = '',
    this.activityId = '',
    this.vocabularyId,
    required this.timestamp,
    this.attemptNumber = 1,
    this.responseDurationMs = 0,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'eventType': eventType.name,
        'childId': childId,
        'worldId': worldId,
        'lessonId': lessonId,
        'activityId': activityId,
        'vocabularyId': vocabularyId,
        'timestamp': timestamp.toIso8601String(),
        'attemptNumber': attemptNumber,
        'responseDurationMs': responseDurationMs,
        'metadata': metadata,
      };

  factory LearningEvent.fromJson(Map<String, dynamic> json) => LearningEvent(
        id: json['id'] as String,
        eventType: LearningEventType.values.firstWhere(
          (e) => e.name == json['eventType'],
          orElse: () => LearningEventType.lessonStarted,
        ),
        childId: json['childId'] as String,
        worldId: json['worldId'] as String,
        lessonId: json['lessonId'] as String,
        activityId: json['activityId'] as String,
        vocabularyId: json['vocabularyId'] as String?,
        timestamp: DateTime.parse(json['timestamp'] as String),
        attemptNumber: json['attemptNumber'] as int? ?? 1,
        responseDurationMs: json['responseDurationMs'] as int? ?? 0,
        metadata: json['metadata'] != null
            ? Map<String, dynamic>.from(json['metadata'] as Map)
            : const {},
      );

  @override
  List<Object?> get props => [
        id,
        eventType,
        childId,
        worldId,
        lessonId,
        activityId,
        vocabularyId,
        timestamp,
        attemptNumber,
        responseDurationMs,
        metadata,
      ];
}
