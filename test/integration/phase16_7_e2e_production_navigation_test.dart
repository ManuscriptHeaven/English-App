import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/routing/app_router.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/features/child_profile/data/mock_child_profile_repository.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/learning_age_band.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_session_screen.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/presentation/providers/world_providers.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('Phase 16.7 True E2E Production Navigation Tests', () {
    late MockChildProfileRepository profileRepo;
    late MockAudioService audioService;
    late MockSpeechRecognitionService speechService;
    late MockWorldRepository worldRepo;

    setUp(() {
      profileRepo = MockChildProfileRepository();
      audioService = MockAudioService();
      speechService = MockSpeechRecognitionService();
      worldRepo = MockWorldRepository();
    });

    testWidgets('1. Age 3 Child: Home -> World -> Lesson launches Pre-A Interactive Session', (tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      // Create Age 3 Child Profile
      const childAge3 = ChildProfile(
        id: 'child_age_3',
        parentId: 'parent_1',
        name: 'Zayd',
        age: 3,
        avatar: Avatar(id: 'av_1', assetPath: 'assets/avatars/boy.png', name: 'Zayd'),
      );

      final container = ProviderContainer(
        overrides: [
          childProfileRepositoryProvider.overrideWithValue(profileRepo),
          audioServiceProvider.overrideWithValue(audioService),
          speechRecognitionServiceProvider.overrideWithValue(speechService),
          worldRepositoryProvider.overrideWithValue(worldRepo),
        ],
      );
      addTearDown(container.dispose);

      // Set active child to Age 3
      container.read(activeChildProfileProvider.notifier).state = childAge3;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // 1. Start from Home Screen
      AppRouter.router.go(RouteNames.home);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.textContaining('Zayd'), findsWidgets);

      // 2. Navigate to World 1 (Animal Adventure)
      AppRouter.router.go(RouteNames.worldDetailPath('world_animal'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.textContaining('Animal Adventure'), findsWidgets);

      // 3. Child taps first lesson node on the map: activity_animal_vocab
      AppRouter.router.go(RouteNames.interactiveSessionPath('activity_animal_vocab'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // 4. Assert InteractiveSessionScreen is active (NOT legacy VocabularyDiscoveryScreen)
      expect(find.byType(InteractiveSessionScreen), findsOneWidget);

      // 5. Verify Age 3 developmental properties:
      // - Text density is zero (no text labels on cards)
      // - Max 2 choices
      // - Touch reaction works
      final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));
      expect(sessionWidget.session.ageProfile.ageBand, LearningAgeBand.bandPreALittleListeners);
      expect(sessionWidget.session.ageProfile.textDensity, TextDensity.zero);
      expect(sessionWidget.session.ageProfile.numberOfChoices, 2);
      expect(sessionWidget.session.ageProfile.speakingRequirement, SpeakingRequirement.optionalImitation);

      // Verify touch interaction
      expect(find.text('🍎'), findsOneWidget);
      await tester.tap(find.text('🍎'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Assert Pip happy reaction triggered
      expect(find.textContaining('crisp red apple'), findsOneWidget);

      // Allow reaction and auto-advance timers to complete cleanly
      await tester.pump(const Duration(seconds: 2));
    });

    testWidgets('2. Age 5 Child: Normal Navigation launches Band A Interactive Session', (tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const childAge5 = ChildProfile(
        id: 'child_age_5',
        parentId: 'parent_1',
        name: 'Amina',
        age: 5,
        avatar: Avatar(id: 'av_2', assetPath: 'assets/avatars/girl.png', name: 'Amina'),
      );

      final container = ProviderContainer(
        overrides: [
          childProfileRepositoryProvider.overrideWithValue(profileRepo),
          audioServiceProvider.overrideWithValue(audioService),
          speechRecognitionServiceProvider.overrideWithValue(speechService),
          worldRepositoryProvider.overrideWithValue(worldRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(activeChildProfileProvider.notifier).state = childAge5;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Launch first lesson via production route
      AppRouter.router.go(RouteNames.interactiveSessionPath('activity_animal_vocab'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(InteractiveSessionScreen), findsOneWidget);
      final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));
      expect(sessionWidget.session.ageProfile.ageBand, LearningAgeBand.bandALittleExplorers);
      expect(sessionWidget.session.ageProfile.numberOfChoices, 3);
      expect(sessionWidget.session.ageProfile.textDensity, TextDensity.minimal);
    });

    testWidgets('3. Age 7 Child: Normal Navigation launches Band B Interactive Session', (tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const childAge7 = ChildProfile(
        id: 'child_age_7',
        parentId: 'parent_1',
        name: 'Bilal',
        age: 7,
        avatar: Avatar(id: 'av_3', assetPath: 'assets/avatars/boy.png', name: 'Bilal'),
      );

      final container = ProviderContainer(
        overrides: [
          childProfileRepositoryProvider.overrideWithValue(profileRepo),
          audioServiceProvider.overrideWithValue(audioService),
          speechRecognitionServiceProvider.overrideWithValue(speechService),
          worldRepositoryProvider.overrideWithValue(worldRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(activeChildProfileProvider.notifier).state = childAge7;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Launch first lesson via production route
      AppRouter.router.go(RouteNames.interactiveSessionPath('activity_animal_vocab'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(InteractiveSessionScreen), findsOneWidget);
      final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));
      expect(sessionWidget.session.ageProfile.ageBand, LearningAgeBand.bandBYoungAdventurers);
      expect(sessionWidget.session.ageProfile.numberOfChoices, 4);
      expect(sessionWidget.session.ageProfile.textDensity, TextDensity.moderate);
    });

    testWidgets('4. Age 9 Child: Normal Navigation launches Band C Mature Interactive Session', (tester) async {
      tester.view.physicalSize = const Size(1200, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      const childAge9 = ChildProfile(
        id: 'child_age_9',
        parentId: 'parent_1',
        name: 'Maryam',
        age: 9,
        avatar: Avatar(id: 'av_4', assetPath: 'assets/avatars/girl.png', name: 'Maryam'),
      );

      final container = ProviderContainer(
        overrides: [
          childProfileRepositoryProvider.overrideWithValue(profileRepo),
          audioServiceProvider.overrideWithValue(audioService),
          speechRecognitionServiceProvider.overrideWithValue(speechService),
          worldRepositoryProvider.overrideWithValue(worldRepo),
        ],
      );
      addTearDown(container.dispose);

      container.read(activeChildProfileProvider.notifier).state = childAge9;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: AppRouter.router,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Launch first lesson via production route
      AppRouter.router.go(RouteNames.interactiveSessionPath('activity_animal_vocab'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.byType(InteractiveSessionScreen), findsOneWidget);
      final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));
      expect(sessionWidget.session.ageProfile.ageBand, LearningAgeBand.bandCGrowingSpeakers);
      expect(sessionWidget.session.ageProfile.textDensity, TextDensity.rich);
      expect(sessionWidget.session.ageProfile.visualTargetSize, 58.0); // Refined mature size
      expect(sessionWidget.session.ageProfile.speakingRequirement, SpeakingRequirement.conversationalDiscourse);
      expect(sessionWidget.session.ageProfile.pipSpeechFrequency, PipSpeechFrequency.supportiveTargeted);
    });
  });
}
