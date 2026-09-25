import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';

/// Vocabulary word domain entity with phonetics, example sentences, audio, and connected values.
class VocabularyWord extends Equatable {
  final String id;
  final String word;
  final String phonetic;
  final String partOfSpeech; // 'noun', 'verb', 'adjective'
  final String definition;
  final String exampleSentence;
  final String imageUrl;
  final String? audioUrl;
  final String? slowAudioUrl;
  final ContentMetadata metadata;
  final String? connectedValueId;

  const VocabularyWord({
    required this.id,
    required this.word,
    required this.phonetic,
    required this.partOfSpeech,
    required this.definition,
    required this.exampleSentence,
    required this.imageUrl,
    this.audioUrl,
    this.slowAudioUrl,
    required this.metadata,
    this.connectedValueId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'word': word,
        'phonetic': phonetic,
        'partOfSpeech': partOfSpeech,
        'definition': definition,
        'exampleSentence': exampleSentence,
        'imageUrl': imageUrl,
        'audioUrl': audioUrl,
        'slowAudioUrl': slowAudioUrl,
        'metadata': metadata.toJson(),
        'connectedValueId': connectedValueId,
      };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
        id: json['id'] as String,
        word: json['word'] as String,
        phonetic: json['phonetic'] as String? ?? '',
        partOfSpeech: json['partOfSpeech'] as String? ?? 'noun',
        definition: json['definition'] as String? ?? '',
        exampleSentence: json['exampleSentence'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
        audioUrl: json['audioUrl'] as String?,
        slowAudioUrl: json['slowAudioUrl'] as String?,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
        connectedValueId: json['connectedValueId'] as String?,
      );

  @override
  List<Object?> get props => [
        id,
        word,
        phonetic,
        partOfSpeech,
        definition,
        exampleSentence,
        imageUrl,
        audioUrl,
        slowAudioUrl,
        metadata,
        connectedValueId,
      ];
}
