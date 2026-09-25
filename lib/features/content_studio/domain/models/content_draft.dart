import 'package:equatable/equatable.dart';
import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';

/// Authoring draft entity representing unreleased curriculum changes.
class ContentDraft extends Equatable {
  final String id;
  final String contentPackageId;
  final String authorId;
  final int version;
  final String title;
  final String description;
  final ReviewStatus status;
  final List<ContentItem> contentItems;
  final String? reviewNotes;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;

  const ContentDraft({
    required this.id,
    required this.contentPackageId,
    required this.authorId,
    required this.version,
    required this.title,
    required this.description,
    this.status = ReviewStatus.draft,
    this.contentItems = const [],
    this.reviewNotes,
    this.reviewedBy,
    this.reviewedAt,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
  });

  ContentDraft copyWith({
    String? id,
    String? contentPackageId,
    String? authorId,
    int? version,
    String? title,
    String? description,
    ReviewStatus? status,
    List<ContentItem>? contentItems,
    String? reviewNotes,
    String? reviewedBy,
    DateTime? reviewedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? publishedAt,
  }) {
    return ContentDraft(
      id: id ?? this.id,
      contentPackageId: contentPackageId ?? this.contentPackageId,
      authorId: authorId ?? this.authorId,
      version: version ?? this.version,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      contentItems: contentItems ?? this.contentItems,
      reviewNotes: reviewNotes ?? this.reviewNotes,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      publishedAt: publishedAt ?? this.publishedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'contentPackageId': contentPackageId,
        'authorId': authorId,
        'version': version,
        'title': title,
        'description': description,
        'status': status.name,
        'contentItems': contentItems.map((c) => c.toJson()).toList(),
        'reviewNotes': reviewNotes,
        'reviewedBy': reviewedBy,
        'reviewedAt': reviewedAt?.toIso8601String(),
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'publishedAt': publishedAt?.toIso8601String(),
      };

  factory ContentDraft.fromJson(Map<String, dynamic> json) => ContentDraft(
        id: json['id'] as String,
        contentPackageId: json['contentPackageId'] as String,
        authorId: json['authorId'] as String,
        version: json['version'] as int? ?? 1,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        status: ReviewStatus.values.firstWhere(
          (e) => e.name == json['status'],
          orElse: () => ReviewStatus.draft,
        ),
        contentItems: (json['contentItems'] as List<dynamic>?)
                ?.map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const [],
        reviewNotes: json['reviewNotes'] as String?,
        reviewedBy: json['reviewedBy'] as String?,
        reviewedAt: json['reviewedAt'] != null
            ? DateTime.parse(json['reviewedAt'] as String)
            : null,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        publishedAt: json['publishedAt'] != null
            ? DateTime.parse(json['publishedAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [
        id,
        contentPackageId,
        authorId,
        version,
        title,
        description,
        status,
        contentItems,
        reviewNotes,
        reviewedBy,
        reviewedAt,
        createdAt,
        updatedAt,
        publishedAt,
      ];
}
