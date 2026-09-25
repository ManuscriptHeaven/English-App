import 'package:flutter_test/flutter_test.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';

void main() {
  group('P0: Voice, Audio Priority & Speech Recognition Tests', () {
    late MockAudioService audioService;
    late MockSpeechRecognitionService speechService;

    setUp(() {
      audioService = MockAudioService();
      speechService = MockSpeechRecognitionService();
    });

    test('Audio Priority correctly identifies interrupt rules', () {
      expect(AudioPriority.safety.canInterrupt(AudioPriority.storyNarration), isTrue);
      expect(AudioPriority.storyNarration.canInterrupt(AudioPriority.learningInstruction), isTrue);
      expect(AudioPriority.characterDialogue.canInterrupt(AudioPriority.safety), isFalse);
      expect(AudioPriority.backgroundMusic.canInterrupt(AudioPriority.vocabularyPronunciation), isFalse);
    });

    test('Age-adaptive speech rate adjusts correctly for age brackets', () async {
      await audioService.setAgeAdaptiveRate(4); // Toddler
      expect(audioService.speechRate, equals(0.35));

      await audioService.setAgeAdaptiveRate(6); // Early learner
      expect(audioService.speechRate, equals(0.42));

      await audioService.setAgeAdaptiveRate(8); // Young reader
      expect(audioService.speechRate, equals(0.48));
    });

    test('Speech normalization handles contractions, punctuation, and whitespace', () {
      final input1 = "It's a big, friendly CAT! ";
      final norm1 = ISpeechRecognitionService.normalizeText(input1);
      expect(norm1, equals('it is a big friendly cat'));

      final input2 = "Can't   I borrow, please?";
      final norm2 = ISpeechRecognitionService.normalizeText(input2);
      expect(norm2, equals('cannot i borrow please'));
    });

    test('Speech similarity scoring accurately scores exact, partial, and token matches', () {
      final exactScore = ISpeechRecognitionService.calculateSimilarity('Cat', 'cat');
      expect(exactScore, equals(1.0));

      final partialScore = ISpeechRecognitionService.calculateSimilarity('This is a cat', 'is a cat');
      expect(partialScore, greaterThanOrEqualTo(0.6));

      final mismatchScore = ISpeechRecognitionService.calculateSimilarity('Pencil', 'Elephant');
      expect(mismatchScore, equals(0.0));
    });

    test('Audio playback state stream emits transitions', () async {
      final states = <AudioPlaybackState>[];
      final subscription = audioService.stateStream.listen(states.add);

      await audioService.playWord('Cat');
      await audioService.stop();

      await Future.delayed(const Duration(milliseconds: 50));
      expect(states, contains(AudioPlaybackState.playing));
      expect(states, contains(AudioPlaybackState.idle));

      await subscription.cancel();
    });

    test('Voice Diagnostics snapshot reflects real-time telemetry', () {
      final snapshot = audioService.getDiagnosticsSnapshot();
      expect(snapshot.ttsInitialized, isTrue);
      expect(snapshot.speechRate, equals(0.45));
      expect(snapshot.currentVoice, contains('en-US'));

      final speechSnapshot = speechService.getDiagnosticsSnapshot();
      expect(speechSnapshot.speechAvailable, isTrue);
      expect(speechSnapshot.hasPermission, isTrue);
    });
  });
}
