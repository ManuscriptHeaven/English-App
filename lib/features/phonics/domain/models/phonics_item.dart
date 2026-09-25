import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';

/// Phonics phoneme / sound unit entity.
class PhonicsItem extends Equatable {
  final String id;
  final String letterOrBlend; // e.g. "sh", "ch", "a", "b"
  final String soundIpa;
  final String audioUrl;
  final List<String> sampleWords;
  final ContentMetadata metadata;

  const PhonicsItem({
    required this.id,
    required this.letterOrBlend,
    required this.soundIpa,
    required this.audioUrl,
    required this.sampleWords,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'letterOrBlend': letterOrBlend,
        'soundIpa': soundIpa,
        'audioUrl': audioUrl,
        'sampleWords': sampleWords,
        'metadata': metadata.toJson(),
      };

  factory PhonicsItem.fromJson(Map<String, dynamic> json) => PhonicsItem(
        id: json['id'] as String,
        letterOrBlend: json['letterOrBlend'] as String,
        soundIpa: json['soundIpa'] as String,
        audioUrl: json['audioUrl'] as String? ?? '',
        sampleWords: (json['sampleWords'] as List<dynamic>).map((e) => e as String).toList(),
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [id, letterOrBlend, soundIpa, audioUrl, sampleWords, metadata];
}
