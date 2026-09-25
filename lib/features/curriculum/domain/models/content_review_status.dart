import 'package:equatable/equatable.dart';

/// Editorial approval status lifecycle ensuring no unreviewed or AI-hallucinated
/// material is exposed to young learners in production.
enum ContentReviewStatus {
  draft,
  aiGeneratedDraft,
  internallyReviewed,
  languageReviewed,
  islamicReviewRequired,
  pendingQualifiedIslamicReview,
  islamicReviewed,
  approved,
  deprecated;

  /// Whether this content is certified for live child-facing production builds.
  bool get isProductionReady => this == ContentReviewStatus.approved;

  String get displayName {
    switch (this) {
      case ContentReviewStatus.draft:
        return 'Draft';
      case ContentReviewStatus.aiGeneratedDraft:
        return 'AI Generated Draft (Unreviewed)';
      case ContentReviewStatus.internallyReviewed:
        return 'Internally Reviewed';
      case ContentReviewStatus.languageReviewed:
        return 'Language & ESL Reviewed';
      case ContentReviewStatus.islamicReviewRequired:
      case ContentReviewStatus.pendingQualifiedIslamicReview:
        return 'Pending Qualified Islamic Review';
      case ContentReviewStatus.islamicReviewed:
        return 'Islamic Scholar Approved';
      case ContentReviewStatus.approved:
        return 'Fully Approved Production Content';
      case ContentReviewStatus.deprecated:
        return 'Deprecated / Archived';
    }
  }
}

/// Authorship, versioning, and verification provenance metadata for curriculum assets.
class ContentProvenance extends Equatable {
  final String authoredBy;
  final String? reviewedBy;
  final String sourceType; // 'humanExpert', 'curriculumSeed', 'aiGeneratedDraft', etc.
  final DateTime lastReviewedAt;
  final int version;
  final String notes;

  const ContentProvenance({
    required this.authoredBy,
    this.reviewedBy,
    this.sourceType = 'humanExpert',
    required this.lastReviewedAt,
    this.version = 1,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'authoredBy': authoredBy,
        'reviewedBy': reviewedBy,
        'sourceType': sourceType,
        'lastReviewedAt': lastReviewedAt.toIso8601String(),
        'version': version,
        'notes': notes,
      };

  factory ContentProvenance.fromJson(Map<String, dynamic> json) => ContentProvenance(
        authoredBy: json['authoredBy'] as String,
        reviewedBy: json['reviewedBy'] as String?,
        sourceType: json['sourceType'] as String? ?? 'humanExpert',
        lastReviewedAt: DateTime.parse(json['lastReviewedAt'] as String),
        version: json['version'] as int? ?? 1,
        notes: json['notes'] as String? ?? '',
      );

  @override
  List<Object?> get props => [
        authoredBy,
        reviewedBy,
        sourceType,
        lastReviewedAt,
        version,
        notes,
      ];
}
