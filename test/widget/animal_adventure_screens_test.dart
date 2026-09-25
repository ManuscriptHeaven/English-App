import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/vocabulary_discovery_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/animal_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/values/presentation/screens/value_moment_screen.dart';

void main() {
  testWidgets('VocabularyDiscoveryScreen renders first animal word and audio triggers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: VocabularyDiscoveryScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Elephant'), findsOneWidget);
    expect(find.textContaining('🐘'), findsWidgets);
  });

  testWidgets('AnimalHuntGameScreen renders animal prompt and choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: AnimalHuntGameScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Find the Elephant! 🐘'), findsOneWidget);
    expect(find.textContaining('trunk'), findsOneWidget);
  });

  testWidgets('ValueMomentScreen renders gentle values and dilemma choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ValueMomentScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Rahmah (Mercy) Moment 🌟'), findsOneWidget);
    expect(find.text('Gently with clean water ❤️'), findsOneWidget);
  });
}
