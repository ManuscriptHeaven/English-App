import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/content_studio/presentation/screens/content_preview_screen.dart';

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

  testWidgets('ContentPreviewScreen renders developer/reviewer metadata banner and child UI', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: ContentPreviewScreen(contentId: 'nature_tree_01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Studio Preview 🛠️'), findsOneWidget);
    expect(find.text('Tree'), findsWidgets);
    expect(find.text('VALID ✓'), findsOneWidget);
  });
}
