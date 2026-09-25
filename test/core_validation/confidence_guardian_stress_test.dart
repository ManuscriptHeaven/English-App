import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/confidence_guardian.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('Confidence Guardian Trigger & Recovery Validation', () {
    late ConfidenceGuardian guardian;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    final sampleMasteries = [
      VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        exposureCount: 10,
        correctAttempts: 10,
        incorrectAttempts: 0,
        consecutiveCorrect: 10,
        lastSeenAt: now,
        nextReviewAt: now.add(const Duration(days: 7)),
        masteryScore: 0.95,
        confidenceLevel: 1.0,
        currentLearningState: VocabularyLearningState.mastered,
      ),
    ];

    setUp(() {
      guardian = const ConfidenceGuardian();
    });

    test('1. Consecutive errors >= 3 triggers provideEasyWin with mastered word', () {
      final intervention = guardian.assessConfidence(
        consecutiveErrors: 3,
        hintUsageInSession: 0,
        micFailureCount: 0,
        masteries: sampleMasteries,
      );

      expect(intervention.type, equals(ConfidenceInterventionType.provideEasyWin));
      expect(intervention.recommendedVocabularyId, equals('vocab_elephant'));
      expect(intervention.pipEncouragingDialogue, isNotEmpty);
    });

    test('2. Multiple mic failures triggers switchActivityType to listening/tapping', () {
      final intervention = guardian.assessConfidence(
        consecutiveErrors: 0,
        hintUsageInSession: 0,
        micFailureCount: 2,
        masteries: sampleMasteries,
      );

      expect(intervention.type, equals(ConfidenceInterventionType.switchActivityType));
      expect(intervention.reason, contains('Microphone'));
    });

    test('3. Heavy hint usage in session triggers pipDemonstration', () {
      final intervention = guardian.assessConfidence(
        consecutiveErrors: 1,
        hintUsageInSession: 4,
        micFailureCount: 0,
        masteries: sampleMasteries,
      );

      expect(intervention.type, equals(ConfidenceInterventionType.pipDemonstration));
    });

    test('4. Normal play without struggle yields ConfidenceInterventionType.none', () {
      final intervention = guardian.assessConfidence(
        consecutiveErrors: 0,
        hintUsageInSession: 1,
        micFailureCount: 0,
        masteries: sampleMasteries,
      );

      expect(intervention.type, equals(ConfidenceInterventionType.none));
    });
  });
}
