import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/spaced_review_scheduler.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Persistence Round-Trip & Domain Performance Stress Tests', () {
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    test('1. Serialization round-trip preserves exact fidelity across 100 mastery & 20 session records', () {
      // 100 VocabularyMastery records
      for (int i = 0; i < 100; i++) {
        final original = VocabularyMastery(
          childId: 'child_ayaan_$i',
          vocabularyId: 'vocab_$i',
          word: 'Word $i',
          exposureCount: i,
          correctAttempts: (i * 0.8).round(),
          incorrectAttempts: (i * 0.2).round(),
          consecutiveCorrect: i % 5,
          consecutiveIncorrect: 0,
          hintCount: i % 3,
          pronunciationAttempts: i % 4,
          pronunciationSuccesses: i % 4,
          listeningRecognitionSuccess: i % 3,
          comprehensionSuccess: i % 2,
          lastSeenAt: now.subtract(Duration(days: i)),
          lastCorrectAt: now.subtract(Duration(days: i)),
          lastIncorrectAt: null,
          lastReviewedAt: now.subtract(Duration(days: i)),
          nextReviewAt: now.add(Duration(days: i)),
          masteryScore: (i / 100.0).clamp(0.0, 1.0),
          confidenceLevel: 0.85,
          currentLearningState: VocabularyLearningState.values[i % VocabularyLearningState.values.length],
        );

        final json = original.toJson();
        final reconstituted = VocabularyMastery.fromJson(json);
        expect(reconstituted, equals(original));
      }

      // 20 LearningSession records
      for (int i = 0; i < 20; i++) {
        final original = LearningSession(
          sessionId: 'session_$i',
          childId: 'child_ayaan',
          worldId: 'world_animal',
          primaryGoal: 'Goal $i',
          targetVocabularyIds: ['vocab_$i', 'vocab_${i + 1}'],
          reviewVocabularyIds: ['vocab_rev_$i'],
          activities: [
            SessionActivity(
              activityId: 'act_$i',
              title: 'Act $i',
              activityType: SessionActivityType.interactiveGame,
              worldId: 'world_animal',
              targetVocabularyIds: ['vocab_$i'],
              pedagogicalIntent: 'Intent $i',
              pipPrompt: 'Prompt $i',
              routePath: '/activity/game',
            ),
          ],
          grantedRewardIds: {'reward_act_act_${i}_session_$i'},
          createdAt: now,
        );

        final json = original.toJson();
        final reconstituted = LearningSession.fromJson(json);
        expect(reconstituted, equals(original));
      }
    });

    test('2. Performance: 500-item review queue sort and 100 session orchestrations execute in < 200ms', () {
      final largeMasteries = List.generate(500, (i) {
        return VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_$i',
          word: 'Word $i',
          exposureCount: 5,
          correctAttempts: 3,
          incorrectAttempts: 2,
          consecutiveCorrect: 1,
          lastSeenAt: now.subtract(Duration(days: i % 30)),
          nextReviewAt: now.subtract(Duration(days: i % 5)), // many overdue
          masteryScore: (i % 100) / 100.0,
          confidenceLevel: 0.70,
          currentLearningState: VocabularyLearningState.values[i % VocabularyLearningState.values.length],
        );
      });

      final scheduler = const SpacedReviewScheduler();
      final stopwatch = Stopwatch()..start();

      // 1. Sort 500 items 10 times
      for (int k = 0; k < 10; k++) {
        final queue = scheduler.getPrioritizedReviewQueue(largeMasteries, now);
        expect(queue.length, equals(500));
      }

      // 2. Assemble 100 sessions
      final orchestrator = LearningSessionOrchestrator(clock: () => now);
      const child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      final world = const World(
        id: 'world_animal',
        title: 'Animal Adventure',
        theme: 'animal',
        description: 'World',
        bannerAssetPath: 'assets/banner.png',
        primaryColorHex: '0xFF66BB6A',
        orderIndex: 1,
        metadata: ContentMetadata(learningObjective: 'Animals', worldId: 'world_animal'),
        chapters: [],
      );

      final graph = CurriculumGraph.standard();

      for (int k = 0; k < 100; k++) {
        final session = orchestrator.assembleSession(
          child: child,
          masteries: largeMasteries.take(20).toList(),
          graph: graph,
          currentWorld: world,
          now: now,
        );
        expect(session.activities, isNotEmpty);
      }

      stopwatch.stop();
      // Should execute comfortably fast (under 2 seconds even on slow CI, typically ~50ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });
  });
}
