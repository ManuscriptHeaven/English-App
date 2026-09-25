import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_learning_session_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/data/mock_vocabulary_mastery_repository.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/learning_session.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/adaptive/session_activity.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/controllers/session_runtime_controller.dart';

void main() {
  group('Reward Farming & Idempotency Stress Validation', () {
    late MockLearningSessionRepository sessionRepo;
    late MockVocabularyMasteryRepository masteryRepo;
    final now = DateTime(2026, 9, 10, 8, 0, 0);

    setUp(() {
      sessionRepo = MockLearningSessionRepository();
      masteryRepo = MockVocabularyMasteryRepository();
    });

    test('Rapid duplicate activity completion calls cannot farm coins or XP', () async {
      final controller = SessionRuntimeController(
        sessionRepository: sessionRepo,
        masteryRepository: masteryRepo,
      );

      final session = LearningSession(
        sessionId: 'session_farm_test',
        childId: 'child_ayaan',
        worldId: 'world_animal',
        primaryGoal: 'Test Goal',
        activities: const [
          SessionActivity(
            activityId: 'act_target',
            title: 'Test Activity',
            activityType: SessionActivityType.interactiveGame,
            worldId: 'world_animal',
            pedagogicalIntent: 'Testing',
            pipPrompt: 'Tap!',
            routePath: '/activity/game',
          ),
        ],
        createdAt: now,
      );

      await controller.startSession(session);

      // Call completion 10 times in rapid succession
      for (int i = 0; i < 10; i++) {
        await controller.completeActivity(activityId: 'act_target', score: 1.0);
      }

      // Coins: 5 (act_target) + 20 (session complete) = 25
      // XP: 15 (act_target) + 50 (session complete) = 65
      // Stars: 3
      expect(controller.currentState.totalSessionCoinsEarned, equals(25));
      expect(controller.currentState.totalSessionXpEarned, equals(65));
      expect(controller.currentState.totalSessionStarsEarned, equals(3));
    });
  });
}
