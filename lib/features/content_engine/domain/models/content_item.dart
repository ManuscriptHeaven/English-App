import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'activity_type.dart';

/// Review and moderation pipeline state for curriculum content.
enum ReviewStatus {
  draft,
  educationalReview,
  islamicReview,
  approved,
  published,
  archived,
}

/// Generic, modular content item powering activities, lessons, and reviews.
class ContentItem extends Equatable {
  final String id;
  final ActivityType activityType;
  final String title;
  final String description;
  final int ageMin;
  final int ageMax;
  final DifficultyLevel difficulty;
  final SkillType skill;
  final String learningObjective;
  final Map<String, dynamic> contentData;
  final List<String> assetReferences;
  final List<String> audioReferences;
  final List<String> valueIds;
  final List<String> mannerIds;
  final List<String> prerequisiteIds;
  final List<String> tags;
  final String? sourceType;
  final String? sourceReference;
  final ReviewStatus reviewStatus;

  const ContentItem({
    required this.id,
    required this.activityType,
    required this.title,
    required this.description,
    this.ageMin = 3,
    this.ageMax = 10,
    this.difficulty = DifficultyLevel.beginner,
    required this.skill,
    required this.learningObjective,
    required this.contentData,
    this.assetReferences = const [],
    this.audioReferences = const [],
    this.valueIds = const [],
    this.mannerIds = const [],
    this.prerequisiteIds = const [],
    this.tags = const [],
    this.sourceType,
    this.sourceReference,
    this.reviewStatus = ReviewStatus.published,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'activityType': activityType.name,
        'title': title,
        'description': description,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'difficulty': difficulty.name,
        'skill': skill.name,
        'learningObjective': learningObjective,
        'contentData': contentData,
        'assetReferences': assetReferences,
        'audioReferences': audioReferences,
        'valueIds': valueIds,
        'mannerIds': mannerIds,
        'prerequisiteIds': prerequisiteIds,
        'tags': tags,
        'sourceType': sourceType,
        'sourceReference': sourceReference,
        'reviewStatus': reviewStatus.name,
      };

  factory ContentItem.fromJson(Map<String, dynamic> json) => ContentItem(
        id: json['id'] as String,
        activityType: ActivityType.values.firstWhere(
          (e) => e.name == json['activityType'],
          orElse: () => ActivityType.vocabularyDiscovery,
        ),
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        ageMin: json['ageMin'] as int? ?? 3,
        ageMax: json['ageMax'] as int? ?? 10,
        difficulty: DifficultyLevel.values.firstWhere(
          (e) => e.name == json['difficulty'],
          orElse: () => DifficultyLevel.beginner,
        ),
        skill: SkillType.values.firstWhere(
          (e) => e.name == json['skill'],
          orElse: () => SkillType.vocabulary,
        ),
        learningObjective: json['learningObjective'] as String? ?? '',
        contentData: (json['contentData'] as Map<String, dynamic>?) ?? {},
        assetReferences: (json['assetReferences'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        audioReferences: (json['audioReferences'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        valueIds: (json['valueIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        mannerIds: (json['mannerIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        prerequisiteIds: (json['prerequisiteIds'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
        sourceType: json['sourceType'] as String?,
        sourceReference: json['sourceReference'] as String?,
        reviewStatus: ReviewStatus.values.firstWhere(
          (e) => e.name == json['reviewStatus'],
          orElse: () => ReviewStatus.published,
        ),
      );

  @override
  List<Object?> get props => [
        id,
        activityType,
        title,
        description,
        ageMin,
        ageMax,
        difficulty,
        skill,
        learningObjective,
        contentData,
        assetReferences,
        audioReferences,
        valueIds,
        mannerIds,
        prerequisiteIds,
        tags,
        sourceType,
        sourceReference,
        reviewStatus,
      ];
}
