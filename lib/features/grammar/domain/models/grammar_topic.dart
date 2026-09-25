import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';

/// Grammar rule or topic (e.g. "is vs are", "this vs that", "present continuous").
class GrammarTopic extends Equatable {
  final String id;
  final String title;
  final String ruleExplanation;
  final List<String> positiveExamples;
  final List<String> commonMistakes;
  final ContentMetadata metadata;
  final String? connectedValueTip;

  const GrammarTopic({
    required this.id,
    required this.title,
    required this.ruleExplanation,
    required this.positiveExamples,
    this.commonMistakes = const [],
    required this.metadata,
    this.connectedValueTip,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'ruleExplanation': ruleExplanation,
        'positiveExamples': positiveExamples,
        'commonMistakes': commonMistakes,
        'metadata': metadata.toJson(),
        'connectedValueTip': connectedValueTip,
      };

  factory GrammarTopic.fromJson(Map<String, dynamic> json) => GrammarTopic(
        id: json['id'] as String,
        title: json['title'] as String,
        ruleExplanation: json['ruleExplanation'] as String,
        positiveExamples: (json['positiveExamples'] as List<dynamic>).map((e) => e as String).toList(),
        commonMistakes: (json['commonMistakes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        connectedValueTip: json['connectedValueTip'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        ruleExplanation,
        positiveExamples,
        commonMistakes,
        metadata,
        connectedValueTip,
      ];
}
