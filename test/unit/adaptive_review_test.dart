import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/rewards/domain/models/child_progress.dart';

void main() {
  group('Adaptive Review & Spaced Mastery Scheduling Tests', () {
    final now = DateTime(2026, 8, 22);

    test('Schedules low mastery (<0.4) for next day review', () {
      final nextDate = WordProgress.calculateNextReview(0.35, now);
      expect(nextDate.difference(now).inDays, equals(1));
    });

    test('Schedules medium mastery (0.4-0.7) for 3-day interval', () {
      final nextDate = WordProgress.calculateNextReview(0.60, now);
      expect(nextDate.difference(now).inDays, equals(3));
    });

    test('Schedules strong mastery (0.7-0.9) for 7-day interval', () {
      final nextDate = WordProgress.calculateNextReview(0.85, now);
      expect(nextDate.difference(now).inDays, equals(7));
    });

    test('Schedules mastered items (>=0.9) for 14-day maintenance review', () {
      final nextDate = WordProgress.calculateNextReview(0.95, now);
      expect(nextDate.difference(now).inDays, equals(14));
    });

    test('Identifies when word is due for review', () {
      final progress = WordProgress(
        wordId: 'vocab_clean',
        masteryLevel: 0.5,
        lastReviewed: now.subtract(const Duration(days: 4)),
        nextReviewDate: now.subtract(const Duration(days: 1)),
      );

      expect(progress.isDueForReview(now), isTrue);
    });
  });
}
