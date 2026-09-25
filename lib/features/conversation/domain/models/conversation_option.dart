import 'package:equatable/equatable.dart';

/// An interactive option response choice in a conversation turn.
class ConversationOption extends Equatable {
  final String id;
  final String text;
  final bool isCorrect;
  final String feedback;
  final String? audioReference;

  const ConversationOption({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.feedback,
    this.audioReference,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isCorrect': isCorrect,
        'feedback': feedback,
        'audioReference': audioReference,
      };

  factory ConversationOption.fromJson(Map<String, dynamic> json) =>
      ConversationOption(
        id: json['id'] as String,
        text: json['text'] as String,
        isCorrect: json['isCorrect'] as bool? ?? true,
        feedback: json['feedback'] as String? ?? 'Good job!',
        audioReference: json['audioReference'] as String?,
      );

  @override
  List<Object?> get props => [id, text, isCorrect, feedback, audioReference];
}
