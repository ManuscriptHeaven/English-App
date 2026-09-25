import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';

/// Good manner / Sunnah habit (e.g. saying Bismillah, eating with the right hand, greeting with Salaam).
class Manner extends Equatable {
  final String id;
  final String title;
  final String practicalHabit;
  final String childFriendlyDuasOrPhrase;
  final String englishTranslation;
  final String contextualSituation; // e.g. "Before eating", "Meeting friends", "Entering home"
  final String associatedValueId;
  final ContentMetadata metadata;

  const Manner({
    required this.id,
    required this.title,
    required this.practicalHabit,
    required this.childFriendlyDuasOrPhrase,
    required this.englishTranslation,
    required this.contextualSituation,
    required this.associatedValueId,
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'practicalHabit': practicalHabit,
        'childFriendlyDuasOrPhrase': childFriendlyDuasOrPhrase,
        'englishTranslation': englishTranslation,
        'contextualSituation': contextualSituation,
        'associatedValueId': associatedValueId,
        'metadata': metadata.toJson(),
      };

  factory Manner.fromJson(Map<String, dynamic> json) => Manner(
        id: json['id'] as String,
        title: json['title'] as String,
        practicalHabit: json['practicalHabit'] as String,
        childFriendlyDuasOrPhrase: json['childFriendlyDuasOrPhrase'] as String,
        englishTranslation: json['englishTranslation'] as String,
        contextualSituation: json['contextualSituation'] as String,
        associatedValueId: json['associatedValueId'] as String,
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        practicalHabit,
        childFriendlyDuasOrPhrase,
        englishTranslation,
        contextualSituation,
        associatedValueId,
        metadata,
      ];
}
