import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('Mastery Trajectory & Behavioral Invariants Validation', () {
    late MasteryEngine engine;
    final baseTime = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      engine = const MasteryEngine();
    });

    test('1. Step-by-step trajectory progression from newWord to mastered', () {
      var mastery = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        now: baseTime,
      );

      expect(mastery.currentLearningState, equals(VocabularyLearningState.newWord));
      expect(mastery.masteryScore, equals(0.0));

      final trajectoryLog = <String>[];
      trajectoryLog.add('Initial: score=${mastery.masteryScore}, state=${mastery.currentLearningState.name}');

      // Step 1: First independent recall (correct)
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          isCorrect: true,
          isIndependentRecall: true,
          timestamp: baseTime.add(const Duration(minutes: 5)),
        ),
      );
      trajectoryLog.add('Step 1 (Recall): score=${mastery.masteryScore}, state=${mastery.currentLearningState.name}');
      expect(mastery.masteryScore, greaterThan(0.10));
      expect(mastery.currentLearningState, equals(VocabularyLearningState.learning));

      // Step 2: Second correct recall
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          isCorrect: true,
          isIndependentRecall: true,
          timestamp: baseTime.add(const Duration(hours: 12)),
        ),
      );
      trajectoryLog.add('Step 2 (Recall): score=${mastery.masteryScore}, state=${mastery.currentLearningState.name}');
      expect(mastery.currentLearningState, equals(VocabularyLearningState.learning));

      // Step 3: Third correct recall with streak bonus
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          isCorrect: true,
          isIndependentRecall: true,
          timestamp: baseTime.add(const Duration(days: 2)),
        ),
      );
      trajectoryLog.add('Step 3 (Recall): score=${mastery.masteryScore}, state=${mastery.currentLearningState.name}');
      expect(mastery.currentLearningState, equals(VocabularyLearningState.practicing));

      // Steps 4, 5, 6: Additional correct attempts to reach mastery
      for (int i = 4; i <= 6; i++) {
        mastery = engine.recordAttempt(
          currentMastery: mastery,
          evidence: LearningEvidence(
            childId: 'child_ayaan',
            vocabularyId: 'vocab_elephant',
            word: 'Elephant',
            isCorrect: true,
            isIndependentRecall: true,
            timestamp: baseTime.add(Duration(days: i)),
          ),
        );
        trajectoryLog.add('Step $i (Recall): score=${mastery.masteryScore}, state=${mastery.currentLearningState.name}');
      }

      expect(mastery.currentLearningState, equals(VocabularyLearningState.mastered));
      expect(mastery.masteryScore, greaterThanOrEqualTo(0.85));
      expect(mastery.consecutiveCorrect, greaterThanOrEqualTo(2));
    });

    test('2. Exponential mistake penalty triggers struggling state', () {
      var mastery = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        exposureCount: 5,
        correctAttempts: 4,
        incorrectAttempts: 0,
        consecutiveCorrect: 4,
        lastSeenAt: baseTime,
        nextReviewAt: baseTime.add(const Duration(days: 3)),
        masteryScore: 0.65,
        confidenceLevel: 0.75,
        currentLearningState: VocabularyLearningState.familiar,
      );

      // Mistake 1
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          isCorrect: false,
          timestamp: baseTime.add(const Duration(hours: 1)),
        ),
      );
      expect(mastery.consecutiveIncorrect, equals(1));
      expect(mastery.currentLearningState, isNot(equals(VocabularyLearningState.struggling)));

      // Mistake 2 (streak penalty applied) -> enters struggling state
      mastery = engine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          isCorrect: false,
          timestamp: baseTime.add(const Duration(hours: 2)),
        ),
      );
      expect(mastery.consecutiveIncorrect, equals(2));
      expect(mastery.currentLearningState, equals(VocabularyLearningState.struggling));
    });

    test('3. Time decay respects 2-day grace period and caps penalty at 0.30', () {
      final initial = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_cat',
        word: 'Cat',
        exposureCount: 10,
        correctAttempts: 9,
        incorrectAttempts: 1,
        consecutiveCorrect: 5,
        lastSeenAt: baseTime,
        nextReviewAt: baseTime.add(const Duration(days: 5)),
        masteryScore: 0.85,
        confidenceLevel: 0.90,
        currentLearningState: VocabularyLearningState.familiar,
      );

      // Day 1 & 2: Zero decay (weekend break protection)
      final day2 = engine.applyTimeDecay(
        mastery: initial,
        currentDate: baseTime.add(const Duration(days: 2)),
      );
      expect(day2.masteryScore, equals(0.85));

      // Day 5: 3 inactive days * 0.02 = -0.06 decay
      final day5 = engine.applyTimeDecay(
        mastery: initial,
        currentDate: baseTime.add(const Duration(days: 5)),
      );
      expect(day5.masteryScore, equals(0.79));

      // Day 30: Long absence decay capped at 0.30 penalty
      final day30 = engine.applyTimeDecay(
        mastery: initial,
        currentDate: baseTime.add(const Duration(days: 30)),
      );
      expect(day30.masteryScore, equals(0.55)); // 0.85 - 0.30
      expect(day30.masteryScore, greaterThan(0.0));
    });

    test('4. Score is strictly clamped between 0.0 and 1.0 regardless of extreme events', () {
      var low = VocabularyMastery.initial(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_water',
        word: 'Water',
        now: baseTime,
      );

      // 10 consecutive mistakes on 0.0 initial
      for (int i = 0; i < 10; i++) {
        low = engine.recordAttempt(
          currentMastery: low,
          evidence: LearningEvidence(
            childId: 'child_ayaan',
            vocabularyId: 'vocab_water',
            word: 'Water',
            isCorrect: false,
            usedHint: true,
            timestamp: baseTime.add(Duration(minutes: i)),
          ),
        );
      }
      expect(low.masteryScore, equals(0.0)); // never negative

      // 20 consecutive perfect answers on 0.95
      var high = low.copyWith(masteryScore: 0.95);
      for (int i = 0; i < 20; i++) {
        high = engine.recordAttempt(
          currentMastery: high,
          evidence: LearningEvidence(
            childId: 'child_ayaan',
            vocabularyId: 'vocab_water',
            word: 'Water',
            isCorrect: true,
            isIndependentRecall: true,
            pronunciationAccurate: true,
            listeningSuccess: true,
            comprehensionSuccess: true,
            timestamp: baseTime.add(Duration(days: i)),
          ),
        );
      }
      expect(high.masteryScore, equals(1.0)); // never exceeds 1.0
    });
  });
}
