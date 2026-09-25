import 'package:equatable/equatable.dart';

/// Connection mapping between an English educational objective and an Islamic value/manner.
class ValueConnection extends Equatable {
  final String id;
  final String englishObjective; // e.g. "Present continuous: helping others"
  final String targetVocabularyTopic; // e.g. "Clean, Wash, Hands, Water"
  final String exampleSentence; // e.g. "I wash my hands with water."
  final String islamicValueId;
  final String mannerId;
  final String pedagogicalNote;

  const ValueConnection({
    required this.id,
    required this.englishObjective,
    required this.targetVocabularyTopic,
    required this.exampleSentence,
    required this.islamicValueId,
    required this.mannerId,
    required this.pedagogicalNote,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'englishObjective': englishObjective,
        'targetVocabularyTopic': targetVocabularyTopic,
        'exampleSentence': exampleSentence,
        'islamicValueId': islamicValueId,
        'mannerId': mannerId,
        'pedagogicalNote': pedagogicalNote,
      };

  factory ValueConnection.fromJson(Map<String, dynamic> json) => ValueConnection(
        id: json['id'] as String,
        englishObjective: json['englishObjective'] as String,
        targetVocabularyTopic: json['targetVocabularyTopic'] as String,
        exampleSentence: json['exampleSentence'] as String,
        islamicValueId: json['islamicValueId'] as String,
        mannerId: json['mannerId'] as String,
        pedagogicalNote: json['pedagogicalNote'] as String,
      );

  @override
  List<Object?> get props => [
        id,
        englishObjective,
        targetVocabularyTopic,
        exampleSentence,
        islamicValueId,
        mannerId,
        pedagogicalNote,
      ];
}
