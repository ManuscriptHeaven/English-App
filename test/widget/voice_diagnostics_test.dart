import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/features/diagnostics/presentation/screens/voice_diagnostics_screen.dart';

void main() {
  testWidgets('VoiceDiagnosticsScreen renders developer telemetry cards and action buttons', (WidgetTester tester) async {
    final mockAudio = MockAudioService();
    final mockSpeech = MockSpeechRecognitionService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioServiceProvider.overrideWithValue(mockAudio),
          speechRecognitionServiceProvider.overrideWithValue(mockSpeech),
        ],
        child: const MaterialApp(
          home: VoiceDiagnosticsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title & Security Banner
    expect(find.text('🎙️ Voice & Audio Diagnostics [DEV]'), findsOneWidget);
    expect(find.textContaining('DEVELOPER ACCESS ONLY'), findsOneWidget);

    // Verify Telemetry Cards
    expect(find.text('TTS ENGINE STATUS'), findsOneWidget);
    expect(find.text('SPEECH RECOGNITION STATUS'), findsOneWidget);

    // Verify Diagnostic Action Buttons
    expect(find.text('TEST WORD 🐱'), findsOneWidget);
    expect(find.text('TEST SENTENCE 📝'), findsOneWidget);
    expect(find.text('TEST STORY 📖'), findsOneWidget);
    expect(find.text('TEST TTS 🗣️'), findsOneWidget);
    expect(find.text('TEST MICROPHONE 🎤'), findsOneWidget);
    expect(find.text('STOP AUDIO ⏹️'), findsOneWidget);

    // Tap Test Word button
    await tester.ensureVisible(find.text('TEST WORD 🐱'));
    await tester.tap(find.text('TEST WORD 🐱'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    // Verify last command row updated
    expect(find.textContaining('TEST WORD'), findsWidgets);
  });
}
