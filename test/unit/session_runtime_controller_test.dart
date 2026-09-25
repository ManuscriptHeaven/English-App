import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_learning_session_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_vocabulary_mastery_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/mastery_engine.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_pip_guide.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/controllers/session_runtime_controller.dart';

void main() {
  group('SessionRuntimeController Tests', () {
    late MockLearningSessionRepository sessionRepo;
    late MockVocabularyMasteryRepository masteryRepo;
    late SessionRuntimeController controller;
    final testNow = DateTime(2026, 9, 10, 10, 0, 0);

    LearningSession buildSampleSession({String childId = 'child_ayaan'}) {
      return LearningSession(
        sessionId: 'session_${childId}_123',
        childId: childId,
        worldId: 'world_animal',
        primaryGoal: 'Learn animal words',
        targetVocabularyIds: const ['vocab_elephant'],
        activities: const [
          SessionActivity(
            activityId: 'act_1',
            title: 'Warm-up',
            activityType: SessionActivityType.warmUp,
            worldId: 'world_animal',
            targetVocabularyIds: ['vocab_elephant'],
            pedagogicalIntent: 'Warm up listening',
            pipPrompt: 'Spot the elephant!',
            routePath: '/activity/vocabulary',
          ),
          SessionActivity(
            activityId: 'act_2',
            title: 'Animal Hunt',
            activityType: SessionActivityType.interactiveGame,
            worldId: 'world_animal',
            targetVocabularyIds: ['vocab_elephant'],
            pedagogicalIntent: 'Game recognition',
            pipPrompt: 'Tap the elephant!',
            routePath: '/activity/game',
          ),
        ],
        createdAt: testNow,
      );
    }

    setUp(() {
      sessionRepo = MockLearningSessionRepository();
      masteryRepo = MockVocabularyMasteryRepository();
      controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
        masteryEngine: const MasteryEngine(),
        pipGuide: const SessionPipGuide(),
      );
    });

    test('1. Lifecycle: start, pause, resume session transitions state and persists', () async {
      final session = buildSampleSession();

      // Start session
      await controller.startSession(session);
      expect(controller.currentState.session?.status, equals(SessionStatus.inProgress));
      expect(controller.currentState.hasActiveSession, isTrue);

      final persistedAfterStart = await sessionRepo.getActiveSessionForChild('child_ayaan');
      expect(persistedAfterStart?.status, equals(SessionStatus.inProgress));

      // Pause session
      await controller.pauseSession();
      expect(controller.currentState.session?.status, equals(SessionStatus.paused));

      // Resume session
      await controller.resumeSession();
      expect(controller.currentState.session?.status, equals(SessionStatus.inProgress));
    });

    test('2. Reward idempotency: repeated activity completion does not farm rewards', () async {
      final session = buildSampleSession();
      await controller.startSession(session);

      // First activity completion
      await controller.completeActivity(
        activityId: 'act_1',
        score: 1.0,
        isCorrect: true,
      );

      final coinsAfterFirst = controller.currentState.totalSessionCoinsEarned;
      final xpAfterFirst = controller.currentState.totalSessionXpEarned;
      expect(coinsAfterFirst, equals(5));
      expect(xpAfterFirst, equals(15));
      expect(
        controller.currentState.session?.isRewardGranted('reward_act_act_1_${session.sessionId}'),
        isTrue,
      );

      // Repeat completion of act_1 (e.g. rapid taps or network retry)
      await controller.completeActivity(
        activityId: 'act_1',
        score: 1.0,
        isCorrect: true,
      );

      // Rewards must remain unchanged (anti-farming protection)
      expect(controller.currentState.totalSessionCoinsEarned, equals(coinsAfterFirst));
      expect(controller.currentState.totalSessionXpEarned, equals(xpAfterFirst));
    });

    test('3. Session completion grants final summary and idempotent bonus rewards', () async {
      final session = buildSampleSession();
      await controller.startSession(session);

      // Complete act_1
      await controller.completeActivity(activityId: 'act_1', score: 1.0);

      // Complete act_2 (final activity)
      await controller.completeActivity(activityId: 'act_2', score: 1.0);

      final state = controller.currentState;
      expect(state.session?.isCompleted, isTrue);
      expect(state.session?.status, equals(SessionStatus.completed));
      expect(state.lastCompletedSummary, isNotNull);
      expect(state.lastCompletedSummary?.completedActivitiesCount, equals(2));
      expect(state.lastCompletedSummary?.starsEarned, greaterThanOrEqualTo(2));

      // Final bonus rewards added (5 + 5 from activities + 20 from completion = 30)
      expect(state.totalSessionCoinsEarned, equals(30));
      expect(state.totalSessionXpEarned, equals(80)); // 15 + 15 + 50
      expect(state.totalSessionStarsEarned, equals(3));
    });

    test('4. Vocabulary mastery is updated with context source weight on activity completion', () async {
      final session = buildSampleSession();
      await controller.startSession(session);

      // Existing elephant mastery is at 0.65 in mock repo
      final prevMastery = await masteryRepo.getMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
      );
      final prevScore = prevMastery?.masteryScore ?? 0.0;

      // Complete with spoken production evidence source
      await controller.completeActivity(
        activityId: 'act_1',
        score: 1.0,
        isCorrect: true,
        source: LearningEvidenceSource.spokenProduction,
      );

      final updatedMastery = await masteryRepo.getMastery(
        childId: 'child_ayaan',
        vocabularyId: 'vocab_elephant',
      );

      expect(updatedMastery, isNotNull);
      expect(updatedMastery!.masteryScore, greaterThan(prevScore));
      expect(updatedMastery.correctAttempts, equals((prevMastery?.correctAttempts ?? 0) + 1));
    });

    test('5. Abandoning session marks status as abandoned', () async {
      final session = buildSampleSession();
      await controller.startSession(session);
      await controller.abandonSession();

      expect(controller.currentState.session?.status, equals(SessionStatus.abandoned));
      final persisted = await sessionRepo.getActiveSessionForChild('child_ayaan');
      expect(persisted, isNull); // abandoned is no longer an active session
    });
  });
}
