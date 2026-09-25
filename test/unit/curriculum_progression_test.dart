import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_progression_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';

void main() {
  group('CurriculumProgressionEngine Tests', () {
    late CurriculumGraph graph;
    late CurriculumProgressionEngine engine;
    late ChildProfile testChild;

    setUp(() {
      graph = CurriculumGraph.standard();
      engine = const CurriculumProgressionEngine();
      testChild = const ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );
    });

    test('Dependent concepts with unmet prerequisites remain locked', () {
      // In standard graph, 'vocab_small' requires 'vocab_big', and 'vocab_big' requires 'vocab_elephant'.
      // With zero masteries, 'vocab_small' and 'vocab_big' should be locked.
      final state = engine.getProgressionState(
        child: testChild,
        masteries: const [],
        graph: graph,
      );

      expect(state.lockedConceptIds, contains('vocab_small'));
      expect(state.lockedConceptIds, contains('vocab_big'));
      expect(state.accessibleConceptIds, contains('vocab_elephant'));
      expect(state.accessibleConceptIds, contains('vocab_lion'));
    });

    test('Mastering prerequisite unlocks dependent concept into accessible list', () {
      final masteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          exposureCount: 6,
          correctAttempts: 6,
          incorrectAttempts: 0,
          consecutiveCorrect: 6,
          lastSeenAt: DateTime.now(),
          nextReviewAt: DateTime.now().add(const Duration(days: 7)),
          masteryScore: 0.90,
          confidenceLevel: 0.95,
          currentLearningState: VocabularyLearningState.mastered,
        ),
      ];

      final state = engine.getProgressionState(
        child: testChild,
        masteries: masteries,
        graph: graph,
      );

      expect(state.masteredConceptIds, contains('vocab_elephant'));
      expect(state.lockedConceptIds, isNot(contains('vocab_big')));
      expect(state.accessibleConceptIds, contains('vocab_big'));
    });

    test('getNextRecommendedConcepts prioritizes in-progress concepts over unstarted', () {
      final masteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          exposureCount: 2,
          correctAttempts: 1,
          incorrectAttempts: 1,
          consecutiveCorrect: 1,
          lastSeenAt: DateTime.now(),
          nextReviewAt: DateTime.now().add(const Duration(hours: 12)),
          masteryScore: 0.45,
          confidenceLevel: 0.60,
          currentLearningState: VocabularyLearningState.learning,
        ),
      ];

      final recommended = engine.getNextRecommendedConcepts(
        child: testChild,
        masteries: masteries,
        graph: graph,
      );

      expect(recommended.first, equals('vocab_lion'));
    });

    test('explainConceptStatus provides accurate explainable feedback for parents and educators', () {
      final masteries = [
        VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          exposureCount: 8,
          correctAttempts: 8,
          incorrectAttempts: 0,
          consecutiveCorrect: 8,
          lastSeenAt: DateTime.now(),
          nextReviewAt: DateTime.now().add(const Duration(days: 14)),
          masteryScore: 0.95,
          confidenceLevel: 1.0,
          currentLearningState: VocabularyLearningState.mastered,
        ),
      ];

      final explanationMastered = engine.explainConceptStatus(
        'vocab_elephant',
        masteries: masteries,
        graph: graph,
      );
      expect(explanationMastered, contains('Mastered'));

      final explanationLocked = engine.explainConceptStatus(
        'vocab_small',
        masteries: const [],
        graph: graph,
      );
      expect(explanationLocked, contains('Locked: Requires mastering prerequisite'));

      final explanationReady = engine.explainConceptStatus(
        'vocab_elephant',
        masteries: const [],
        graph: graph,
      );
      expect(explanationReady, contains('Ready to explore'));
    });
  });
}
