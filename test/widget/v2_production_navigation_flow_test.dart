import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kids_english_adventure/core/experience/age_experience_profile.dart';
import 'package:kids_english_adventure/core/experience/interactive_session_composer.dart';
import 'package:kids_english_adventure/core/routing/route_names.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/curriculum/domain/models/curriculum_track.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/interactive_session_screen.dart';
import 'package:kids_english_adventure/features/home/presentation/screens/adventure_home_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/providers/world_providers.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/track_world_map_screen.dart';
import 'package:kids_english_adventure/features/worlds/presentation/screens/world_detail_screen.dart';

/// Builds a real GoRouter instance mirroring production routing for Home, Track Map, World Detail, and Interactive Session.
GoRouter _createTestRouter({String initialLocation = RouteNames.home}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const AdventureHomeScreen(),
      ),
      GoRoute(
        path: RouteNames.trackMap,
        builder: (context, state) => const TrackWorldMapScreen(),
      ),
      GoRoute(
        path: RouteNames.worldDetail,
        builder: (context, state) {
          final worldId = state.pathParameters['id'] ?? 'world_t1_hello_me';
          return WorldDetailScreen(worldId: worldId);
        },
      ),
      GoRoute(
        path: RouteNames.interactiveSession,
        builder: (context, state) {
          final lessonId = state.pathParameters['id'] ?? 't1_l01_pip_says_hello';
          return Consumer(
            builder: (context, ref, child) {
              final activeChild = ref.watch(activeChildProfileProvider);
              final age = activeChild?.age ?? 5;
              final profile = AgeExperienceProfile.forAge(age);
              final lessonAsync = ref.watch(lessonDetailProvider(lessonId));

              return lessonAsync.when(
                data: (lesson) {
                  final concepts = lesson?.targetVocabularyIds ?? [];
                  final title = lesson?.title;
                  final session = InteractiveSessionComposer.composeSession(
                    ageProfile: profile,
                    lessonId: lessonId,
                    title: title,
                    targetConceptWords: concepts,
                  );
                  return InteractiveSessionScreen(session: session);
                },
                loading: () => const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) {
                  final session = InteractiveSessionComposer.composeSession(
                    ageProfile: profile,
                    lessonId: lessonId,
                  );
                  return InteractiveSessionScreen(session: session);
                },
              );
            },
          );
        },
      ),
    ],
  );
}

