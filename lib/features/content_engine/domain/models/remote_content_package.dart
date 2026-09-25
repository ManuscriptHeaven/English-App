import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'content_item.dart';

/// Remote content package model representing cloud-hosted curriculum with governance metadata.
class RemoteContentPackage extends Equatable {
  final String packageId;
  final String worldId;
  final int version;
  final String checksum;
  final String title;
  final String description;
  final int ageMin;
  final int ageMax;
  final DifficultyLevel difficulty;
  final String languageCode; // 'en', expandable for localization
  final List<ContentItem> contentItems;
  final ReviewStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewNotes;
  final DateTime publishedAt;
  final DateTime updatedAt;

  const RemoteContentPackage({
    required this.packageId,
    required this.worldId,
    required this.version,
    required this.checksum,
    required this.title,
    required this.description,
    this.ageMin = 3,
    this.ageMax = 10,
    this.difficulty = DifficultyLevel.beginner,
    this.languageCode = 'en',
    this.contentItems = const [],
    this.status = ReviewStatus.published,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewNotes,
    required this.publishedAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'packageId': packageId,
        'worldId': worldId,
        'version': version,
        'checksum': checksum,
        'title': title,
        'description': description,
        'ageMin': ageMin,
        'ageMax': ageMax,
        'difficulty': difficulty.name,
        'languageCode': languageCode,
        'contentItems': contentItems.map((c) => c.toJson()).toList(),
        'status': status.name,
        'reviewedBy': reviewedBy,
        'reviewedAt': reviewedAt?.toIso8601String(),
        'reviewNotes': reviewNotes,
        'publishedAt': publishedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory RemoteContentPackage.fromJson(Map<String, dynamic> json) => RemoteContentPackage(
        packageId: json['packageId'] as String,
        worldId: json['worldId'] as String,
        version: json['version'] as int? ?? 1,
        checksum: json['checksum'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        ageMin: json['ageMin'] as int? ?? 3,
        ageMax: json['ageMax'] as int? ?? 10,
        difficulty: DifficultyLevel.values.firstWhere(
          (e) => e.name == json['difficulty'],
          orElse: () => DifficultyLevel.beginner,
        ),
        languageCode: json['languageCode'] as String? ?? 'en',
        contentItems: (json['contentItems'] as List<dynamic>?)
                ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        status: ReviewStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ReviewStatus.published,
        ),
        reviewedBy: json['reviewedBy'] as String?,
        reviewedAt: json['reviewedAt'] != null
            ? DateTime.parse(json['reviewedAt'] as String)
            : null,
        reviewNotes: json['reviewNotes'] as String?,
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );

  @override
  List<Object?> get props => [
        packageId,
        worldId,
        version,
        checksum,
        title,
        description,
        ageMin,
        ageMax,
        difficulty,
        languageCode,
        contentItems,
        status,
        reviewedBy,
        reviewedAt,
        reviewNotes,
        publishedAt,
        updatedAt,
      ];
}
