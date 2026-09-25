import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/curriculum_graph.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session_orchestrator.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/spaced_review_scheduler.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/vocabulary_mastery.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Spaced Review Scheduling & Review Queue Stress Test', () {
    late MasteryEngine engine;
    late SpacedReviewScheduler scheduler;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      engine = const MasteryEngine();
      scheduler = const SpacedReviewScheduler();
    });

    test('1. Confirms scheduled review intervals match production configuration', () {
      // 1. Initial / Introduced state -> 12h
      final intro = engine.recordAttempt(
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_elephant',
          word: 'Elephant',
          isCorrect: true,
          usedHint: true, // keeps in introduced/learning
          timestamp: now,
        ),
      );
      expect(intro.nextReviewAt.difference(now).inHours, inInclusiveRange(12, 24));

      // 2. Practicing state -> 2 days
      final practicing = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_lion',
        word: 'Lion',
        exposureCount: 4,
        correctAttempts: 2,
        incorrectAttempts: 1,
        consecutiveCorrect: 1,
        lastSeenAt: now,
        nextReviewAt: now,
        masteryScore: 0.50,
        confidenceLevel: 0.60,
        currentLearningState: VocabularyLearningState.practicing,
      );
      final practiced = engine.recordAttempt(
        currentMastery: practicing,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_lion',
          word: 'Lion',
          isCorrect: true,
          timestamp: now,
        ),
      );
      expect(practiced.nextReviewAt.difference(now).inDays, inInclusiveRange(2, 5));

      // 3. Familiar state -> 5 days
      final familiar = VocabularyMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_cat',
        word: 'Cat',
        exposureCount: 8,
        correctAttempts: 5,
        incorrectAttempts: 1,
        consecutiveCorrect: 3,
        lastSeenAt: now,
        nextReviewAt: now,
        masteryScore: 0.75,
        confidenceLevel: 0.85,
        currentLearningState: VocabularyLearningState.familiar,
      );
      final familiarResult = engine.recordAttempt(
        currentMastery: familiar,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          isCorrect: true,
          timestamp: now,
        ),
      );
      expect(familiarResult.nextReviewAt.difference(now).inDays, inInclusiveRange(5, 14));

      // 4. Incorrect answer -> 6h
      final errorResult = engine.recordAttempt(
        currentMastery: familiar,
        evidence: LearningEvidence(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_cat',
          word: 'Cat',
          isCorrect: false,
          timestamp: now,
        ),
      );
      expect(errorResult.nextReviewAt.difference(now).inHours, equals(6));
    });

    test('2. Large review queue (80 overdue words) does not crash or starve session composition', () {
      const child = ChildProfile(
        id: 'child_ayaan',
        parentId: 'parent_1',
        name: 'Ayaan',
        age: 6,
        avatar: Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
        unlockedWorldIds: ['world_animal'],
      );

      // Construct 80 overdue words
      final largeMasteries = List.generate(80, (index) {
        return VocabularyMastery(
          childId: 'child_ayaan',
          vocabularyId: 'vocab_overdue_$index',
          word: 'Word $index',
          exposureCount: 3,
          correctAttempts: 2,
          incorrectAttempts: 1,
          consecutiveCorrect: 1,
          lastSeenAt: now.subtract(const Duration(days: 10)),
          nextReviewAt: now.subtract(Duration(days: 1 + (index % 5))), // all overdue!
          masteryScore: 0.40,
          confidenceLevel: 0.60,
          currentLearningState: VocabularyLearningState.reviewDue,
        );
      });

      final dueList = scheduler.getDueForReview(largeMasteries, now);
      expect(dueList.length, equals(80));

      final queue = scheduler.getPrioritizedReviewQueue(largeMasteries, now);
      expect(queue.length, equals(80));

      // Assemble session with 80 overdue items
      final orchestrator = LearningSessionOrchestrator(clock: () => now);
      final session = orchestrator.assembleSession(
        child: child,
        masteries: largeMasteries,
        graph: CurriculumGraph.standard(),
        currentWorld: const World(
          id: 'world_animal',
          title: 'Animal Adventure',
          theme: 'animal',
          description: 'Animals',
          bannerAssetPath: 'assets/banner.png',
          primaryColorHex: '0xFF66BB6A',
          orderIndex: 1,
          metadata: ContentMetadata(
            learningObjective: 'Animals',
            worldId: 'world_animal',
          ),
          chapters: [],
        ),
        dailyScreenTimeLimitMinutes: 15,
        now: now,
      );

      // Session must NOT try to fit 80 activities (max activities is capped by session length)
      expect(session.activities.length, lessThanOrEqualTo(5));
      expect(session.reviewVocabularyIds, isNotEmpty);
      expect(session.reviewVocabularyIds.length, lessThanOrEqualTo(4));
    });
  });
}
