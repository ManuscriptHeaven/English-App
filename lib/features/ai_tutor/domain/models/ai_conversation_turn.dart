import 'package:equatable/equatable.dart';

/// Speaker identity in an AI conversation turn.
enum AiSpeaker {
  child,
  character,
  system,
}

/// Validation outcome of an AI turn.
enum AiValidationStatus {
  passed,
  rejectedLength,
  rejectedSafety,
  rejectedTopic,
  rejectedIslamicHallucination,
  fallbackApplied,
}

/// Input modality for the turn.
enum AiInputType {
  speech,
  tapChoice,
  text,
}

/// Record of an individual dialogue exchange in an AI conversation.
class AiConversationTurn extends Equatable {
  final String id;
  final String sessionId;
  final AiSpeaker speaker;
  final String text;
  final DateTime timestamp;
  final AiInputType inputType;
  final AiValidationStatus validationStatus;
  final String? learningSignalId;
  final double? confidenceScore;

  const AiConversationTurn({
    required this.id,
    required this.sessionId,
    required this.speaker,
    required this.text,
    required this.timestamp,
    this.inputType = AiInputType.speech,
    this.validationStatus = AiValidationStatus.passed,
    this.learningSignalId,
    this.confidenceScore,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionId': sessionId,
        'speaker': speaker.name,
        'text': text,
        'timestamp': timestamp.toIso8601String(),
        'inputType': inputType.name,
        'validationStatus': validationStatus.name,
        'learningSignalId': learningSignalId,
        'confidenceScore': confidenceScore,
      };

  factory AiConversationTurn.fromJson(Map<String, dynamic> json) => AiConversationTurn(
        id: json['id'] as String,
        sessionId: json['sessionId'] as String,
        speaker: AiSpeaker.values.firstWhere(
          (e) => e.name == json['speaker'],
          orElse: () => AiSpeaker.character,
        ),
        text: json['text'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
        inputType: AiInputType.values.firstWhere(
          (e) => e.name == json['inputType'],
          orElse: () => AiInputType.speech,
        ),
        validationStatus: AiValidationStatus.values.firstWhere(
          (e) => e.name == json['validationStatus'],
          orElse: () => AiValidationStatus.passed,
        ),
        learningSignalId: json['learningSignalId'] as String?,
        confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      );

  @override
  List<Object?> get props => [
        id,
        sessionId,
        speaker,
        text,
        timestamp,
        inputType,
        validationStatus,
        learningSignalId,
        confidenceScore,
      ];
}
