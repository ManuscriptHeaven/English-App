import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/widgets/adventure_button.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/screens/child_selection_screen.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:kids_english_adventure/features/rewards/presentation/screens/rewards_screen.dart';

Widget _buildDeviceApp({
  required Widget child,
  required ProviderContainer container,
  required Size size,
  double textScaleFactor = 1.0,
}) {
  return UncontrolledProviderScope(
    container: container,
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MediaQuery(
        data: MediaQueryData(
          size: size,
          textScaler: TextScaler.linear(textScaleFactor),
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

  final deviceProfiles = <String, Size>{
    'Small Phone (360x640)': const Size(360, 640),
    'Standard Phone (390x844)': const Size(390, 844),
    'Large Phone (412x915)': const Size(412, 915),
    'Tablet (800x1280)': const Size(800, 1280),
  };

  group('Device Matrix Responsive Layouts & Zero Overflow Verification', () {
    for (final entry in deviceProfiles.entries) {
      final deviceName = entry.key;
      final size = entry.value;

      testWidgets('Welcome screen renders cleanly without overflow on $deviceName', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const WelcomeScreen(),
          container: container,
          size: size,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull, reason: 'Zero layout/overflow exceptions allowed');
        expect(find.byType(WelcomeScreen), findsOneWidget);
      });

      testWidgets('Adventure home renders cleanly on $deviceName', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const AdventureHomeScreen(),
          container: container,
          size: size,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.byType(AdventureHomeScreen), findsOneWidget);
      });

      testWidgets('Child selection screen renders cleanly on $deviceName', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const ChildSelectionScreen(),
          container: container,
          size: size,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.byType(ChildSelectionScreen), findsOneWidget);
      });

      testWidgets('Rewards screen renders cleanly on $deviceName', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const RewardsScreen(),
          container: container,
          size: size,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.byType(RewardsScreen), findsOneWidget);
      });
    }
  });

  group('Dynamic Font Scaling Accessibility Tests (100%, 150%, 200%)', () {
    final fontScales = [1.0, 1.5, 2.0];

    for (final scale in fontScales) {
      testWidgets('Welcome screen adapts to font scale ${(scale * 100).toInt()}% without crashing', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const WelcomeScreen(),
          container: container,
          size: const Size(390, 844),
          textScaleFactor: scale,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });

      testWidgets('Adventure Home adapts to font scale ${(scale * 100).toInt()}% without crashing', (tester) async {
        await tester.pumpWidget(_buildDeviceApp(
          child: const AdventureHomeScreen(),
          container: container,
          size: const Size(390, 844),
          textScaleFactor: scale,
        ));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
      });
    }
  });

  group('Minimum Touch Target Dimensions Verification (>= 48x48 dp)', () {
    testWidgets('Interactive buttons meet minimum child touch target guidelines', (tester) async {
      await tester.pumpWidget(_buildDeviceApp(
        child: const WelcomeScreen(),
        container: container,
        size: const Size(390, 844),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 1500)); // Allow entrance animation to complete

      final buttonFinders = find.byType(AdventureButton);
      expect(buttonFinders, findsWidgets);

      for (final buttonElement in buttonFinders.evaluate()) {
        final renderBox = buttonElement.renderObject as RenderBox?;
        if (renderBox != null && renderBox.hasSize) {
          expect(
            renderBox.size.height,
            greaterThanOrEqualTo(48.0),
            reason: 'Touch target height must be at least 48dp for children',
          );
        }
      }
    });
  });
}
