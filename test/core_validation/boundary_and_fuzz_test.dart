import 'dart:math' as math;
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('Boundary & Deterministic Fuzz Testing (Critical Behavioral Invariants)', () {
    test('Fuzz test 2,000 randomized events preserves all core mathematical and domain invariants', () {
      const seed = 98765;
      final random = math.Random(seed);
      final engine = const MasteryEngine();
      var now = DateTime(2026, 9, 10, 8, 0, 0);

      var mastery = VocabularyMastery.initial(
        childId: 'child_fuzz_test',
        vocabularyId: 'vocab_fuzz_word',
        word: 'FuzzWord',
        now: now,
      );

      for (int i = 0; i < 2000; i++) {
        final isCorrect = random.nextBool();
        final usedHint = random.nextBool();
        final source = LearningEvidenceSource.values[random.nextInt(LearningEvidenceSource.values.length)];
        final isIndependentRecall = !usedHint && random.nextBool();

        // Advance time randomly between 1 minute and 4 days
        final timeDeltaMinutes = 1 + random.nextInt(4 * 24 * 60);
        now = now.add(Duration(minutes: timeDeltaMinutes));

        final evidence = LearningEvidence(
          childId: 'child_fuzz_test',
          vocabularyId: 'vocab_fuzz_word',
          word: 'FuzzWord',
          isCorrect: isCorrect,
          usedHint: usedHint,
          source: source,
          isIndependentRecall: isIndependentRecall,
          practicedPronunciation: random.nextBool(),
          pronunciationAccurate: random.nextBool(),
          listeningTested: random.nextBool(),
          listeningSuccess: random.nextBool(),
          comprehensionTested: random.nextBool(),
          comprehensionSuccess: random.nextBool(),
          timestamp: now,
        );

        mastery = engine.recordAttempt(
          currentMastery: mastery,
          evidence: evidence,
        );

        // --- Critical Behavioral Invariants Assertions ---
        expect(
          mastery.masteryScore >= 0.0 && mastery.masteryScore <= 1.0,
          isTrue,
          reason: 'Invariant failed at iteration $i (seed: $seed): score=${mastery.masteryScore}',
        );

        expect(
          mastery.confidenceLevel >= 0.0 && mastery.confidenceLevel <= 1.0,
          isTrue,
          reason: 'Invariant failed at iteration $i (seed: $seed): confidence=${mastery.confidenceLevel}',
        );

        expect(
          mastery.exposureCount,
          greaterThanOrEqualTo(0),
          reason: 'Invariant failed: negative exposures',
        );

        expect(
          mastery.correctAttempts,
          greaterThanOrEqualTo(0),
          reason: 'Invariant failed: negative correct attempts',
        );

        expect(
          mastery.incorrectAttempts,
          greaterThanOrEqualTo(0),
          reason: 'Invariant failed: negative incorrect attempts',
        );

        expect(
          mastery.childId,
          equals('child_fuzz_test'),
          reason: 'Invariant failed: childId mutation detected',
        );
      }
    });
  });
}
