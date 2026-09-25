import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/widgets/adventure_trail_map.dart';
import 'package:kids_english_adventure/core/widgets/audio_play_button.dart';
import 'package:kids_english_adventure/core/widgets/microphone_button.dart';
import 'package:kids_english_adventure/core/widgets/pip_character_guide.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/screens/talk_with_pip_screen.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/learning/presentation/screens/speaking_practice_screen.dart';
import 'package:kids_english_adventure/features/values/presentation/screens/value_moment_screen.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/content_metadata.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';

void main() {
  late ProviderContainer container;
  final child = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    stars: 12,
    xp: 340,
    coins: 50,
  );

  setUp(() {
    container = ProviderContainer(
      overrides: [
        audioServiceProvider.overrideWithValue(MockAudioService()),
        speechRecognitionServiceProvider.overrideWithValue(MockSpeechRecognitionService()),
      ],
    );
    container.read(activeChildProfileProvider.notifier).selectChild(child);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('AudioPlayButton triggers audio playback on tap', (WidgetTester tester) async {
    bool started = false;
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: AudioPlayButton(
              textToSpeak: 'Hello explorer!',
              label: 'Listen',
              onPlayStart: () => started = true,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Listen'), findsOneWidget);
    await tester.tap(find.text('Listen'));
    await tester.pump();

    expect(started, isTrue);
  });

  testWidgets('MicrophoneButton renders and handles speech result', (WidgetTester tester) async {
    String recognized = '';
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: Scaffold(
            body: MicrophoneButton(
              targetPhrase: 'Cat',
              onSpeechResult: (text, similarity) => recognized = text,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('🎤 Tap to Speak'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.mic_rounded));
    await tester.pump(const Duration(milliseconds: 700));

    expect(recognized, isNotEmpty);
  });

  testWidgets('PipCharacterGuide renders speech bubble and avatar', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: PipCharacterGuide(
            state: PipState.speaking,
            speechBubbleText: 'Welcome to the adventure!',
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Welcome to the adventure!'), findsOneWidget);
    expect(find.text('🦜'), findsOneWidget);
  });

  testWidgets('AdventureTrailMap renders nodes with correct step indices', (WidgetTester tester) async {
    final testLessons = [
      const Lesson(
        id: 'l1',
        unitId: 'u1',
        title: 'Step 1: Animal Words',
        subtitle: 'Learn animals',
        orderIndex: 1,
        metadata: ContentMetadata(
          status: PublishedStatus.published,
          learningObjective: 'Learn basic animal words',
        ),
        activities: [],
      ),
      const Lesson(
        id: 'l2',
        unitId: 'u1',
        title: 'Step 2: Animal Hunt',
        subtitle: 'Find animals',
        orderIndex: 2,
        metadata: ContentMetadata(
          status: PublishedStatus.published,
          learningObjective: 'Hunt for animals in park',
        ),
        activities: [],
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AdventureTrailMap(
            lessons: testLessons,
            currentLessonIndex: 0,
            onLessonTap: (_) {},
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Step 1'), findsOneWidget);
    expect(find.text('Step 2'), findsOneWidget);
  });

  testWidgets('AdventureHomeScreen renders child greeting, Pip guide, and Continue Adventure CTA', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AdventureHomeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.textContaining('Ayaan'), findsOneWidget);
    expect(find.textContaining('ADVENTURE 🚀'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Map'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
    expect(find.text('Pip'), findsOneWidget);
  });

  testWidgets('SpeakingPracticeScreen renders child-friendly speaking stage', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: SpeakingPracticeScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hear It'), findsOneWidget);
    expect(find.text('🎤 Tap to Speak'), findsOneWidget);
  });

  testWidgets('ValueMomentScreen renders moral dilemma and choice cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ValueMomentScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Gently with clean water ❤️'), findsOneWidget);
    expect(find.text('Roughly and loudly ❌'), findsOneWidget);
  });

  testWidgets('TalkWithPipScreen renders Pip character dialogue stage without chat clutter', (WidgetTester tester) async {
    final aiContext = AiCurriculumContext.forChild(
      childAge: 6,
      currentWorldId: 'world_animal',
      currentLessonId: 'activity_speaking',
      mode: AiMode.speakingChallenge,
      targetSkill: SkillType.speaking,
      targetVocabulary: const ['cat', 'lion'],
      targetGrammar: 'This is a cat',
      conversationObjective: 'Practice animal sentences.',
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: TalkWithPipScreen(context: aiContext),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Hear Pip 🔊'), findsOneWidget);
    expect(find.byType(MicrophoneButton), findsOneWidget);
  });
}
