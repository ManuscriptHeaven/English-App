import 'vocabulary_mastery.dart';

/// Pure domain scheduler managing natural, child-friendly spaced vocabulary review.
///
/// Blends review words naturally into fun activities rather than turning
/// the app into a rigid, academic flashcard quiz.
class SpacedReviewScheduler {
  const SpacedReviewScheduler();

  /// Filters all vocabulary that is currently due for review based on [now].
  List<VocabularyMastery> getDueForReview(
    List<VocabularyMastery> masteries,
    DateTime now,
  ) {
    return masteries.where((m) => m.isReviewDue(now)).toList();
  }

  /// Filters all vocabulary currently marked as struggling.
  List<VocabularyMastery> getStruggling(List<VocabularyMastery> masteries) {
    return masteries.where((m) => m.isStruggling).toList();
  }

  /// Produces a prioritized list of vocabulary that would benefit most from practice.
  ///
  /// Order of urgency:
  /// 1. Struggling items (repeated mistakes)
  /// 2. Overdue review items (most overdue first)
  /// 3. Developing items in 'practicing' state
  /// 4. Newly introduced items needing early consolidation
  List<VocabularyMastery> getPrioritizedReviewQueue(
    List<VocabularyMastery> masteries,
    DateTime now,
  ) {
    final list = List<VocabularyMastery>.from(masteries);
    list.sort((a, b) {
      // 1. Struggling first
      if (a.isStruggling && !b.isStruggling) return -1;
      if (!a.isStruggling && b.isStruggling) return 1;

      // 2. Overdue reviews
      final aDue = a.isReviewDue(now);
      final bDue = b.isReviewDue(now);
      if (aDue && !bDue) return -1;
      if (!aDue && bDue) return 1;
      if (aDue && bDue) {
        return a.nextReviewAt.compareTo(b.nextReviewAt);
      }

      // 3. Lowest mastery score
      return a.masteryScore.compareTo(b.masteryScore);
    });

    return list;
  }

  /// Blends new target words with a healthy proportion of review/familiar words.
  ///
  /// For example, if a lesson has 4 new words, this helper can blend:
  /// 3 new words + 2 familiar/review words to reduce cognitive load and build confidence.
  List<String> blendCurriculumSession({
    required List<String> newWordIds,
    required List<VocabularyMastery> existingMasteries,
    required DateTime now,
    int maxTotalWords = 5,
    int maxNewWords = 3,
  }) {
    final candidateNew = newWordIds.take(maxNewWords).toList();
    final reviewQueue = getPrioritizedReviewQueue(existingMasteries, now);

    final selectedReview = <String>[];
    for (final reviewItem in reviewQueue) {
      if (!candidateNew.contains(reviewItem.vocabularyId)) {
        selectedReview.add(reviewItem.vocabularyId);
      }
      if (candidateNew.length + selectedReview.length >= maxTotalWords) {
        break;
      }
    }

    return [...candidateNew, ...selectedReview];
  }
}
