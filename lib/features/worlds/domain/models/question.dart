import 'package:equatable/equatable.dart';

/// Interaction types for learning activities and assessments.
enum QuestionType {
  multipleChoice,
  listenAndChoose,
  pictureMatch,
  wordMatch,
  sentenceOrder,
  missingWord,
  pronunciationPractice,
  trueFalse,
}

/// An atomic question or mini-exercise inside an activity.
class Question extends Equatable {
  final String id;
  final QuestionType type;
  final String prompt;
  final String? promptAudioUrl;
  final String? promptImageUrl;
  final List<String> options;
  final List<String>? optionImages;
  final List<String>? optionAudios;
  final dynamic correctAnswer; // String or int index or List<int>
  final String? explanation;
  final String? valueTip; // e.g. "Remember to say Bismillah before eating!"

  const Question({
    required this.id,
    required this.type,
    required this.prompt,
    this.promptAudioUrl,
    this.promptImageUrl,
    required this.options,
    this.optionImages,
    this.optionAudios,
    required this.correctAnswer,
    this.explanation,
    this.valueTip,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'prompt': prompt,
        'promptAudioUrl': promptAudioUrl,
        'promptImageUrl': promptImageUrl,
        'options': options,
        'optionImages': optionImages,
        'optionAudios': optionAudios,
        'correctAnswer': correctAnswer,
        'explanation': explanation,
        'valueTip': valueTip,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        type: QuestionType.values.firstWhere((e) => e.name == json['type']),
        prompt: json['prompt'] as String,
        promptAudioUrl: json['promptAudioUrl'] as String?,
        promptImageUrl: json['promptImageUrl'] as String?,
        options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
        optionImages: (json['optionImages'] as List<dynamic>?)?.map((e) => e as String).toList(),
        optionAudios: (json['optionAudios'] as List<dynamic>?)?.map((e) => e as String).toList(),
        correctAnswer: json['correctAnswer'],
        explanation: json['explanation'] as String?,
        valueTip: json['valueTip'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        type,
        prompt,
        promptAudioUrl,
        promptImageUrl,
        options,
        optionImages,
        optionAudios,
        correctAnswer,
        explanation,
        valueTip,
      ];
}
