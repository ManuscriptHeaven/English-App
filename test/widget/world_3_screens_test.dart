import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/classroom_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/honesty_challenge_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_do_school_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/listen_and_find_school_screen.dart';
import 'package:kids_english_adventure/features/grammar/presentation/screens/plurals_grammar_screen.dart';
import 'package:kids_english_adventure/features/learning/presentation/screens/polite_requests_dialogue_screen.dart';
import 'package:kids_english_adventure/features/stories/presentation/screens/story_quiz_school_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/school_actions_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/school_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/teacher_friend_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/school_challenge_screen.dart';

void main() {
  late ProviderContainer container;
  final child = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
  );

  setUp(() {
    container = ProviderContainer();
    container.read(activeChildProfileProvider.notifier).selectChild(child);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('SchoolVocabularyScreen renders first school word and audio triggers', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SchoolVocabularyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('School'), findsWidgets);
    expect(find.text('Next Word ▶'), findsOneWidget);
  });

  testWidgets('ClassroomHuntGameScreen renders choices and handles tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ClassroomHuntGameScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Find the Pencil! ✏️'), findsOneWidget);
    expect(find.text('Pencil'), findsWidgets);
  });

  testWidgets('ListenAndFindSchoolScreen renders audio prompt button', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ListenAndFindSchoolScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.volume_up_rounded), findsWidgets);
  });

  testWidgets('ListenAndDoSchoolScreen renders instruction prompt and object choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ListenAndDoSchoolScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Listen & Do 🎧'), findsOneWidget);
    expect(find.text('Touch the book! 📖'), findsOneWidget);
    expect(find.text('Book'), findsOneWidget);
  });

  testWidgets('SchoolActionsScreen renders active verb and Sunnah manner', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SchoolActionsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('School Actions 🏃‍♂️'), findsOneWidget);
    expect(find.text('Read'), findsOneWidget);
    expect(find.text('Seeking beneficial knowledge is rewarded by Allah. 🌟'), findsOneWidget);
  });

  testWidgets('TeacherFriendVocabularyScreen renders teacher word and Sunnah tip', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: TeacherFriendVocabularyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Teacher'), findsWidgets);
    expect(find.text('Classroom Sunnah'), findsOneWidget);
  });

  testWidgets('PluralsGrammarScreen renders countable choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: PluralsGrammarScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('books'), findsOneWidget);
    expect(find.text('book'), findsOneWidget);
  });

  testWidgets('PoliteRequestsDialogueScreen renders dialogue speech turns', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: PoliteRequestsDialogueScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Borrowing a Pencil ✏️'), findsOneWidget);
    expect(find.text('Can I borrow a pencil, please?'), findsOneWidget);
  });

  testWidgets('HonestyChallengeScreen renders dilemma choices and Sidq feedback', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: HonestyChallengeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('The Lost Pencil ✏️'), findsOneWidget);
    expect(find.text('Return it to the teacher or friend 👨‍🏫'), findsOneWidget);
  });

  testWidgets('StoryQuizSchoolScreen renders comprehension question and choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: StoryQuizSchoolScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Story Quiz 📖'), findsOneWidget);
    expect(find.text('1. Who needed a pencil in the classroom? ✏️'), findsOneWidget);
    expect(find.text('Ayaan\'s classmate'), findsOneWidget);
  });

  testWidgets('SchoolChallengeScreen renders milestone challenge', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SchoolChallengeScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Which object do we write with?'), findsOneWidget);
    expect(find.text('Pencil ✏️'), findsOneWidget);
  });
}
