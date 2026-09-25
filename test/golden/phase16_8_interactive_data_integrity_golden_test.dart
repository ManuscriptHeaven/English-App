import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/widgets/child_table_visual.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/features/child_profile/data/mock_child_profile_repository.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_session_screen.dart';
import 'package:kids_english_adventure/features/worlds/data/mock_world_repository.dart';
import 'package:kids_english_adventure/features/worlds/presentation/providers/world_providers.dart';

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
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    final fredokaData = File('google_fonts/Fredoka-Bold.ttf').readAsBytesSync();
    final nunitoData = File('google_fonts/Nunito-Bold.ttf').readAsBytesSync();
    final nunitoRegular = File('google_fonts/Nunito-Regular.ttf').readAsBytesSync();
    final fontLoader1 = FontLoader('Fredoka')..addFont(Future.value(ByteData.view(fredokaData.buffer)));
    final fontLoader2 = FontLoader('Nunito')
      ..addFont(Future.value(ByteData.view(nunitoData.buffer)))
      ..addFont(Future.value(ByteData.view(nunitoRegular.buffer)));
    await fontLoader1.load();
    await fontLoader2.load();
  });

  group('Phase 16.8 Interactive Data Integrity Golden Tests', () {
    late MockChildProfileRepository profileRepo;
    late MockAudioService audioService;
    late MockSpeechRecognitionService speechService;
    late MockWorldRepository worldRepo;
    late ProviderContainer container;

    setUp(() {
      profileRepo = MockChildProfileRepository();
      audioService = MockAudioService();
      speechService = MockSpeechRecognitionService();
      worldRepo = MockWorldRepository();

      container = ProviderContainer(
        overrides: [
          childProfileRepositoryProvider.overrideWithValue(profileRepo),
          audioServiceProvider.overrideWithValue(audioService),
          speechRecognitionServiceProvider.overrideWithValue(speechService),
          worldRepositoryProvider.overrideWithValue(worldRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('0. Font pre-warm', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Column(
          children: [
            Text('Warm Fredoka', style: AppTypography.headlineMedium.copyWith(fontWeight: FontWeight.bold)),
            Text('Warm Nunito', style: AppTypography.titleLarge.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('1. Age 3 Apple -> Basket golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge3 = AgeExperienceProfile.forAge(3);
      final sessionAge3 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge3,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge3,
          initialStepIndex: 1, // Step 2: Apple into Basket
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Assert semantic objects: Basket at destination, Apple as draggable, upward indicator
      expect(find.text('🧺'), findsOneWidget);
      expect(find.text('🍎'), findsWidgets);
      expect(find.byIcon(Icons.keyboard_double_arrow_up_rounded), findsOneWidget);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age3_apple_to_basket.png'),
      );
    });

    testWidgets('2. Age 3 Apple -> Rabbit golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge3 = AgeExperienceProfile.forAge(3);
      final sessionAge3 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge3,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge3,
          initialStepIndex: 2, // Step 3: Apple to hungry Rabbit
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert semantic objects: Rabbit receiver at destination, Apple as draggable
      expect(find.text('🐰'), findsOneWidget);
      expect(find.text('🍎'), findsWidgets);
      expect(find.byIcon(Icons.keyboard_double_arrow_up_rounded), findsOneWidget);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age3_apple_to_rabbit.png'),
      );
    });

    testWidgets('3. Age 3 Water -> Pip golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge3 = AgeExperienceProfile.forAge(3);
      final sessionAge3 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge3,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge3,
          initialStepIndex: 3, // Step 4: Water to thirsty Pip
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Assert semantic objects: Pip receiver at destination, Water as draggable
      expect(find.text('🐥'), findsWidgets);
      expect(find.text('💧'), findsWidgets);
      expect(find.byIcon(Icons.keyboard_double_arrow_up_rounded), findsOneWidget);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age3_water_to_pip.png'),
      );
    });

    testWidgets('4. Age 7 Role-Play golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge7 = AgeExperienceProfile.forAge(7);
      final sessionAge7 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge7,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge7,
          initialStepIndex: 5, // Step 6: Conversation role-play
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Picnic Conversation'), findsOneWidget);
      expect(find.textContaining('Water, please'), findsOneWidget);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age7_roleplay.png'),
      );
    });

    testWidgets('5. Age 9 Contextual Scene golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge9 = AgeExperienceProfile.forAge(9);
      final sessionAge9 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge9,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['water', 'apple'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge9,
          initialStepIndex: 0, // Step 1: Contextual problem solving
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.textContaining('We forgot to pack a drink'), findsOneWidget);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age9_contextual_scene.png'),
      );
    });

    testWidgets('6. Age 7 Book -> Table scene placement golden state', (tester) async {
      tester.view.physicalSize = const Size(390 * 2, 844 * 2);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      final profileAge7 = AgeExperienceProfile.forAge(7);
      final sessionAge7 = InteractiveSessionComposer.composeSession(
        ageProfile: profileAge7,
        lessonId: 'activity_animal_vocab',
        targetConceptWords: ['apple', 'water'],
      );

      await tester.pumpWidget(_buildTestApp(
        child: InteractiveSessionScreen(
          session: sessionAge7,
          initialStepIndex: 1, // Step 2: Put the book on the table
        ),
        container: container,
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Verify prompt and child table visual before drop
      expect(find.textContaining('Put the book on the table'), findsOneWidget);
      expect(find.byType(ChildTableVisual), findsOneWidget);
      expect(find.text('📖'), findsWidgets);

      // 2. Perform drag of book to table
      final bookFinder = find.byType(Draggable<String>);
      final tableFinder = find.byType(DragTarget<String>);
      await tester.drag(bookFinder, tester.getCenter(tableFinder) - tester.getCenter(bookFinder));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // 3. Verify completed state: table rendered with book on top
      final tableVisualFinder = find.byType(ChildTableVisual);
      expect(tableVisualFinder, findsOneWidget);
      final childTableVisual = tester.widget<ChildTableVisual>(tableVisualFinder);
      expect(childTableVisual.hasBookOnTop, isTrue);

      await expectLater(
        find.byType(InteractiveSessionScreen),
        matchesGoldenFile('goldens/phase16_8_age7_book_on_table.png'),
      );

      // Drain timer from PipStateController reaction
      await tester.pump(const Duration(milliseconds: 1500));
    });
  });
}