/// Settles animation frames without hanging on infinite looping UI tickers (e.g. CTA pulse, trail pulse).
Future<void> _pumpSettle(WidgetTester tester) async {
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('P0 #1: V2 Production Navigation Flow Suite (Ages 3, 5, 7, 9, 11)', () {
    final testProfiles = [
      (age: 3, track: CurriculumTrack.track1LittleListeners, expectedPrefix: 't1_', firstLessonId: 't1_l01_pip_says_hello', expectedWorldId: 'world_t1_hello_me', worldTitle: 'Hello & Me'),
      (age: 5, track: CurriculumTrack.track2LittleSpeakers, expectedPrefix: 't2_', firstLessonId: 't2_l01_i_am_happy', expectedWorldId: 'world_t2_me', worldTitle: 'Me & Feelings'),
      (age: 7, track: CurriculumTrack.track3YoungSpeakers, expectedPrefix: 't3_', firstLessonId: 't3_l01_my_name_and_age', expectedWorldId: 'world_t3_me_family', worldTitle: 'Me & Family'),
      (age: 9, track: CurriculumTrack.track4GrowingCommunicators, expectedPrefix: 't4_', firstLessonId: 't4_l01_my_passions_and_goals', expectedWorldId: 'world_t4_identity', worldTitle: 'My Identity'),
      (age: 11, track: CurriculumTrack.track5ConfidentCommunicators, expectedPrefix: 't5_', firstLessonId: 't5_l01_personal_philosophy', expectedWorldId: 'world_t5_identity', worldTitle: 'Identity & Dreams'),
    ];

    for (final testCase in testProfiles) {
      testWidgets('Age ${testCase.age} (${testCase.track.shortName}): Home -> Tap Map -> Track World Map -> Select World 1 -> Tap Step 1 -> Opens V2 Session', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final container = ProviderContainer();
        final child = ChildProfile(
          id: 'child_age_${testCase.age}',
          parentId: 'parent_v2',
          name: 'Learner ${testCase.age}',
          age: testCase.age,
          avatar: const Avatar(id: 'av_1', name: 'Learner', assetPath: 'assets/avatar.png'),
        );
        container.read(activeChildProfileProvider.notifier).selectChild(child);

        final router = _createTestRouter(initialLocation: RouteNames.home);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await _pumpSettle(tester);

        // 1. Verify Home screen loaded with child's name
        expect(find.textContaining('Learner ${testCase.age}'), findsOneWidget);

        // 2. Real user UI tap: Tap "Map" on the bottom navigation bar
        final mapNavFinder = find.text('Map');
        expect(mapNavFinder, findsOneWidget);
        await tester.tap(mapNavFinder);
        await _pumpSettle(tester);

        // 3. Verify TrackWorldMapScreen is displayed with active track worlds
        expect(find.byType(TrackWorldMapScreen), findsOneWidget);
        expect(find.textContaining(testCase.worldTitle), findsAtLeastNWidgets(1));

        // 4. Tap the first world card
        final worldCardFinder = find.textContaining(testCase.worldTitle).first;
        await tester.tap(worldCardFinder);
        await _pumpSettle(tester);

        // 5. Verify WorldDetailScreen is displayed with trail nodes
        expect(find.byType(WorldDetailScreen), findsOneWidget);
        expect(find.text('Step 1'), findsOneWidget);

        // 6. Real user UI tap: Tap the first lesson node ("Step 1") on the adventure trail
        final step1Finder = find.text('Step 1');
        await tester.tap(step1Finder);
        await _pumpSettle(tester);

        // 7. Verify InteractiveSessionScreen opened with the correct V2 lesson
        expect(find.byType(InteractiveSessionScreen), findsOneWidget);
        final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));

        expect(
          sessionWidget.session.lessonId.startsWith(testCase.expectedPrefix),
          isTrue,
          reason: 'Expected lessonId starting with ${testCase.expectedPrefix} for age ${testCase.age}, got: ${sessionWidget.session.lessonId}',
        );
        expect(sessionWidget.session.lessonId, equals(testCase.firstLessonId));
        expect(sessionWidget.session.activities.length, inInclusiveRange(4, 9));
      });

      testWidgets('Age ${testCase.age} (${testCase.track.shortName}): Home Screen Primary CTA tap opens V2 InteractiveSessionScreen directly (${testCase.expectedPrefix}*)', (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() => tester.view.resetPhysicalSize());

        final container = ProviderContainer();
        final child = ChildProfile(
          id: 'child_cta_${testCase.age}',
          parentId: 'parent_v2',
          name: 'Explorer ${testCase.age}',
          age: testCase.age,
          avatar: const Avatar(id: 'av_1', name: 'Explorer', assetPath: 'assets/avatar.png'),
        );
        container.read(activeChildProfileProvider.notifier).selectChild(child);

        final router = _createTestRouter(initialLocation: RouteNames.home);

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp.router(
              routerConfig: router,
            ),
          ),
        );
        await _pumpSettle(tester);

        // Find primary adventure button on Home screen
        final ctaFinder = find.textContaining('ADVENTURE 🚀');
        expect(ctaFinder, findsOneWidget);

        // Tap CTA directly
        await tester.tap(ctaFinder);
        await _pumpSettle(tester);

        // Verify InteractiveSessionScreen opened
        expect(find.byType(InteractiveSessionScreen), findsOneWidget);
        final sessionWidget = tester.widget<InteractiveSessionScreen>(find.byType(InteractiveSessionScreen));

        expect(
          sessionWidget.session.lessonId.startsWith(testCase.expectedPrefix),
          isTrue,
          reason: 'Expected recommendation starting with ${testCase.expectedPrefix} for age ${testCase.age}, got: ${sessionWidget.session.lessonId}',
        );
        expect(sessionWidget.session.lessonId, equals(testCase.firstLessonId));
        expect(sessionWidget.session.activities.length, inInclusiveRange(4, 9));
      });
    }
  });
}
