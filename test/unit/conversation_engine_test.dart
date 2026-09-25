import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/character_expression.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_option.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_turn.dart';
import 'package:kids_english_adventure/features/conversation/domain/services/conversation_engine.dart';

void main() {
  group('Interactive Conversation Engine Tests', () {
    late Conversation testConversation;
    late ConversationEngine engine;

    setUp(() {
      testConversation = const Conversation(
        id: 'conv_weather_test',
        title: 'Weather Chat with Pip',
        description: 'Test weather dialogue',
        learningObjective: 'Practice weather questions and answers.',
        valueIds: ['value_creation_gratitude'],
        turns: [
          ConversationTurn(
            turnIndex: 0,
            speakerName: 'Pip',
            speakerEmoji: '🦜',
            expression: CharacterExpression.curious,
            promptText: 'How is the weather today?',
            expectedResponse: 'It is sunny',
            options: [
              ConversationOption(
                id: 'opt_1',
                text: 'It is sunny! ☀️',
                isCorrect: true,
                feedback: 'Great! The sun is bright!',
              ),
              ConversationOption(
                id: 'opt_2',
                text: 'I like carrots 🥕',
                isCorrect: false,
                feedback: 'Pip asked about the weather!',
              ),
            ],
          ),
          ConversationTurn(
            turnIndex: 1,
            speakerName: 'Pip',
            speakerEmoji: '🦜',
            expression: CharacterExpression.happy,
            promptText: 'Do you see the tall green tree?',
            expectedResponse: 'Yes I see the tree',
            options: [
              ConversationOption(
                id: 'opt_3',
                text: 'Yes, I see the tree! 🌳',
                isCorrect: true,
                feedback: 'SubhanAllah! Beautiful tree!',
              ),
            ],
          ),
        ],
      );

      engine = ConversationEngine(conversation: testConversation);
    });

    test('Initializes at Turn 0 and provides current character prompt', () {
      expect(engine.currentTurnIndex, equals(0));
      expect(engine.isCompleted, isFalse);

      final turn = engine.currentTurn;
      expect(turn, isNotNull);
      expect(turn!.speakerName, equals('Pip'));
      expect(turn.promptText, equals('How is the weather today?'));
    });

    test('Evaluates choice options and advances to next turn on correct choice', () {
      final wrongOption = testConversation.turns[0].options[1];
      final rightOption = testConversation.turns[0].options[0];

      // Wrong attempt
      final wrongResult = engine.submitChoice(wrongOption);
      expect(wrongResult, isFalse);
      expect(engine.currentTurnIndex, equals(0));
      expect(engine.attemptCount, equals(1));

      // Right attempt
      final rightResult = engine.submitChoice(rightOption);
      expect(rightResult, isTrue);
      expect(engine.currentTurnIndex, equals(1));
      expect(engine.currentTurn!.promptText, contains('tall green tree'));
    });

    test('Evaluates speech input with similarity score and generates LearningSignal', () {
      final score = engine.submitSpeech('it is sunny');
      expect(score, greaterThanOrEqualTo(0.8));
      expect(engine.currentTurnIndex, equals(1));

      final signals = engine.recordedSignals;
      expect(signals.length, equals(1));
      expect(signals.first.contentId, equals('conv_weather_test_turn_0'));
      expect(signals.first.score, greaterThanOrEqualTo(0.8));
    });

    test('Completes entire dialogue when final turn is answered', () {
      engine.submitChoice(testConversation.turns[0].options[0]);
      expect(engine.isCompleted, isFalse);

      engine.submitChoice(testConversation.turns[1].options[0]);
      expect(engine.isCompleted, isTrue);
      expect(engine.currentTurn, isNull);
    });
  });
}
