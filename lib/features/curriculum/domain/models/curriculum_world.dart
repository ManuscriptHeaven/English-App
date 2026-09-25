import 'package:equatable/equatable.dart';
import 'learning_age_band.dart';

/// Meaningful language domain representing a thematic environment where real-world
/// communication takes place.
class CurriculumWorld extends Equatable {
  final String id;
  final List<String> levelIds;
  final String title;
  final String childFriendlyTitle;
  final String theme; // e.g. 'family', 'home', 'food', 'animals'
  final String description;
  final String primaryLanguageDomain; // e.g. 'Family Relations', 'Dining & Manners'
  final List<String> valueThemes;
  final List<String> unitIds;
  final List<String> prerequisites;
  final List<LearningAgeBand> recommendedAgeBands;
  final String visualThemeId;
  final List<String> unlockRequirements;
  final String? missionId;
  final Map<String, dynamic> metadata;

  const CurriculumWorld({
    required this.id,
    required this.levelIds,
    required this.title,
    required this.childFriendlyTitle,
    required this.theme,
    required this.description,
    required this.primaryLanguageDomain,
    this.valueThemes = const [],
    this.unitIds = const [],
    this.prerequisites = const [],
    this.recommendedAgeBands = const [
      LearningAgeBand.bandALittleExplorers,
      LearningAgeBand.bandBYoungAdventurers,
      LearningAgeBand.bandCGrowingSpeakers,
      LearningAgeBand.bandDConfidentSpeakers,
    ],
    this.visualThemeId = 'world_default',
    this.unlockRequirements = const [],
    this.missionId,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'levelIds': levelIds,
        'title': title,
        'childFriendlyTitle': childFriendlyTitle,
        'theme': theme,
        'description': description,
        'primaryLanguageDomain': primaryLanguageDomain,
        'valueThemes': valueThemes,
        'unitIds': unitIds,
        'prerequisites': prerequisites,
        'recommendedAgeBands': recommendedAgeBands.map((b) => b.name).toList(),
        'visualThemeId': visualThemeId,
        'unlockRequirements': unlockRequirements,
        'missionId': missionId,
        'metadata': metadata,
      };

  factory CurriculumWorld.fromJson(Map<String, dynamic> json) => CurriculumWorld(
        id: json['id'] as String,
        levelIds: (json['levelIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        title: json['title'] as String,
        childFriendlyTitle: json['childFriendlyTitle'] as String,
        theme: json['theme'] as String,
        description: json['description'] as String,
        primaryLanguageDomain: json['primaryLanguageDomain'] as String,
        valueThemes: (json['valueThemes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        unitIds: (json['unitIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        prerequisites: (json['prerequisites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        recommendedAgeBands: (json['recommendedAgeBands'] as List<dynamic>?)
                ?.map((b) => LearningAgeBand.values.firstWhere(
                      (e) => e.name == b,
                      orElse: () => LearningAgeBand.bandALittleExplorers,
                    ))
                .toList() ??
            const [],
        visualThemeId: json['visualThemeId'] as String? ?? 'world_default',
        unlockRequirements:
            (json['unlockRequirements'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        missionId: json['missionId'] as String?,
        metadata: json['metadata'] as Map<String, dynamic>? ?? const {},
      );

  @override
  List<Object?> get props => [
        id,
        levelIds,
        title,
        childFriendlyTitle,
        theme,
        description,
        primaryLanguageDomain,
        valueThemes,
        unitIds,
        prerequisites,
        recommendedAgeBands,
        visualThemeId,
        unlockRequirements,
        missionId,
        metadata,
      ];
}
