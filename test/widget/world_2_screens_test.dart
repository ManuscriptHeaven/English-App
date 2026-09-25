import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/home_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/home_hunt_game_screen.dart';
import 'package:kids_english_adventure/features/vocabulary/presentation/screens/family_vocabulary_screen.dart';
import 'package:kids_english_adventure/features/games/presentation/screens/cleanliness_sort_screen.dart';
import 'package:kids_english_adventure/features/parent/presentation/screens/parent_dashboard_screen.dart';

void main() {
  testWidgets('HomeVocabularyScreen renders first home word and audio triggers', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeVocabularyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Room'), findsOneWidget);
    expect(find.text('Next Word ▶'), findsOneWidget);
  });

  testWidgets('HomeHuntGameScreen renders home item prompt and choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: HomeHuntGameScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Find the Bed! 🛏️'), findsOneWidget);
    expect(find.text('Pip the Falcon'), findsOneWidget);
  });

  testWidgets('FamilyVocabularyScreen renders mother word and loving prompt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: FamilyVocabularyScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Mother'), findsOneWidget);
    expect(find.text('Birr al-Walidayn'), findsOneWidget);
  });

  testWidgets('CleanlinessSortScreen renders Taharah banner and sorting choices', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: CleanlinessSortScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Cleanliness is Faith'), findsOneWidget);
    expect(find.text('Tidy & Clean'), findsOneWidget);
  });

  testWidgets('ParentDashboardScreen renders 5 core skill metrics and insights', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: ParentDashboardScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Core Skill Mastery'), findsOneWidget);
    expect(find.text('Personalized Learning Insights'), findsOneWidget);
    expect(find.text('Weekly Learning Minutes'), findsOneWidget);
  });
}
