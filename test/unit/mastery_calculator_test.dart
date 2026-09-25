import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/content_mastery.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/mastery_calculator.dart';

void main() {
  group('MasteryCalculator Deterministic Scoring Tests', () {
    final now = DateTime(2026, 8, 22, 10, 0);

    test('Increases mastery smoothly on first-time correct answer', () {
      final signal = LearningSignal(
        id: 'sig_1',
        childId: 'child_ayaan',
        skill: SkillType.vocabulary,
        contentId: 'vocab_elephant',
        activityId: 'activity_animal_hunt',
        worldId: 'world_animal',
        score: 1.0,
        accuracy: 1.0,
        attempts: 1,
        timestamp: now,
      );

      final mastery = MasteryCalculator.updateContentMastery(
        signal: signal,
        now: now,
      );

      expect(mastery.masteryScore, greaterThan(0.0));
      expect(mastery.masteryScore, lessThanOrEqualTo(0.20));
      expect(mastery.attemptCount, equals(1));
      expect(mastery.correctCount, equals(1));
      expect(mastery.incorrectCount, equals(0));
    });

    test('Provides bonus for repeated successes without jumping wildly', () {
      var current = ContentMastery(
        contentId: 'vocab_cat',
        skill: SkillType.vocabulary,
        masteryScore: 0.60,
        confidence: 0.70,
        attemptCount: 3,
        correctCount: 3,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 3)),
      );

      final signal = LearningSignal(
        id: 'sig_2',
        childId: 'child_ayaan',
        skill: SkillType.vocabulary,
        contentId: 'vocab_cat',
        activityId: 'activity_animal_hunt',
        worldId: 'world_animal',
        score: 1.0,
        attempts: 1,
        timestamp: now,
      );

      final updated = MasteryCalculator.updateContentMastery(
        currentMastery: current,
        signal: signal,
        now: now,
      );

      expect(updated.masteryScore, greaterThan(0.60));
      expect(updated.masteryScore, lessThan(0.85)); // Smooth, predictable growth
      expect(updated.correctCount, equals(4));
    });

    test('Decreases score appropriately on errors without dropping to zero', () {
      var current = ContentMastery(
        contentId: 'grammar_is_are',
        skill: SkillType.grammar,
        masteryScore: 0.70,
        confidence: 0.70,
        attemptCount: 3,
        correctCount: 2,
        incorrectCount: 1,
        lastAttemptAt: now.subtract(const Duration(days: 1)),
        nextReviewAt: now.add(const Duration(days: 3)),
      );

      final signal = LearningSignal(
        id: 'sig_3',
        childId: 'child_ayaan',
        skill: SkillType.grammar,
        contentId: 'grammar_is_are',
        activityId: 'activity_grammar_is_are',
        worldId: 'world_animal',
        score: 0.0,
        attempts: 2,
        timestamp: now,
      );

      final updated = MasteryCalculator.updateContentMastery(
        currentMastery: current,
        signal: signal,
        now: now,
      );

      expect(updated.masteryScore, lessThan(0.70));
      expect(updated.masteryScore, greaterThan(0.50));
      expect(updated.incorrectCount, equals(2));
    });

    test('Applies gradual confidence and score decay when review is overdue', () {
      final overdueMastery = ContentMastery(
        contentId: 'vocab_elephant',
        skill: SkillType.vocabulary,
        masteryScore: 0.80,
        confidence: 0.85,
        attemptCount: 4,
        correctCount: 4,
        incorrectCount: 0,
        lastAttemptAt: now.subtract(const Duration(days: 15)),
        nextReviewAt: now.subtract(const Duration(days: 8)), // 8 days overdue
      );

      final decayed = MasteryCalculator.applyTimeDecay(
        mastery: overdueMastery,
        currentDate: now,
      );

      expect(decayed.confidence, lessThan(overdueMastery.confidence));
      expect(decayed.masteryScore, lessThanOrEqualTo(overdueMastery.masteryScore));
    });

    test('Aggregates content masteries into skill-level masteries accurately', () {
      final items = [
        ContentMastery(
          contentId: 'vocab_cat',
          skill: SkillType.vocabulary,
          masteryScore: 0.90,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 14)),
        ),
        ContentMastery(
          contentId: 'vocab_elephant',
          skill: SkillType.vocabulary,
          masteryScore: 0.30,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 1)),
        ),
        ContentMastery(
          contentId: 'grammar_is_are',
          skill: SkillType.grammar,
          masteryScore: 0.80,
          lastAttemptAt: now,
          nextReviewAt: now.add(const Duration(days: 7)),
        ),
      ];

      final skills = MasteryCalculator.calculateSkillMasteries(
        contentMasteries: items,
        now: now,
      );

      final vocabSkill = skills[SkillType.vocabulary]!;
      expect(vocabSkill.score, equals(0.60)); // (0.90 + 0.30) / 2
      expect(vocabSkill.totalItemsTracked, equals(2));
      expect(vocabSkill.masteredItemsCount, equals(1));
      expect(vocabSkill.weakItemsCount, equals(1));

      final grammarSkill = skills[SkillType.grammar]!;
      expect(grammarSkill.score, equals(0.80));
    });
  });
}
