import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_conversation_turn.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_tutor_service.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_usage_manager.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/mock_ai_provider.dart';

void main() {
  group('AiTutorService Pipeline Tests', () {
    late AiTutorService tutorService;
    late AiCurriculumContext context;
    late AiParentSettings parentSettings;

    setUp(() {
      tutorService = AiTutorService(
        provider: const MockAiProvider(),
        usageManager: AiUsageManager(),
      );

      context = AiCurriculumContext.forChild(
        childAge: 6,
        currentWorldId: 'world_food',
        currentLessonId: 'activity_food_vocab',
        mode: AiMode.vocabularyTalk,
        targetSkill: SkillType.vocabulary,
        targetVocabulary: const ['apple', 'banana', 'milk'],
        conversationObjective: 'Practice fruit vocabulary',
      );

      parentSettings = const AiParentSettings(
        aiTutorEnabled: true,
        dailyMinutesLimit: 10,
        dailyTurnsLimit: 20,
      );
    });

    test('Processes child input successfully, returns character response, and emits LearningSignal', () async {
      final turn = await tutorService.processChildTurn(
        sessionId: 'session_1',
        childId: 'child_ayaan',
        childInput: 'I see a red apple',
        context: context,
        settings: parentSettings,
        turnHistory: const [],
      );

      expect(turn.speaker, equals(AiSpeaker.character));
      expect(turn.validationStatus, equals(AiValidationStatus.passed));
      expect(turn.text, contains('apple'));

      // Verify learning signal was emitted
      expect(tutorService.emittedSignals.length, equals(1));
      final signal = tutorService.emittedSignals.first;
      expect(signal.childId, equals('child_ayaan'));
      expect(signal.skill, equals(SkillType.vocabulary));
      expect(signal.score, greaterThan(0.8));
    });

    test('Intercepts unsafe input and returns safe redirect with safety status', () async {
      final turn = await tutorService.processChildTurn(
        sessionId: 'session_2',
        childId: 'child_ayaan',
        childInput: 'Call my phone 123-456-7890 please',
        context: context,
        settings: parentSettings,
        turnHistory: const [],
      );

      expect(turn.validationStatus, equals(AiValidationStatus.rejectedSafety));
      expect(turn.text, contains('privacy'));
    });

    test('Falls back gracefully to scripted dialogue when timeout occurs', () async {
      final timeoutService = AiTutorService(
        provider: const MockAiProvider(forceTimeout: true),
        usageManager: AiUsageManager(),
      );

      final turn = await timeoutService.processChildTurn(
        sessionId: 'session_3',
        childId: 'child_ayaan',
        childInput: 'I love apple',
        context: context,
        settings: parentSettings,
        turnHistory: const [],
      );

      expect(turn.validationStatus, equals(AiValidationStatus.fallbackApplied));
      expect(turn.text, isNotEmpty);
      expect(turn.text, contains('apple'));
    });

    test('Enforces parent turn limits and applies gentle scripted fallback', () async {
      final restrictedSettings = const AiParentSettings(
        aiTutorEnabled: true,
        dailyTurnsLimit: 1,
      );

      // Turn 1: Allowed
      await tutorService.processChildTurn(
        sessionId: 'session_4',
        childId: 'child_ayaan',
        childInput: 'I like apples',
        context: context,
        settings: restrictedSettings,
        turnHistory: const [],
      );

      // Turn 2: Over quota
      final turn2 = await tutorService.processChildTurn(
        sessionId: 'session_4',
        childId: 'child_ayaan',
        childInput: 'I also like milk',
        context: context,
        settings: restrictedSettings,
        turnHistory: const [],
      );

      expect(turn2.validationStatus, equals(AiValidationStatus.fallbackApplied));
      expect(turn2.text, isNotEmpty);
    });
  });
}
