import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_learning_session_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_vocabulary_mastery_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/controllers/session_runtime_controller.dart';

void main() {
  group('Session Interruption & Resume Stress Validation', () {
    late MockLearningSessionRepository sessionRepo;
    late MockVocabularyMasteryRepository masteryRepo;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    LearningSession buildSampleSession() {
      return LearningSession(
        sessionId: 'session_resume_101',
        childId: 'child_ayaan',
        worldId: 'world_animal',
        primaryGoal: 'Learn animals',
        activities: const [
          SessionActivity(
            activityId: 'act_1',
            title: 'Warm-up',
            activityType: SessionActivityType.warmUp,
            worldId: 'world_animal',
            pedagogicalIntent: 'Warmup',
            pipPrompt: 'Prompt 1',
            routePath: '/activity/vocabulary',
          ),
          SessionActivity(
            activityId: 'act_2',
            title: 'Game',
            activityType: SessionActivityType.interactiveGame,
            worldId: 'world_animal',
            pedagogicalIntent: 'Game',
            pipPrompt: 'Prompt 2',
            routePath: '/activity/game',
          ),
        ],
        createdAt: now,
      );
    }

    setUp(() {
      sessionRepo = MockLearningSessionRepository();
      masteryRepo = MockVocabularyMasteryRepository();
    });

    test('Session interrupted mid-way resumes at the exact next uncompleted activity', () async {
      var controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
      );

      final session = buildSampleSession();
      await controller.startSession(session);

      // Complete act_1
      await controller.completeActivity(activityId: 'act_1', score: 1.0);
      expect(controller.currentState.session?.completedCount, equals(1));
      expect(controller.currentState.session?.currentActivity?.activityId, equals('act_2'));

      // Simulate App Kill / Interruption: create fresh controller and load from repo
      controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
      );
      await controller.loadActiveSession('child_ayaan');

      final resumedSession = controller.currentState.session;
      expect(resumedSession, isNotNull);
      expect(resumedSession!.status, equals(SessionStatus.inProgress));
      expect(resumedSession.completedCount, equals(1));
      expect(resumedSession.currentActivity?.activityId, equals('act_2'));
      expect(resumedSession.activities.first.isCompleted, isTrue);
      expect(resumedSession.activities.last.isCompleted, isFalse);
    });

    test('Completed session does not revert to active on reload', () async {
      var controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
      );

      final session = buildSampleSession();
      await controller.startSession(session);
      await controller.completeActivity(activityId: 'act_1', score: 1.0);
      await controller.completeActivity(activityId: 'act_2', score: 1.0);
      expect(controller.currentState.session?.isCompleted, isTrue);

      // Simulate restart
      controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
      );
      await controller.loadActiveSession('child_ayaan');

      // Completed session is no longer active
      expect(controller.currentState.session, isNull);
    });
  });
}
