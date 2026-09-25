import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/widgets/pip_character_guide.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_curriculum_context.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_mode.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/screens/talk_with_pip_screen.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/models/learning_signal.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/screens/child_selection_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/animal_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:kids_english_adventure/features/rewards/presentation/screens/rewards_screen.dart';
import 'package:kids_english_adventure/features/stories/presentation/screens/story_reader_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/vocabulary_discovery_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/world_detail_screen.dart';

Widget _buildTestApp({
  required Widget child,
  required ProviderContainer container,
  Size size = const Size(390, 844),
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          disableAnimations: true,
        ),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });
  late ProviderContainer container;
  final testChild = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
    stars: 12,
    coins: 50,
    xp: 220,
    unlockedWorldIds: const ['world_animal', 'world_home'],
    completedLessonIds: const ['activity_animal_vocab'],
  );

  setUp(() {
    container = ProviderContainer(
      overrides: [
        audioServiceProvider.overrideWithValue(MockAudioService()),
        speechRecognitionServiceProvider.overrideWithValue(MockSpeechRecognitionService()),
      ],
    );
    container.read(activeChildProfileProvider.notifier).selectChild(testChild);
  });

  tearDown(() {
    container.dispose();
  });

  group('Golden Visual Regression Tests for Major Child UI States', () {
    testWidgets('1. Welcome screen visual state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const WelcomeScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(WelcomeScreen), findsOneWidget);
      await expectLater(
        find.byType(WelcomeScreen),
        matchesGoldenFile('goldens/welcome_screen.png'),
      );
    });

    testWidgets('2. Adventure home visual state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const AdventureHomeScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AdventureHomeScreen), findsOneWidget);
      await expectLater(
        find.byType(AdventureHomeScreen),
        matchesGoldenFile('goldens/adventure_home.png'),
      );
    });

    testWidgets('3. World detail trail visual state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const WorldDetailScreen(worldId: 'world_animal'),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(WorldDetailScreen), findsOneWidget);
      await expectLater(
        find.byType(WorldDetailScreen),
        matchesGoldenFile('goldens/world_detail_trail.png'),
      );
    });

    testWidgets('4. Vocabulary initial state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const VocabularyDiscoveryScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(VocabularyDiscoveryScreen), findsOneWidget);
      await expectLater(
        find.byType(VocabularyDiscoveryScreen),
        matchesGoldenFile('goldens/vocabulary_initial.png'),
      );
    });

    testWidgets('5. Vocabulary revealed state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const VocabularyDiscoveryScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap creature to trigger progressive reveal
      await tester.tap(find.text('Elephant'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 800));

      await expectLater(
        find.byType(VocabularyDiscoveryScreen),
        matchesGoldenFile('goldens/vocabulary_revealed.png'),
      );
    });

    testWidgets('6. Animal Hunt normal state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const AnimalHuntGameScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(AnimalHuntGameScreen), findsOneWidget);
      await expectLater(
        find.byType(AnimalHuntGameScreen),
        matchesGoldenFile('goldens/animal_hunt_normal.png'),
      );
    });

    testWidgets('7. Animal Hunt correct-answer state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const AnimalHuntGameScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Elephant choice (correct)
      await tester.tap(find.text('Elephant'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await expectLater(
        find.byType(AnimalHuntGameScreen),
        matchesGoldenFile('goldens/animal_hunt_correct.png'),
      );
    });

    testWidgets('8. Animal Hunt incorrect-answer state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const AnimalHuntGameScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Lion choice (incorrect for round 1 elephant)
      await tester.tap(find.text('Lion'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      await expectLater(
        find.byType(AnimalHuntGameScreen),
        matchesGoldenFile('goldens/animal_hunt_incorrect.png'),
      );
    });

    testWidgets('9. Story Reader reading state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const StoryReaderScreen(storyId: 'story_animal_park'),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(StoryReaderScreen), findsOneWidget);
      await expectLater(
        find.byType(StoryReaderScreen),
        matchesGoldenFile('goldens/story_reader_page.png'),
      );
    });

    testWidgets('10. Story comprehension question state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const StoryReaderScreen(storyId: 'story_animal_park'),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Navigate to quiz mode
      for (int i = 0; i < 7; i++) {
        await tester.tap(find.text('Next Page ▶'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.tap(find.text('Story Quiz 🎯 ▶'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(StoryReaderScreen),
        matchesGoldenFile('goldens/story_quiz_question.png'),
      );
    });

    testWidgets('11. Talk with Pip idle state', (tester) async {
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

      await tester.pumpWidget(_buildTestApp(
        child: TalkWithPipScreen(context: aiContext),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(TalkWithPipScreen), findsOneWidget);
      await expectLater(
        find.byType(TalkWithPipScreen),
        matchesGoldenFile('goldens/talk_with_pip_idle.png'),
      );
    });

    testWidgets('12. Talk with Pip listening state (PipCharacterGuide)', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const Scaffold(
          body: Center(
            child: PipCharacterGuide(
              state: PipState.listening,
              speechBubbleText: "I'm listening carefully! 👂",
              characterSize: 120,
            ),
          ),
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(PipCharacterGuide),
        matchesGoldenFile('goldens/pip_listening.png'),
      );
    });

    testWidgets('13. Talk with Pip speaking state (PipCharacterGuide)', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const Scaffold(
          body: Center(
            child: PipCharacterGuide(
              state: PipState.speaking,
              speechBubbleText: 'Say "Elephant" with me! 🐘',
              characterSize: 120,
            ),
          ),
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      await expectLater(
        find.byType(PipCharacterGuide),
        matchesGoldenFile('goldens/pip_speaking.png'),
      );
    });

    testWidgets('14. Rewards trophy room visual state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const RewardsScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(RewardsScreen), findsOneWidget);
      await expectLater(
        find.byType(RewardsScreen),
        matchesGoldenFile('goldens/rewards_trophy_room.png'),
      );
    });

    testWidgets('15. Child selection visual state', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        child: const ChildSelectionScreen(),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(ChildSelectionScreen), findsOneWidget);
      await expectLater(
        find.byType(ChildSelectionScreen),
        matchesGoldenFile('goldens/child_selection.png'),
      );
    });
  });
}
