import 'package:equatable/equatable.dart';

/// Comprehension question after reading a story.
class StoryQuestion extends Equatable {
  final String id;
  final String prompt;
  final List<String> options;
  final int correctOptionIndex;
  final String explanation;
  final String? characterLesson;

  const StoryQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctOptionIndex,
    required this.explanation,
    this.characterLesson,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'prompt': prompt,
        'options': options,
        'correctOptionIndex': correctOptionIndex,
        'explanation': explanation,
        'characterLesson': characterLesson,
      };

  factory StoryQuestion.fromJson(Map<String, dynamic> json) => StoryQuestion(
        id: json['id'] as String,
        prompt: json['prompt'] as String,
        options: (json['options'] as List<dynamic>).map((e) => e as String).toList(),
        correctOptionIndex: json['correctOptionIndex'] as int,
        explanation: json['explanation'] as String? ?? '',
        characterLesson: json['characterLesson'] as String?,
      );

  @override
  List<Object?> get props => [id, prompt, options, correctOptionIndex, explanation, characterLesson];
}
