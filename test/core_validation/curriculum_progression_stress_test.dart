import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_progression_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_validator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';

void main() {
  group('Curriculum Progression & Graph Integrity Stress Tests', () {
    late CurriculumGraph graph;
    late CurriculumProgressionEngine progressionEngine;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    const child = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
      unlockedWorldIds: ['world_animal'],
    );

    setUp(() {
      graph = CurriculumGraph.standard();
      progressionEngine = const CurriculumProgressionEngine();
    });

    test('1. Production CurriculumGraph passes static validator with 0 errors and 0 cycles', () {
      final report = CurriculumValidator.validate(graph);
      expect(report.isValid, isTrue);
      expect(report.errors, isEmpty);
      expect(graph.allConcepts.length, greaterThanOrEqualTo(6));
    });

    test('2. Multi-stage prerequisite tree unlocks sequentially as mastery is achieved', () {
      // Stage 0: Zero masteries -> both 'vocab_big' and 'vocab_small' are locked
      var state = progressionEngine.getProgressionState(
        child: child,
        masteries: const [],
        graph: graph,
      );
      expect(state.lockedConceptIds, contains('vocab_big'));
      expect(state.lockedConceptIds, contains('vocab_small'));

      // Stage 1: Master 'vocab_elephant' -> unlocks 'vocab_big', 'vocab_small' stays locked
      final elephantMastery = VocabularyMastery(
        childId: child.id,
        vocabularyId: 'vocab_elephant',
        word: 'Elephant',
        exposureCount: 8,
        correctAttempts: 8,
        incorrectAttempts: 0,
        consecutiveCorrect: 8,
        lastSeenAt: now,
        nextReviewAt: now.add(const Duration(days: 14)),
        masteryScore: 0.95,
        confidenceLevel: 1.0,
        currentLearningState: VocabularyLearningState.mastered,
      );

      state = progressionEngine.getProgressionState(
        child: child,
        masteries: [elephantMastery],
        graph: graph,
      );
      expect(state.accessibleConceptIds, contains('vocab_big'));
      expect(state.lockedConceptIds, contains('vocab_small'));

      // Stage 2: Master 'vocab_big' -> unlocks 'vocab_small'
      final bigMastery = VocabularyMastery(
        childId: child.id,
        vocabularyId: 'vocab_big',
        word: 'Big',
        exposureCount: 8,
        correctAttempts: 8,
        incorrectAttempts: 0,
        consecutiveCorrect: 8,
        lastSeenAt: now,
        nextReviewAt: now.add(const Duration(days: 14)),
        masteryScore: 0.92,
        confidenceLevel: 0.95,
        currentLearningState: VocabularyLearningState.mastered,
      );

      state = progressionEngine.getProgressionState(
        child: child,
        masteries: [elephantMastery, bigMastery],
        graph: graph,
      );
      expect(state.accessibleConceptIds, contains('vocab_small'));
      expect(state.lockedConceptIds, isNot(contains('vocab_small')));
    });
  });
}
