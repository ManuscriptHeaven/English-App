import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_conversation_state_machine.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/scripted_dialogue_engine.dart';

void main() {
  group('ScriptedDialogueEngine & State Machine Tests', () {
    test('Generates educational initial prompts across all 7 modes', () {
      for (final mode in AiMode.values) {
        final context = AiCurriculumContext.forChild(
          childAge: 6,
          currentWorldId: 'world_animal',
          currentLessonId: 'activity_animal_vocab',
          mode: mode,
          targetSkill: SkillType.vocabulary,
          targetVocabulary: const ['cat', 'lion'],
          conversationObjective: 'Mode test for ${mode.name}',
        );

        final initial = ScriptedDialogueEngine.getInitialPrompt(context);
        expect(initial.text, isNotEmpty, reason: 'Empty prompt for ${mode.name}');
        expect(initial.suggestedReplies, isNotEmpty);
        expect(initial.nextState, equals(ConversationState.prompt));
      }
    });

    test('Processes vocabulary turn accurately when child uses target word', () {
      final context = AiCurriculumContext.forChild(
        childAge: 5,
        currentWorldId: 'world_animal',
        currentLessonId: 'activity_animal_vocab',
        mode: AiMode.vocabularyTalk,
        targetSkill: SkillType.vocabulary,
        targetVocabulary: const ['elephant', 'lion'],
        conversationObjective: 'Learn animal names',
      );

      final response = ScriptedDialogueEngine.processTurn(
        childInput: 'I see a big elephant!',
        context: context,
        turnIndex: 0,
        currentState: ConversationState.prompt,
      );

      expect(response.accuracyScore, greaterThan(0.9));
      expect(response.isTargetMastered, isTrue);
      expect(response.text, contains('elephant'));
      expect(response.nextState, equals(ConversationState.success));
    });

    test('Provides gentle scaffolding when child response misses target word', () {
      final context = AiCurriculumContext.forChild(
        childAge: 5,
        currentWorldId: 'world_animal',
        currentLessonId: 'activity_animal_vocab',
        mode: AiMode.vocabularyTalk,
        targetSkill: SkillType.vocabulary,
        targetVocabulary: const ['elephant', 'lion'],
        conversationObjective: 'Learn animal names',
      );

      final response = ScriptedDialogueEngine.processTurn(
        childInput: 'I see a car',
        context: context,
        turnIndex: 0,
        currentState: ConversationState.prompt,
      );

      expect(response.accuracyScore, lessThan(0.8));
      expect(response.isTargetMastered, isFalse);
      expect(response.text, contains('Good try'));
      expect(response.nextState, equals(ConversationState.scaffold));
    });

    test('AiConversationStateMachine steps through scaffold and complete correctly', () {
      final sm = AiConversationStateMachine(maxTurns: 4);
      expect(sm.currentState, equals(ConversationState.intro));

      // Turn 1: Failure -> retry
      final state1 = sm.transition(isAccurate: false, currentTurnCount: 0);
      expect(state1, equals(ConversationState.retry));
      expect(sm.consecutiveFailures, equals(1));

      // Turn 2: Failure -> scaffold
      final state2 = sm.transition(isAccurate: false, currentTurnCount: 1);
      expect(state2, equals(ConversationState.scaffold));
      expect(sm.consecutiveFailures, equals(2));

      // Turn 3: Success -> success
      final state3 = sm.transition(isAccurate: true, currentTurnCount: 2);
      expect(state3, equals(ConversationState.success));
      expect(sm.consecutiveSuccesses, equals(1));

      // Turn 4: User Ending / Max turns -> complete
      final state4 = sm.transition(isAccurate: true, currentTurnCount: 4);
      expect(state4, equals(ConversationState.complete));
    });
  });
}
