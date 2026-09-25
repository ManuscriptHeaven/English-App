import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/features/adventure_brain/domain/services/scaffolding_engine.dart';

void main() {
  group('ScaffoldingEngine Dynamic Difficulty Tests', () {
    test('Steps down difficulty level when child encounters 2 consecutive failures', () {
      final adjusted = ScaffoldingEngine.adjustDifficultyLevel(
        3,
        consecutiveSuccesses: 0,
        consecutiveFailures: 2,
      );
      expect(adjusted, equals(2));
    });

    test('Steps up difficulty level when child achieves 3 consecutive successes', () {
      final adjusted = ScaffoldingEngine.adjustDifficultyLevel(
        2,
        consecutiveSuccesses: 3,
        consecutiveFailures: 0,
      );
      expect(adjusted, equals(3));
    });

    test('Clamps difficulty level strictly between 1 and 5', () {
      expect(
        ScaffoldingEngine.adjustDifficultyLevel(1, consecutiveSuccesses: 0, consecutiveFailures: 3),
        equals(1),
      );
      expect(
        ScaffoldingEngine.adjustDifficultyLevel(5, consecutiveSuccesses: 4, consecutiveFailures: 0),
        equals(5),
      );
    });

    test('Generates Level 1 prompt with audio auto-play and visual hint', () {
      final scaffold = ScaffoldingEngine.scaffoldSentence(
        targetSentence: 'This is a cat',
        difficultyLevel: 1,
        visualEmoji: '🐱',
      );
      expect(scaffold.difficultyLevel, equals(1));
      expect(scaffold.showAudioAutoPlay, isTrue);
      expect(scaffold.visualHint, equals('🐱'));
      expect(scaffold.fixedSlots, equals(['This', 'is', 'a', 'cat']));
    });

    test('Generates Level 4 guided slot fill prompt', () {
      final scaffold = ScaffoldingEngine.scaffoldSentence(
        targetSentence: 'This is a room',
        difficultyLevel: 4,
      );
      expect(scaffold.difficultyLevel, equals(4));
      expect(scaffold.promptText, contains('[ ? ]'));
      expect(scaffold.fixedSlots, equals(['This', 'is', 'a']));
    });
  });
}
