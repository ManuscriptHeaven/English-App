import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/widgets/child_table_visual.dart';

void main() {
  testWidgets('Verify ChildTableVisual alone and with book on table', (tester) async {
    tester.view.physicalSize = const Size(400 * 2, 400 * 2);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: const Color(0xFFFFF9EE),
          body: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                // 1. Standalone Table (Clear tabletop, 4 legs, support crossbeam)
                ChildTableVisual(
                  width: 140,
                  height: 100,
                  hasBookOnTop: false,
                ),
                // 2. Table with Book resting ON tabletop
                ChildTableVisual(
                  width: 140,
                  height: 100,
                  hasBookOnTop: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/child_table_visual_preview.png'),
    );
  });
}
