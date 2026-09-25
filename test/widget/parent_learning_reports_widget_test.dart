import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_learning_reports_screen.dart';

void main() {
  late ProviderContainer container;
  final child = ChildProfile(
    id: 'child_ayaan',
    parentId: 'parent_1',
    name: 'Ayaan',
    age: 6,
    xp: 420,
    streakDays: 4,
    avatar: const Avatar(id: 'av_ayaan', name: 'Ayaan', assetPath: 'assets/ayaan.png'),
  );

  setUp(() {
    container = ProviderContainer();
    container.read(activeChildProfileProvider.notifier).selectChild(child);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('ParentLearningReportsScreen renders periods, skills, values, and insights', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ParentLearningReportsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('This Week'), findsOneWidget);
    expect(find.text('Last Week'), findsOneWidget);
    expect(find.text('This Month'), findsOneWidget);

    expect(find.text('Ayaan\'s Learning Journey'), findsOneWidget);
    expect(find.text('Core Skill Progress'), findsOneWidget);
    expect(find.text('Values & Good Manners Practiced'), findsOneWidget);
    expect(find.text('Gratitude (Shukr)'), findsOneWidget);
    expect(find.text('Sharing (Ithaar)'), findsOneWidget);
    expect(find.text('Parent Recommendation'), findsOneWidget);
  });

  testWidgets('ParentLearningReportsScreen switches period on tab tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ParentLearningReportsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('45 min'), findsOneWidget);

    await tester.tap(find.text('This Month'));
    await tester.pumpAndSettle();

    expect(find.text('140 min'), findsOneWidget);
  });
}
