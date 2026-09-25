import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/character_expression.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_option.dart';
import 'package:kids_english_adventure/features/conversation/domain/models/conversation_turn.dart';
import 'package:kids_english_adventure/features/conversation/presentation/screens/conversation_screen.dart';

void main() {
  late ProviderContainer container;
  final child = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
  );

  const testConversation = Conversation(
    id: 'conv_nature_test',
    title: 'Nature Chat with Pip',
    description: 'Talk with Pip about trees and flowers',
    learningObjective: 'Practice weather dialogue.',
    turns: [
      ConversationTurn(
        turnIndex: 0,
        speakerName: 'Pip',
        speakerEmoji: '🦜',
        expression: CharacterExpression.happy,
        promptText: 'Hello explorer! Is it sunny today?',
        expectedResponse: 'Yes it is sunny',
        options: [
          ConversationOption(
            id: 'opt_1',
            text: 'Yes, it is sunny! ☀️',
            isCorrect: true,
            feedback: 'Great! The sun is shining!',
          ),
          ConversationOption(
            id: 'opt_2',
            text: 'I want pizza 🍕',
            isCorrect: false,
            feedback: 'Pip asked about the weather!',
          ),
        ],
      ),
    ],
  );

  setUp(() {
    container = ProviderContainer();
    container.read(activeChildProfileProvider.notifier).selectChild(child);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('ConversationScreen renders speaker avatar, turn prompt, and choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ConversationScreen(conversation: testConversation),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nature Chat with Pip'), findsOneWidget);
    expect(find.text('Pip'), findsOneWidget);
    expect(find.text('Hello explorer! Is it sunny today?'), findsOneWidget);
    expect(find.text('Yes, it is sunny! ☀️'), findsOneWidget);
    expect(find.text('I want pizza 🍕'), findsOneWidget);

    // Tap correct option
    await tester.tap(find.text('Yes, it is sunny! ☀️'));
    await tester.pumpAndSettle();

    expect(find.text('Conversation Complete!'), findsOneWidget);
    expect(find.text('Collect Reward ⭐'), findsOneWidget);
  });
}
