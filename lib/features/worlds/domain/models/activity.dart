import 'package:equatable/equatable.dart';
import 'content_metadata.dart';
import 'question.dart';

/// Categories of activities in a lesson.
enum ActivityType {
  flashcardDiscover,
  listenAndTap,
  sentenceBuilder,
  miniGame,
  storyComprehension,
  pronunciationLab,
  reviewQuiz,
}

/// An activity grouping interactive learning questions/tasks.
class Activity extends Equatable {
  final String id;
  final String title;
  final String description;
  final ActivityType type;
  final ContentMetadata metadata;
  final List<Question> questions;
  final int rewardXp;
  final int rewardCoins;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.metadata,
    required this.questions,
    this.rewardXp = 10,
    this.rewardCoins = 5,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type.name,
        'metadata': metadata.toJson(),
        'questions': questions.map((q) => q.toJson()).toList(),
        'rewardXp': rewardXp,
        'rewardCoins': rewardCoins,
      };

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        type: ActivityType.values.firstWhere((e) => e.name == json['type']),
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        questions: (json['questions'] as List<dynamic>)
            .map((q) => Question.fromJson(q as Map<String, dynamic>))
            .toList(),
        rewardXp: json['rewardXp'] as int? ?? 10,
        rewardCoins: json['rewardCoins'] as int? ?? 5,
      );

  @override
  List<Object?> get props => [id, title, description, type, metadata, questions, rewardXp, rewardCoins];
}
