import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/widgets/pip_character_guide.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/telemetry/learning_event.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/telemetry/learning_telemetry_service.dart';
import 'package:kids_english_adventure/features/adventure_brain/presentation/providers/telemetry_providers.dart';
import 'package:kids_english_adventure/features/child_profile/data/mock_child_profile_repository.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/animal_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/stories/presentation/screens/story_reader_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/vocabulary_discovery_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  late MockChildProfileRepository profileRepo;
  late InMemoryLearningTelemetryService telemetryService;
  late MockAudioService audioService;
  late MockSpeechRecognitionService speechService;
  late ProviderContainer container;
  late GoRouter testRouter;

  setUp(() {
    profileRepo = MockChildProfileRepository();
    telemetryService = InMemoryLearningTelemetryService();
    audioService = MockAudioService();
    speechService = MockSpeechRecognitionService();

    container = ProviderContainer(
      overrides: [
        childProfileRepositoryProvider.overrideWithValue(profileRepo),
        learningTelemetryServiceProvider.overrideWithValue(telemetryService),
        audioServiceProvider.overrideWithValue(audioService),
        speechRecognitionServiceProvider.overrideWithValue(speechService),
      ],
    );

    testRouter = GoRouter(
      initialLocation: RouteNames.home,
      routes: [
        GoRoute(
          path: RouteNames.home,
          builder: (context, state) => const AdventureHomeScreen(),
        ),
        GoRoute(
          path: RouteNames.vocabularyDiscovery,
          builder: (context, state) => const VocabularyDiscoveryScreen(),
        ),
        GoRoute(
          path: RouteNames.animalHunt,
          builder: (context, state) => const AnimalHuntGameScreen(),
        ),
        GoRoute(
          path: RouteNames.story,
          builder: (context, state) {
            final id = state.pathParameters['id'] ?? 'story_animal_park';
            return StoryReaderScreen(storyId: id);
          },
        ),
        GoRoute(
          path: RouteNames.listeningPractice,
          builder: (context, state) => const SizedBox(key: ValueKey('listeningPracticeDummy')),
        ),
        GoRoute(
          path: RouteNames.childSelection,
          builder: (context, state) => const SizedBox(key: ValueKey('childSelectionDummy')),
        ),
        GoRoute(
          path: RouteNames.rewards,
          builder: (context, state) => const SizedBox(key: ValueKey('rewardsDummy')),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets(
      'Full End-to-End Learning Journey: Home -> Vocab -> Game -> Story -> Rewards -> Profile Updates & Isolation',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    // ══════════════════════════════════════════════════════════
    // STEP 1: INITIAL STATE & CHILD PROFILE SETUP
    // ══════════════════════════════════════════════════════════
    final profiles = await profileRepo.getChildProfiles();
    final childAyaan = profiles.firstWhere((p) => p.id == 'child_ayaan');
    final childMaryam = profiles.firstWhere((p) => p.id == 'child_maryam');

    container.read(activeChildProfileProvider.notifier).selectChild(childAyaan);
    final initialStars = childAyaan.stars;
    final initialCoins = childAyaan.coins;
    final initialXp = childAyaan.xp;

    expect(initialStars, 6);
    expect(initialCoins, 80);
    expect(initialXp, 40);

    // Mount App with Root Router
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: testRouter,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // ══════════════════════════════════════════════════════════
    // STEP 2: ADVENTURE HOME SCREEN
    // ══════════════════════════════════════════════════════════
    expect(find.textContaining('Ayaan'), findsOneWidget);
    expect(find.textContaining('$initialStars'), findsWidgets);
    expect(childAyaan.coins, initialCoins);
    expect(find.textContaining('ADVENTURE 🚀'), findsOneWidget);

    // ══════════════════════════════════════════════════════════
    // STEP 3: VOCABULARY DISCOVERY SCREEN
    // ══════════════════════════════════════════════════════════
    testRouter.push(RouteNames.vocabularyDiscovery);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Iterate through all 9 vocabulary words in Animal Adventure
    final vocabWords = ['Elephant', 'Lion', 'Cat', 'Bird', 'Water', 'Clean', 'Gentle', 'Big', 'Small'];
    for (int i = 0; i < vocabWords.length; i++) {
      final word = vocabWords[i];
      expect(find.text(word), findsOneWidget);

      // Tap PipCharacterGuide to hear pronunciation and reveal sentence
      await tester.tap(find.byType(PipCharacterGuide).last);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      if (i < vocabWords.length - 1) {
        expect(find.text('Next Word ▶'), findsOneWidget);
        await tester.tap(find.text('Next Word ▶'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
      } else {
        expect(find.text('Play the Game! 🎮'), findsOneWidget);
        await tester.tap(find.text('Play the Game! 🎮'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));
      }
    }

    // Verify Reward Burst appeared
    expect(find.text('Word Explorer! 🌟'), findsOneWidget);
    expect(find.text('You discovered all animal words!'), findsOneWidget);

    // Dismiss Reward Burst — triggers context.pushReplacement(RouteNames.animalHunt)
    await tester.tap(find.text('Keep Going! 🚀'));
    await tester.pumpAndSettle();

    // Verify profile updated after Vocabulary completion
    var currentChild = container.read(activeChildProfileProvider)!;
    expect(currentChild.stars, initialStars + 3);
    expect(currentChild.coins, initialCoins + 10);
    expect(currentChild.xp, initialXp + 20);
    expect(currentChild.completedLessonIds.contains('activity_animal_vocab'), isTrue);

    // Verify telemetry captured vocabulary completion
    var ayaanEvents = telemetryService.getEventsForChild('child_ayaan');
    expect(
      ayaanEvents.any((e) =>
          e.eventType == LearningEventType.lessonCompleted &&
          e.activityId == 'activity_animal_vocab'),
      isTrue,
    );

    // ══════════════════════════════════════════════════════════
    // STEP 4: ANIMAL HUNT GAME SCREEN
    // (Already navigated via pushReplacement from Vocabulary)
    // ══════════════════════════════════════════════════════════
    expect(find.text('Animal Hunt'), findsOneWidget);
    expect(find.text('Find the Elephant! 🐘'), findsOneWidget);

    // Round 1: Target is Elephant. Tap incorrect choice first to test error handling
    await tester.tap(find.text('Lion'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('Almost! Try again'), findsOneWidget);

    // Tap correct choice (Elephant)
    await tester.tap(find.text('Elephant'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.textContaining('Amazing! You found it!'), findsOneWidget);

    // Next Round -> Round 2 (Target: Cat)
    await tester.tap(find.text('Next Animal! ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Find the Cat! 🐱'), findsOneWidget);

    await tester.tap(find.text('Cat'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Next Round -> Round 3 (Target: Lion)
    await tester.tap(find.text('Next Animal! ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Find the Lion! 🦁'), findsOneWidget);

    await tester.tap(find.text('Lion'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Next Round -> Round 4 (Target: Bird)
    await tester.tap(find.text('Next Animal! ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Find the Bird! 🐦'), findsOneWidget);

    await tester.tap(find.text('Bird'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Finish Hunt
    await tester.tap(find.text('Finish Game! 🏆'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // Verify Reward Burst appeared
    expect(find.text('Animal Hunt Master! 🏆'), findsOneWidget);

    // Dismiss Reward Burst
    await tester.tap(find.text('Keep Going! 🚀'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify profile updated after Game completion
    currentChild = container.read(activeChildProfileProvider)!;
    expect(currentChild.stars, initialStars + 3 + 3);
    expect(currentChild.coins, initialCoins + 10 + 15);
    expect(currentChild.xp, initialXp + 20 + 25);
    expect(currentChild.completedLessonIds.contains('activity_animal_hunt'), isTrue);

    // Verify telemetry captured game completion
    ayaanEvents = telemetryService.getEventsForChild('child_ayaan');
    expect(
      ayaanEvents.any((e) =>
          e.eventType == LearningEventType.lessonCompleted &&
          e.activityId == 'activity_animal_hunt'),
      isTrue,
    );

    // ══════════════════════════════════════════════════════════
    // STEP 5: STORY READER SCREEN & COMPREHENSION QUIZ
    // ══════════════════════════════════════════════════════════
    testRouter.push(RouteNames.storyPath('story_animal_park'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Story Time 📖'), findsOneWidget);

    // Page through the picture book (8 pages)
    for (int p = 0; p < 7; p++) {
      expect(find.text('Next Page ▶'), findsOneWidget);
      await tester.tap(find.text('Next Page ▶'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Switch to Story Quiz
    expect(find.text('Story Quiz 🎯 ▶'), findsOneWidget);
    await tester.tap(find.text('Story Quiz 🎯 ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Quiz Question 1 of 4
    expect(find.text('Question 1 of 4 ⭐'), findsOneWidget);
    await tester.tap(find.text('Clean water 💧'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Next Question ▶'), findsOneWidget);
    await tester.tap(find.text('Next Question ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Quiz Question 2 of 4
    expect(find.text('Question 2 of 4 ⭐'), findsOneWidget);
    await tester.tap(find.text('With soft, gentle hands 🤲'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Next Question ▶'), findsOneWidget);
    await tester.tap(find.text('Next Question ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Quiz Question 3 of 4
    expect(find.text('Question 3 of 4 ⭐'), findsOneWidget);
    await tester.tap(find.text('The elephant 🐘'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Next Question ▶'), findsOneWidget);
    await tester.tap(find.text('Next Question ▶'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Quiz Question 4 of 4
    expect(find.text('Question 4 of 4 ⭐'), findsOneWidget);
    await tester.tap(find.text('Alhamdulillah 🌟'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Finish Story Adventure
    expect(find.text('Finish Story Adventure! 🌟'), findsOneWidget);
    await tester.tap(find.text('Finish Story Adventure! 🌟'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify Story Reward Burst
    expect(find.text('Story Master! 📖🌟'), findsOneWidget);

    // Dismiss Story Reward Burst
    await tester.tap(find.text('Keep Going! 🚀'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Verify profile updated after Story completion
    currentChild = container.read(activeChildProfileProvider)!;
    expect(currentChild.stars, initialStars + 3 + 3 + 3);
    expect(currentChild.coins, initialCoins + 10 + 15 + 20);
    expect(currentChild.xp, initialXp + 20 + 25 + 40);
    expect(currentChild.completedLessonIds.contains('activity_story_read'), isTrue);

    // ══════════════════════════════════════════════════════════
    // STEP 6: CHILD PROFILE ISOLATION & TELEMETRY VERIFICATION
    // ══════════════════════════════════════════════════════════
    // Check Maryam's events in telemetry: MUST BE ZERO
    final maryamEvents = telemetryService.getEventsForChild('child_maryam');
    expect(maryamEvents, isEmpty, reason: 'Zero state leakage to other children');

    // Switch to Maryam and verify her profile is completely untouched
    container.read(activeChildProfileProvider.notifier).selectChild(childMaryam);
    final activeMaryam = container.read(activeChildProfileProvider)!;
    expect(activeMaryam.id, 'child_maryam');
    expect(activeMaryam.stars, childMaryam.stars);
    expect(activeMaryam.coins, childMaryam.coins);
    expect(activeMaryam.completedLessonIds, childMaryam.completedLessonIds);

    // Switch back to Ayaan
    container.read(activeChildProfileProvider.notifier).selectChild(currentChild);

    // ══════════════════════════════════════════════════════════
    // STEP 7: HOME SCREEN RE-ENTRY & DISPLAY UPDATED
    // ══════════════════════════════════════════════════════════
    testRouter.go(RouteNames.home);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify Home displays the newly earned stars and updated profile state
    final finalStars = currentChild.stars;
    final finalCoins = currentChild.coins;
    expect(find.textContaining('$finalStars'), findsWidgets);
    expect(finalCoins, initialCoins + 10 + 15 + 20);

    // Verify all 3 completed activities are stored
    expect(currentChild.completedLessonIds.length, 3);
    expect(
      currentChild.completedLessonIds,
      containsAll(['activity_animal_vocab', 'activity_animal_hunt', 'activity_story_read']),
    );

    // Final check: Total telemetry events for Ayaan
    final finalAyaanEvents = telemetryService.getEventsForChild('child_ayaan');
    expect(finalAyaanEvents.length, greaterThanOrEqualTo(3));
  });
}
