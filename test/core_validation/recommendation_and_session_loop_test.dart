import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Recommendation & Session Loop Detection Validation', () {
    late LearningSessionOrchestrator orchestrator;
    late MasteryEngine masteryEngine;
    final graph = CurriculumGraph.standard();
    final world = const World(
      id: 'world_animal',
      title: 'Animal Adventure',
      theme: 'animal',
      description: 'Animal world',
      bannerAssetPath: 'assets/banner.png',
      primaryColorHex: '0xFF66BB6A',
      orderIndex: 1,
      metadata: ContentMetadata(
        learningObjective: 'Animals',
        worldId: 'world_animal',
      ),
      chapters: [],
    );

    const child = ChildProfile(
      id: 'child_ayaan',
      parentId: 'parent_1',
      name: 'Ayaan',
      age: 6,
      avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
      unlockedWorldIds: ['world_animal'],
    );

    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      orchestrator = LearningSessionOrchestrator(clock: () => now);
      masteryEngine = const MasteryEngine();
    });

    test('Session generator adapts targets as child learns instead of getting trapped in a loop', () {
      var currentMasteries = <VocabularyMastery>[];
      final targetHistory = <List<String>>[];

      // Run 5 progression cycles
      for (int i = 0; i < 5; i++) {
        final session = orchestrator.assembleSession(
          child: child,
          masteries: currentMasteries,
          graph: graph,
          currentWorld: world,
          now: now.add(Duration(days: i)),
        );

        targetHistory.add(session.targetVocabularyIds);

        // Child practices and masters target words from this session
        for (final targetId in session.targetVocabularyIds) {
          final existing = currentMasteries.where((m) => m.vocabularyId == targetId).firstOrNull;
          var updated = existing ?? VocabularyMastery.initial(
            childId: child.id,
            vocabularyId: targetId,
            word: targetId,
            now: now,
          );

          // Simulate 4 successful independent recall attempts to master the word
          for (int step = 0; step < 4; step++) {
            updated = masteryEngine.recordAttempt(
              currentMastery: updated,
              evidence: LearningEvidence(
                childId: child.id,
                vocabularyId: targetId,
                word: targetId,
                isCorrect: true,
                isIndependentRecall: true,
                timestamp: now.add(Duration(days: i, hours: step)),
              ),
            );
          }

          currentMasteries = [
            ...currentMasteries.where((m) => m.vocabularyId != targetId),
            updated,
          ];
        }
      }

      // Assert that targets changed over time as words were mastered
      expect(targetHistory.first, isNot(equals(targetHistory.last)));
      final uniqueTargetSets = targetHistory.map((t) => t.join(',')).toSet();
      expect(uniqueTargetSets.length, greaterThanOrEqualTo(3));
    });
  });
}
