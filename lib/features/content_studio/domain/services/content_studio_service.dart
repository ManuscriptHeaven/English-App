import 'package:kids_english_adventure/features/content_engine/domain/models/content_item.dart';
import 'package:kids_english_adventure/features/content_engine/domain/services/content_validator.dart';
import '../models/content_draft.dart';
import '../models/content_release.dart';
import '../models/content_review.dart';

/// Core authoring service managing draft lifecycles, reviews, validation, and release publishing.
class ContentStudioService {
  final Map<String, ContentDraft> _drafts = {};
  final Map<String, List<ContentReview>> _reviews = {};
  final List<ContentRelease> _releases = [];

  ContentDraft createDraft({
    required String id,
    required String contentPackageId,
    required String authorId,
    required int version,
    required String title,
    required String description,
    List<ContentItem> items = const [],
  }) {
    final draft = ContentDraft(
      id: id,
      contentPackageId: contentPackageId,
      authorId: authorId,
      version: version,
      title: title,
      description: description,
      status: ReviewStatus.draft,
      contentItems: items,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _drafts[id] = draft;
    return draft;
  }

  ContentDraft? getDraft(String id) => _drafts[id];

  List<ContentReview> getReviews(String draftId) => _reviews[draftId] ?? const [];

  List<ContentRelease> getReleases() => List.unmodifiable(_releases);

  /// Submits a draft for review if it passes basic validation.
  bool submitForEducationalReview(String draftId) {
    final draft = _drafts[draftId];
    if (draft == null) return false;

    // Validate items before submitting
    for (final item in draft.contentItems) {
      final errors = ContentValidator.validateContentItem(item);
      if (errors.isNotEmpty) return false;
    }

    _drafts[draftId] = draft.copyWith(
      status: ReviewStatus.educationalReview,
      updatedAt: DateTime.now(),
    );
    return true;
  }

  /// Adds a review decision (Educational or Islamic).
  bool addReview({
    required String draftId,
    required String reviewerId,
    required ReviewType reviewType,
    required ReviewDecision decision,
    required String notes,
  }) {
    final draft = _drafts[draftId];
    if (draft == null) return false;

    final review = ContentReview(
      id: 'rev_${DateTime.now().microsecondsSinceEpoch}',
      draftId: draftId,
      reviewerId: reviewerId,
      reviewType: reviewType,
      decision: decision,
      notes: notes,
      reviewedAt: DateTime.now(),
    );

    _reviews.putIfAbsent(draftId, () => []).add(review);

    if (decision == ReviewDecision.reject || decision == ReviewDecision.requestChanges) {
      _drafts[draftId] = draft.copyWith(
        status: ReviewStatus.draft,
        reviewNotes: notes,
        updatedAt: DateTime.now(),
      );
      return true;
    }

    // If educational review approved and there are Islamic values/manners items, require Islamic review
    final hasIslamicContent = draft.contentItems.any(
        (i) => i.valueIds.isNotEmpty || i.sourceType != null || i.mannerIds.isNotEmpty);

    if (reviewType == ReviewType.educational && hasIslamicContent) {
      _drafts[draftId] = draft.copyWith(
        status: ReviewStatus.islamicReview,
        reviewedBy: reviewerId,
        reviewedAt: DateTime.now(),
        reviewNotes: notes,
        updatedAt: DateTime.now(),
      );
    } else {
      // Approved
      _drafts[draftId] = draft.copyWith(
        status: ReviewStatus.approved,
        reviewedBy: reviewerId,
        reviewedAt: DateTime.now(),
        reviewNotes: notes,
        updatedAt: DateTime.now(),
      );
    }

    return true;
  }

  /// Publishes an approved draft into an immutable production ContentRelease.
  ContentRelease? publishDraft(String draftId) {
    final draft = _drafts[draftId];
    if (draft == null || draft.status != ReviewStatus.approved) {
      return null;
    }

    final publishedAt = DateTime.now();
    final publishedDraft = draft.copyWith(
      status: ReviewStatus.published,
      publishedAt: publishedAt,
      updatedAt: publishedAt,
    );

    _drafts[draftId] = publishedDraft;

    final release = ContentRelease(
      id: 'rel_${draft.contentPackageId}_v${draft.version}',
      packageId: draft.contentPackageId,
      version: draft.version,
      checksum: 'sha256_${draft.contentPackageId}_v${draft.version}_${publishedAt.millisecondsSinceEpoch}',
      title: draft.title,
      releasedBy: draft.reviewedBy ?? draft.authorId,
      publishedAt: publishedAt,
      itemCount: draft.contentItems.length,
    );

    _releases.add(release);
    return release;
  }
}
