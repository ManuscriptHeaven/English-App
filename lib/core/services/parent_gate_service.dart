import 'dart:math';

/// Challenge generated for the Parent Gate.
class ParentGateChallenge {
  final String question;
  final int correctAnswer;
  final List<int> options;

  const ParentGateChallenge({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });
}

/// Service to generate and verify parent security challenges.
class ParentGateService {
  final Random _random = Random();
  String _savedPin = '1234'; // Default PIN for initial development

  ParentGateChallenge generateMathChallenge() {
    final num1 = _random.nextInt(8) + 12; // 12-19
    final num2 = _random.nextInt(7) + 3;  // 3-9
    final isMultiply = _random.nextBool();

    final int answer;
    final String question;

    if (isMultiply) {
      final a = _random.nextInt(7) + 3; // 3-9
      final b = _random.nextInt(7) + 3; // 3-9
      answer = a * b;
      question = '$a × $b = ?';
    } else {
      answer = num1 + num2;
      question = '$num1 + $num2 = ?';
    }

    final options = <int>{answer};
    while (options.length < 4) {
      final delta = (_random.nextInt(10) + 1) * (_random.nextBool() ? 1 : -1);
      final distractor = answer + delta;
      if (distractor > 0) {
        options.add(distractor);
      }
    }

    final shuffledOptions = options.toList()..shuffle(_random);

    return ParentGateChallenge(
      question: question,
      correctAnswer: answer,
      options: shuffledOptions,
    );
  }

  bool verifyChallengeAnswer(int givenAnswer, int correctAnswer) {
    return givenAnswer == correctAnswer;
  }

  bool verifyPin(String enteredPin) {
    return enteredPin.trim() == _savedPin;
  }

  void updatePin(String newPin) {
    _savedPin = newPin;
  }
}
