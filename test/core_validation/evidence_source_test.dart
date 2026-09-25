import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('Evidence Source Multiplier Validation', () {
    late MasteryEngine engine;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      engine = const MasteryEngine();
    });

    test('All 8 evidence sources apply expected multipliers to score gain', () {
      final initial = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        now: now,
      );

      final deltas = <LearningEvidenceSource, double>{};

      for (final source in LearningEvidenceSource.values) {
        final result = engine.recordAttempt(
          currentMastery: initial,
          evidence: LearningEvidence(
            childId: 'child_ayaan',
            vocabularyId: 'vocab_elephant',
            word: 'Elephant',
            isCorrect: true,
            isIndependentRecall: true,
            source: source,
            timestamp: now.add(const Duration(minutes: 5)),
          ),
        );
        deltas[source] = result.masteryScore - initial.masteryScore;
      }

      // Assert relative ordering:
      // passiveExposure (0.6x) < promptedRecall (0.8x) < audioRecognition (0.9x) == imageRecognition (0.9x)
      // < unpromptedRecall (1.0x) < sentenceContext (1.1x) < storyContext (1.15x) < spokenProduction (1.25x)
      expect(
        deltas[LearningEvidenceSource.passiveExposure]!,
        lessThan(deltas[LearningEvidenceSource.promptedRecall]!),
      );
      expect(
        deltas[LearningEvidenceSource.promptedRecall]!,
        lessThan(deltas[LearningEvidenceSource.audioRecognition]!),
      );
      expect(
        deltas[LearningEvidenceSource.audioRecognition]!,
        lessThan(deltas[LearningEvidenceSource.imageRecognition]!),
      );
      expect(
        deltas[LearningEvidenceSource.imageRecognition]!,
        lessThan(deltas[LearningEvidenceSource.unpromptedRecall]!),
      );
      expect(
        deltas[LearningEvidenceSource.unpromptedRecall]!,
        lessThan(deltas[LearningEvidenceSource.sentenceContext]!),
      );
      expect(
        deltas[LearningEvidenceSource.sentenceContext]!,
        lessThan(deltas[LearningEvidenceSource.storyContext]!),
      );
      expect(
        deltas[LearningEvidenceSource.storyContext]!,
        lessThan(deltas[LearningEvidenceSource.spokenProduction]!),
      );
    });
  });
}
