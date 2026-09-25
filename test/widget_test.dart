import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/main.dart';

void main() {
  testWidgets('App boots into Welcome Screen with app title and start button', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: KidsEnglishAdventureApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.textContaining('Kids English'), findsOneWidget);
    expect(find.textContaining('Start Adventure'), findsOneWidget);
  });
}
