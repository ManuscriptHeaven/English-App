import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/skill_dimension.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('MasteryEngine & VocabularyMastery Tests', () {
    const engine = MasteryEngine();
    final baseTime = DateTime(2026, 9, 1, 10, 0);

    test('Initial mastery creation starts at zero and newWord state', () {
      final initial = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        now: baseTime,
      );

      expect(initial.childId, equals('child_ayaan'));
      expect(initial.vocabularyId, equals('vocab_elephant'));
      expect(initial.word, equals('Elephant'));
      expect(initial.masteryScore, equals(0.0));
      expect(initial.currentLearningState, equals(VocabularyLearningState.newWord));
      expect(initial.exposureCount, equals(0));
      expect(initial.correctAttempts, equals(0));
      expect(initial.incorrectAttempts, equals(0));
    });

    test('Single listening discovery transitions to introduced state', () {
      final evidence = LearningEvidence(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        isCorrect: true,
        dimension: SkillDimension.listening,
        listeningTested: true,
        listeningSuccess: true,
        timestamp: baseTime,
      );

      final updated = engine.recordAttempt(evidence: evidence);

      expect(updated.exposureCount, equals(1));
      expect(updated.correctAttempts, equals(1));
      expect(updated.listeningRecognitionSuccess, equals(1));
      expect(updated.masteryScore, greaterThan(0.0));
      expect(updated.currentLearningState, equals(VocabularyLearningState.learning));
    });

    test('Independent recall gives higher gain than assisted recall with hint', () {
      // Independent recall
      final indepEvidence = LearningEvidence(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        isCorrect: true,
        isIndependentRecall: true,
        usedHint: false,
        dimension: SkillDimension.vocabularyRecall,
        timestamp: baseTime,
      );
      final indepResult = engine.recordAttempt(evidence: indepEvidence);

      // Assisted recall
      final assistEvidence = LearningEvidence(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        isCorrect: true,
        isIndependentRecall: false,
        usedHint: true,
        dimension: SkillDimension.vocabularyRecall,
        timestamp: baseTime,
      );
      final assistResult = engine.recordAttempt(evidence: assistEvidence);

      expect(indepResult.masteryScore, greaterThan(assistResult.masteryScore));
      expect(assistResult.hintCount, equals(1));
    });

    test('Consecutive incorrect answers apply streak penalty and enter struggling state', () {
      VocabularyMastery current = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_bird',
        word: 'Bird',
        now: baseTime,
      ).copyWith(
        masteryScore: 0.45,
        currentLearningState: VocabularyLearningState.practicing,
        correctAttempts: 3,
      );

      // Mistake 1
      current = engine.recordAttempt(
        currentMastery: current,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_bird',
          word: 'Bird',
          isCorrect: false,
          timestamp: baseTime.add(const Duration(minutes: 1)),
        ),
      );

      expect(current.consecutiveIncorrect, equals(1));
      expect(current.consecutiveCorrect, equals(0));

      // Mistake 2
      current = engine.recordAttempt(
        currentMastery: current,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_bird',
          word: 'Bird',
          isCorrect: false,
          timestamp: baseTime.add(const Duration(minutes: 2)),
        ),
      );

      // Mistake 3 -> triggers struggling
      current = engine.recordAttempt(
        currentMastery: current,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_bird',
          word: 'Bird',
          isCorrect: false,
          timestamp: baseTime.add(const Duration(minutes: 3)),
        ),
      );

      expect(current.consecutiveIncorrect, equals(3));
      expect(current.currentLearningState, equals(VocabularyLearningState.struggling));
      expect(current.confidenceLevel, lessThan(0.5));
    });

    test('Multi-dimensional skills award appropriate bonuses', () {
      final evidence = LearningEvidence(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_cat',
        word: 'Cat',
        isCorrect: true,
        dimension: SkillDimension.speaking,
        practicedPronunciation: true,
        pronunciationAccurate: true,
        comprehensionTested: true,
        comprehensionSuccess: true,
        listeningTested: true,
        listeningSuccess: true,
        timestamp: baseTime,
      );

      final result = engine.recordAttempt(evidence: evidence);

      expect(result.pronunciationAttempts, equals(1));
      expect(result.pronunciationSuccesses, equals(1));
      expect(result.comprehensionSuccess, equals(1));
      expect(result.listeningRecognitionSuccess, equals(1));
      expect(result.masteryScore, greaterThan(0.20));
    });

    test('Time decay reduces mastery score after days of inactivity capped at max penalty', () {
      final initial = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        currentLearningState: VocabularyLearningState.familiar,
        exposureCount: 10,
        correctAttempts: 9,
        incorrectAttempts: 1,
        consecutiveCorrect: 4,
        consecutiveIncorrect: 0,
        hintCount: 0,
        pronunciationAttempts: 2,
        pronunciationSuccesses: 2,
        listeningRecognitionSuccess: 3,
        comprehensionSuccess: 2,
        lastSeenAt: baseTime,
        lastCorrectAt: baseTime,
        lastReviewedAt: baseTime,
        nextReviewAt: baseTime.add(const Duration(days: 2)),
        masteryScore: 0.80,
        confidenceLevel: 0.85,
      );

      // Check after 10 days of inactivity
      final decayed10Days = engine.applyTimeDecay(
        mastery: initial,
        currentDate: baseTime.add(const Duration(days: 10)),
      );

      // 10 days - 2 days grace = 8 inactive days * 0.02 = 0.16 penalty -> 0.80 - 0.16 = 0.64
      expect(decayed10Days.masteryScore, closeTo(0.64, 0.01));

      // Check after 60 days of inactivity -> capped at 0.30 max penalty -> 0.80 - 0.30 = 0.50
      final decayed60Days = engine.applyTimeDecay(
        mastery: initial,
        currentDate: baseTime.add(const Duration(days: 60)),
      );

      expect(decayed60Days.masteryScore, closeTo(0.50, 0.01));
    });

    test('State progression moves from learning up to mastered with enough independent recalls', () {
      VocabularyMastery current = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_water',
        word: 'Water',
        now: baseTime,
      );

      // Practice repeatedly with independent success
      for (int i = 0; i < 7; i++) {
        current = engine.recordAttempt(
          currentMastery: current,
          evidence: LearningEvidence(
            childId: 'child_ayaan',
            vocabularyId: 'vocab_water',
            word: 'Water',
            isCorrect: true,
            isIndependentRecall: true,
            dimension: SkillDimension.vocabularyRecall,
            timestamp: baseTime.add(Duration(hours: i * 12)),
          ),
        );
      }

      expect(current.correctAttempts, equals(7));
      expect(current.consecutiveCorrect, equals(7));
      expect(current.masteryScore, greaterThanOrEqualTo(0.85));
      expect(current.currentLearningState, equals(VocabularyLearningState.mastered));
      expect(current.confidenceLevel, greaterThanOrEqualTo(0.80));
    });

    test('Child profile isolation: Ayaan practice does not alter Maryam mastery', () {
      final ayaanEvidence = LearningEvidence(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        isCorrect: true,
        isIndependentRecall: true,
        timestamp: baseTime,
      );

      final maryamMastery = VocabularyMastery.initial(
        childId: 'child_maryam',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        now: baseTime,
      );

      final updatedAyaan = engine.recordAttempt(evidence: ayaanEvidence);

      expect(updatedAyaan.childId, equals('child_ayaan'));
      expect(updatedAyaan.masteryScore, greaterThan(0.0));

      expect(maryamMastery.childId, equals('child_maryam'));
      expect(maryamMastery.masteryScore, equals(0.0));
      expect(maryamMastery.currentLearningState, equals(VocabularyLearningState.newWord));
    });
  });
}
