import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_session.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_session_summary.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_tutor_service.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/mock_ai_provider.dart';

void main() {
  group('AI Session Complete Lifecycle Tests', () {
    late AiTutorService tutorService;
    late AiCurriculumContext context;
    late AiParentSettings settings;

    setUp(() {
      tutorService = AiTutorService(
        provider: const MockAiProvider(simulateLatency: false),
      );

      context = AiCurriculumContext.forChild(
        childAge: 6,
        currentWorldId: 'world_food',
        currentLessonId: 'activity_food_vocab',
        mode: AiMode.vocabularyTalk,
        targetSkill: SkillType.vocabulary,
        targetVocabulary: const ['apple', 'banana', 'orange'],
        conversationObjective: 'Learn healthy fruits',
      );

      settings = const AiParentSettings(
        aiTutorEnabled: true,
        dailyTurnsLimit: 5,
        dailyMinutesLimit: 10,
      );
    });

    test('Full lifecycle: start -> turns -> signal generation -> end -> educational summary', () async {
      // 1. Start Session
      final session = tutorService.startSession(
        childId: 'child_ayaan',
        context: context,
        settings: settings,
      );

      expect(session.childId, equals('child_ayaan'));
      expect(session.completed, isFalse);
      expect(session.turnCount, equals(0));

      // 2. Turn 1 (Spoken)
      final turn1 = await tutorService.processChildTurn(
        sessionId: session.id,
        childId: 'child_ayaan',
        childInput: 'I see a red apple',
        context: context,
        settings: settings,
        turnHistory: const [],
        inputType: AiInputType.speech,
      );

      expect(turn1.text, contains('apple'));
      expect(tutorService.emittedSignals.length, equals(1));
      expect(tutorService.emittedSignals.first.skill, equals(SkillType.vocabulary));

      // 3. Turn 2 (Spoken)
      final turn2 = await tutorService.processChildTurn(
        sessionId: session.id,
        childId: 'child_ayaan',
        childInput: 'Banana is sweet',
        context: context,
        settings: settings,
        turnHistory: ['child: I see a red apple', 'pip: Great apple!'],
        inputType: AiInputType.speech,
      );

      expect(turn2.text, isNotEmpty);
      expect(tutorService.emittedSignals.length, equals(2));

      // 4. End Session & Validate Summary
      final updatedSession = session.copyWith(
        turnCount: 2,
        spokenTurns: 2,
        successfulTurns: 2,
      );

      final summary = tutorService.endSession(
        updatedSession,
        reason: AiSessionCompletionReason.objectiveMet,
      );

      expect(summary.sessionId, equals(session.id));
      expect(summary.totalTurns, equals(2));
      expect(summary.spokenTurns, equals(2));
      expect(summary.speakingAccuracy, equals(1.0));
      expect(summary.starsEarned, equals(3));
      expect(summary.childTitle, contains('Super Chat'));
      expect(summary.growthRecommendation, contains('Excellent speaking confidence'));
      expect(tutorService.completedSessions.length, equals(1));
    });

    test('AiSessionSummary separates child praise from parent diagnostic recommendations', () {
      final summaryStruggling = AiSessionSummary.generate(
        sessionId: 'session_struggle',
        childId: 'child_ayaan',
        mode: AiMode.grammarTalk,
        totalTurns: 4,
        spokenTurns: 2,
        successfulTurns: 1,
        targetVocabulary: const ['is', 'are'],
        repeatedMistakes: const ['is/are agreement'],
      );

      // Child gets encouraging, gentle praise
      expect(summaryStruggling.childTitle, contains('Good Effort'));
      expect(summaryStruggling.childEncouragement, contains('keep practicing'));

      // Parent receives targeted growth recommendation
      expect(summaryStruggling.speakingAccuracy, equals(0.25));
      expect(summaryStruggling.needsPracticeItems, contains('is/are agreement'));
      expect(summaryStruggling.growthRecommendation, contains('practicing "is/are agreement"'));
    });
  });
}
