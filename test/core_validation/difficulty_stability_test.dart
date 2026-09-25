import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/difficulty_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';

void main() {
  group('Difficulty Engine Stability & Transition Timeline Tests', () {
    late DifficultyEngine difficultyEngine;
    late MasteryEngine masteryEngine;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      difficultyEngine = const DifficultyEngine();
      masteryEngine = const MasteryEngine();
    });

    test('1. Difficulty properties adhere strictly to child-safe constraints', () {
      expect(AdaptiveDifficultyTier.support.choiceCount, equals(2));
      expect(AdaptiveDifficultyTier.easy.choiceCount, equals(3));
      expect(AdaptiveDifficultyTier.standard.choiceCount, equals(3));
      expect(AdaptiveDifficultyTier.challenge.choiceCount, equals(4));

      expect(AdaptiveDifficultyTier.support.autoHintDelaySeconds, equals(4));
      expect(AdaptiveDifficultyTier.challenge.autoHintDelaySeconds, equals(20));
    });

    test('2. Difficulty adapts smoothly without oscillating after isolated mistakes', () {
      var mastery = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_cat',
        word: 'Cat',
        exposureCount: 10,
        correctAttempts: 9,
        incorrectAttempts: 1,
        consecutiveCorrect: 6,
        lastSeenAt: now,
        nextReviewAt: now.add(const Duration(days: 5)),
        masteryScore: 0.82,
        confidenceLevel: 0.90,
        currentLearningState: VocabularyLearningState.mastered,
      );

      final tierBefore = difficultyEngine.resolveDifficulty(
        childAge: 7,
        recentMasteries: [
          mastery,
          mastery.copyWith(vocabularyId: 'vocab_elephant'),
          mastery.copyWith(vocabularyId: 'vocab_lion'),
        ],
        consecutiveCorrect: 6,
        consecutiveErrors: 0,
      );
      expect(tierBefore, equals(AdaptiveDifficultyTier.challenge));

      // Single mistake: child answers 1 question wrong
      mastery = masteryEngine.recordAttempt(
        currentMastery: mastery,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          isCorrect: false,
          timestamp: now.add(const Duration(minutes: 5)),
        ),
      );

      final tierAfterSingleMistake = difficultyEngine.resolveDifficulty(
        childAge: 7,
        recentMasteries: [mastery],
        consecutiveCorrect: 0,
        consecutiveErrors: 1,
      );

      // Must NOT plummet all the way to support (2 choices) after a single error
      expect(tierAfterSingleMistake, isNot(equals(AdaptiveDifficultyTier.support)));
      expect(tierAfterSingleMistake, isIn([AdaptiveDifficultyTier.standard, AdaptiveDifficultyTier.easy]));
    });

    test('3. Struggling learner receives gentle support tier without premature escalation', () {
      final strugglingMasteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          exposureCount: 6,
          correctAttempts: 1,
          incorrectAttempts: 5,
          consecutiveCorrect: 0,
          consecutiveIncorrect: 3,
          lastSeenAt: now,
          nextReviewAt: now,
          masteryScore: 0.20,
          confidenceLevel: 0.35,
          currentLearningState: VocabularyLearningState.struggling,
        ),
      ];

      final tier = difficultyEngine.resolveDifficulty(
        childAge: 5,
        recentMasteries: strugglingMasteries,
        consecutiveErrors: 2,
      );

      expect(tier, equals(AdaptiveDifficultyTier.support));
      expect(tier.choiceCount, equals(2));
      expect(tier.autoHintDelaySeconds, equals(4));
    });
  });
}
