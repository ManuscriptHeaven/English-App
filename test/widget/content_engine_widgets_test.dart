import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';
import 'package:kids_english_adventure/features/content_engine/presentation/screens/generic_activity_screen.dart';

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

  testWidgets('GenericActivityScreen renders vocabulary discovery item', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: GenericActivityScreen(contentId: 'food_apple_01'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Apple'), findsWidgets);
    expect(find.text('Complete Activity 🎉 ▶'), findsOneWidget);
  });

  testWidgets('GenericActivityScreen renders quiz item and handles option tap', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: GenericActivityScreen(contentId: 'food_hungry_thirsty_07'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Water 💧'), findsOneWidget);
    await tester.tap(find.text('Fresh Water 💧'));
    await tester.pumpAndSettle();

    expect(find.text('Complete Activity 🎉 ▶'), findsOneWidget);
  });
}
