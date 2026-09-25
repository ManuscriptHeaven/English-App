import 'package:equatable/equatable.dart';
import 'character_expression.dart';
import 'conversation_option.dart';

enum SpeakerRole {
  character,
  child,
}

/// Represents an individual exchange turn in a conversation.
class ConversationTurn extends Equatable {
  final int turnIndex;
  final String speakerName;
  final String speakerEmoji;
  final CharacterExpression expression;
  final String promptText;
  final String? audioReference;
  final String expectedResponse;
  final List<ConversationOption> options;
  final String? scaffoldingHint;
  final int? nextTurnIndex;

  const ConversationTurn({
    required this.turnIndex,
    required this.speakerName,
    required this.speakerEmoji,
    this.expression = CharacterExpression.happy,
    required this.promptText,
    this.audioReference,
    required this.expectedResponse,
    this.options = const [],
    this.scaffoldingHint,
    this.nextTurnIndex,
  });

  Map<String, dynamic> toJson() => {
        'turnIndex': turnIndex,
        'speakerName': speakerName,
        'speakerEmoji': speakerEmoji,
        'expression': expression.name,
        'promptText': promptText,
        'audioReference': audioReference,
        'expectedResponse': expectedResponse,
        'options': options.map((o) => o.toJson()).toList(),
        'scaffoldingHint': scaffoldingHint,
        'nextTurnIndex': nextTurnIndex,
      };

  factory ConversationTurn.fromJson(Map<String, dynamic> json) =>
      ConversationTurn(
        turnIndex: json['turnIndex'] as int? ?? 0,
        speakerName: json['speakerName'] as String? ?? 'Pip',
        speakerEmoji: json['speakerEmoji'] as String? ?? '🦜',
        expression: CharacterExpression.values.firstWhere(
          (e) => e.name == json['expression'],
          orElse: () => CharacterExpression.happy,
        ),
        promptText: json['promptText'] as String,
        audioReference: json['audioReference'] as String?,
        expectedResponse: json['expectedResponse'] as String? ?? '',
        options: (json['options'] as List<dynamic>?)
                ?.map((e) =>
                    ConversationOption.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        scaffoldingHint: json['scaffoldingHint'] as String?,
        nextTurnIndex: json['nextTurnIndex'] as int?,
      );

  @override
  List<Object?> get props => [
        turnIndex,
        speakerName,
        speakerEmoji,
        expression,
        promptText,
        audioReference,
        expectedResponse,
        options,
        scaffoldingHint,
        nextTurnIndex,
      ];
}
