import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/services/parent_gate_service.dart';

void main() {
  group('ParentGateService Tests', () {
    late ParentGateService service;

    setUp(() {
      service = ParentGateService();
    });

    test('Generates valid math challenge with 4 options and correct answer included', () {
      final challenge = service.generateMathChallenge();

      expect(challenge.question, isNotEmpty);
      expect(challenge.options.length, equals(4));
      expect(challenge.options.contains(challenge.correctAnswer), isTrue);
    });

    test('Verifies correct math answers accurately', () {
      expect(service.verifyChallengeAnswer(42, 42), isTrue);
      expect(service.verifyChallengeAnswer(41, 42), isFalse);
    });

    test('Verifies default and updated PIN', () {
      expect(service.verifyPin('1234'), isTrue);
      expect(service.verifyPin('0000'), isFalse);

      service.updatePin('9876');
      expect(service.verifyPin('9876'), isTrue);
      expect(service.verifyPin('1234'), isFalse);
    });
  });
}
