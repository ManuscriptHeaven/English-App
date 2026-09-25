import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'content_item.dart';

/// Top-level package bundle containing versioned content items for a world.
class CurriculumPackage extends Equatable {
  final String id;
  final String worldId;
  final int version;
  final String title;
  final String description;
  final int ageMin;
  final int ageMax;
  final DifficultyLevel difficulty;
  final String languageLevel;
  final List<String> learningObjectives;
  final List<String> valueObjectives;
  final List<ContentItem> contentItems;
  final ReviewStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CurriculumPackage({
    required this.id,
    required this.worldId,
    this.version = 1,
    required this.title,
    required this.description,
    this.ageMin = 3,
    this.ageMax = 10,
    this.difficulty = DifficultyLevel.beginner,
    this.languageLevel = 'Pre-A1',
    this.learningObjectives = const [],
    this.valueObjectives = const [],
    this.contentItems = const [],
    this.status = ReviewStatus.published,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'worldId': worldId,
        'version': version,
        'title': title,
        'description': description,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'difficulty': difficulty.name,
        'languageLevel': languageLevel,
        'learningObjectives': learningObjectives,
        'valueObjectives': valueObjectives,
        'contentItems': contentItems.map((c) => c.toJson()).toList(),
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory CurriculumPackage.fromJson(Map<String, dynamic> json) => CurriculumPackage(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        version: json['version'] as int? ?? 1,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        ageMin: json['ageMin'] as int? ?? 3,
        ageMax: json['ageMax'] as int? ?? 10,
        difficulty: DifficultyLevel.values.firstWhere(
          (e) => e.name == json['difficulty'],
          orElse: () => DifficultyLevel.beginner,
        ),
        languageLevel: json['languageLevel'] as String? ?? 'Pre-A1',
        learningObjectives: (json['learningObjectives'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        valueObjectives: (json['valueObjectives'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        contentItems: (json['contentItems'] as List<dynamic>?)
                ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        status: ReviewStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ReviewStatus.published,
        ),
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  @override
  List<Object?> get props => [
        id,
        worldId,
        version,
        title,
        description,
        ageMin,
        ageMax,
        difficulty,
        languageLevel,
        learningObjectives,
        valueObjectives,
        contentItems,
        status,
        createdAt,
        updatedAt,
      ];
}
