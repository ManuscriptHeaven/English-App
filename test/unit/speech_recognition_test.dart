import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';

void main() {
  group('Speech Recognition Normalization & Similarity Tests', () {
    test('Normalizes text by removing punctuation, lowercasing, and expanding contractions', () {
      expect(
        ISpeechRecognitionService.normalizeText("This is a cat!"),
        equals('this is a cat'),
      );

      expect(
        ISpeechRecognitionService.normalizeText("  It's   my room.  "),
        equals('it is my room'),
      );

      expect(
        ISpeechRecognitionService.normalizeText("I'm helping Mother!"),
        equals('i am helping mother'),
      );

      expect(
        ISpeechRecognitionService.normalizeText("Don't hurt the cat."),
        equals('do not hurt the cat'),
      );
    });

    test('Calculates similarity score accurately for exact and close matches', () {
      // Exact match
      expect(
        ISpeechRecognitionService.calculateSimilarity('This is a cat', 'this is a cat'),
        equals(1.0),
      );

      // Exact match with contractions
      expect(
        ISpeechRecognitionService.calculateSimilarity('It is my room', "it's my room"),
        equals(1.0),
      );

      // Partial match (3 out of 4 words)
      final partialScore = ISpeechRecognitionService.calculateSimilarity('This is a cat', 'this is a');
      expect(partialScore, greaterThanOrEqualTo(0.75));

      // Mismatch
      final lowScore = ISpeechRecognitionService.calculateSimilarity('Elephant', 'Lion');
      expect(lowScore, lessThan(0.5));
    });

    test('MockSpeechRecognitionService delivers simulated speech result', () async {
      final mock = MockSpeechRecognitionService();
      mock.setSimulatedSpeech('This is an elephant');

      String? recognized;
      double? conf;

      await mock.startListening(
        onResult: (text, confidence) {
          recognized = text;
          conf = confidence;
        },
      );

      await Future.delayed(const Duration(milliseconds: 600));

      expect(recognized, equals('This is an elephant'));
      expect(conf, equals(0.95));
    });
  });
}
