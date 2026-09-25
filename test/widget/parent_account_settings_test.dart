import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_account_settings_screen.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_dashboard_screen.dart';

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

  testWidgets('ParentAccountSettingsScreen renders account, cloud sync, export, and delete options', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ParentAccountSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parent Account & Sync'), findsOneWidget);
    expect(find.text('Cloud Data Sync'), findsOneWidget);
    expect(find.text('Sync All Progress Now 🔄'), findsOneWidget);
    expect(find.text('Export Learning History (JSON)'), findsOneWidget);
    expect(find.text('Delete Ayaan\'s Profile'), findsOneWidget);
    expect(find.text('Sign Out Parent Account'), findsOneWidget);
  });

  testWidgets('ParentDashboardScreen renders sync status badge and account settings button', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ParentDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Parent Dashboard 🛡️'), findsOneWidget);
    expect(find.text('Account & Data Sync ⚙️'), findsOneWidget);
  });
}
