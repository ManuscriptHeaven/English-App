import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/ai_tutor/presentation/widgets/ai_parent_settings_card.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/avatar.dart';
import 'package:kids_english_adventure/features/child_profile/domain/models/child_profile.dart';
import 'package:kids_english_adventure/features/child_profile/presentation/providers/child_profile_providers.dart';

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

  testWidgets('AiParentSettingsCard renders toggle switches, sliders, and usage statistics', (WidgetTester tester) async {
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: AiParentSettingsCard(),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AI Tutor & Conversation Controls'), findsOneWidget);
    expect(find.text('Daily Time Limit'), findsOneWidget);
    expect(find.text('Daily Turns Limit'), findsOneWidget);
    expect(find.text('Voice & Speech Practice'), findsOneWidget);
    expect(find.text('Curriculum Story Variations'), findsOneWidget);
    expect(find.text('Today\'s Turns'), findsOneWidget);
  });
}
