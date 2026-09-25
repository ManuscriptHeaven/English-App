import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';

/// Islamic character value categories.
enum IslamicValueCategory {
  kindness,
  cleanliness,
  honesty,
  respectForParents,
  respectForTeachers,
  caringForCreation,
  gratitude,
  patience,
  generosityAndSharing,
  goodSpeech,
  responsibility,
}

/// A first-class Islamic value entity designed for positive, joyful child reinforcement.
class IslamicValue extends Equatable {
  final String id;
  final String title;
  final String arabicPhrase; // e.g. "Alhamdulillah", "Bismillah", "Rahmah"
  final String englishMeaning;
  final String childExplanation;
  final String positiveActionPrompt; // e.g. "Smile at your brother or sister today!"
  final IslamicValueCategory category;
  final String iconName;
  final String primaryColorHex;
  final String sourceType; // e.g. 'quran_principle', 'sunnah_habit', 'universal_ethic'
  final String? sourceReference; // e.g. 'Surah Luqman 31:14', 'Sahih Muslim 223'
  final String reviewStatus; // 'verified_child_safe', 'peer_reviewed'
  final ContentMetadata metadata;

  const IslamicValue({
    required this.id,
    required this.title,
    required this.arabicPhrase,
    required this.englishMeaning,
    required this.childExplanation,
    required this.positiveActionPrompt,
    required this.category,
    this.iconName = 'heart',
    this.primaryColorHex = '0xFF00897B',
    this.sourceType = 'sunnah_habit',
    this.sourceReference,
    this.reviewStatus = 'verified_child_safe',
    required this.metadata,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'arabicPhrase': arabicPhrase,
        'englishMeaning': englishMeaning,
        'childExplanation': childExplanation,
        'positiveActionPrompt': positiveActionPrompt,
        'category': category.name,
        'iconName': iconName,
        'primaryColorHex': primaryColorHex,
        'sourceType': sourceType,
        'sourceReference': sourceReference,
        'reviewStatus': reviewStatus,
        'metadata': metadata.toJson(),
      };

  factory IslamicValue.fromJson(Map<String, dynamic> json) => IslamicValue(
        id: json['id'] as String,
        title: json['title'] as String,
        arabicPhrase: json['arabicPhrase'] as String,
        englishMeaning: json['englishMeaning'] as String,
        childExplanation: json['childExplanation'] as String,
        positiveActionPrompt: json['positiveActionPrompt'] as String,
        category: IslamicValueCategory.values.firstWhere((e) => e.name == json['category']),
        iconName: json['iconName'] as String? ?? 'heart',
        primaryColorHex: json['primaryColorHex'] as String? ?? '0xFF00897B',
        sourceType: json['sourceType'] as String? ?? 'sunnah_habit',
        sourceReference: json['sourceReference'] as String?,
        reviewStatus: json['reviewStatus'] as String? ?? 'verified_child_safe',
        metadata: ContentMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        arabicPhrase,
        englishMeaning,
        childExplanation,
        positiveActionPrompt,
        category,
        iconName,
        primaryColorHex,
        sourceType,
        sourceReference,
        reviewStatus,
        metadata,
      ];
}
