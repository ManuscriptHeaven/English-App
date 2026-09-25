import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/recommendation.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/adventure_recommendation_engine.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/world.dart';

void main() {
  group('Adventure Brain <-> Pip Bidirectional Integration Tests', () {
    late MockWorldRepository worldRepo;
    late World worldAnimal;

    setUp(() async {
      worldRepo = MockWorldRepository();
      worldAnimal = (await worldRepo.getWorldById('world_animal'))!;
    });

    test('AdventureRecommendationEngine.shouldRecommendAi evaluates AI suitability deterministically', () {
      // 1. Speaking practice -> AI recommended
      expect(
        AdventureRecommendationEngine.shouldRecommendAi(
          skill: SkillType.speaking,
          masteryScore: 0.50,
          parentAiEnabled: true,
        ),
        isTrue,
      );

      // 2. Severe foundational struggle (<0.30) -> Deterministic game preferred over AI
      expect(
        AdventureRecommendationEngine.shouldRecommendAi(
          skill: SkillType.vocabulary,
          masteryScore: 0.20,
          parentAiEnabled: true,
        ),
        isFalse,
      );

      // 3. Parent disabled AI -> False
      expect(
        AdventureRecommendationEngine.shouldRecommendAi(
          skill: SkillType.speaking,
          masteryScore: 0.50,
          parentAiEnabled: false,
        ),
        isFalse,
      );

      // 4. Quota exceeded -> False
      expect(
        AdventureRecommendationEngine.shouldRecommendAi(
          skill: SkillType.speaking,
          masteryScore: 0.50,
          parentAiEnabled: true,
          quotaExceeded: true,
        ),
        isFalse,
      );
    });

    test('buildReviewTalkRecommendation creates targeted Review Talk recommendation', () {
      final rec = AdventureRecommendationEngine.buildReviewTalkRecommendation(
        targetTopic: 'is / are singular vs plural',
        world: worldAnimal,
        childFriendlyPrompt: 'Let\'s practice is and are with Pip! 🦜',
      );

      expect(rec.priority, equals(RecommendationPriority.criticalWeakness));
      expect(rec.title, contains('Review with Pip'));
      expect(rec.routePath, contains('talk-with-pip'));
    });

    test('AiCurriculumContext.fromRecommendation hydrates context with ReviewTalk mode', () {
      final rec = Recommendation(
        activityId: 'activity_talk_with_pip',
        activityType: 'speaking',
        worldId: 'world_animal',
        skill: SkillType.speaking,
        reason: 'Practice sentence speaking',
        childFriendlyPrompt: 'Speak with Pip!',
        priority: RecommendationPriority.criticalWeakness,
        estimatedDurationMinutes: 3,
        difficultyLevel: 2,
        isReview: true,
        title: 'Review Talk 🦜',
        subtitle: 'Review',
        routePath: '/talk-with-pip',
      );

      final context = AiCurriculumContext.fromRecommendation(
        recommendation: rec,
        childAge: 6,
        targetVocabulary: const ['elephant', 'water'],
      );

      expect(context.mode, equals(AiMode.speakingChallenge));
      expect(context.targetSkill, equals(SkillType.speaking));
      expect(context.targetVocabulary, contains('elephant'));
      expect(context.maxResponseWords, equals(20)); // Age 6 limit
    });
  });
}
