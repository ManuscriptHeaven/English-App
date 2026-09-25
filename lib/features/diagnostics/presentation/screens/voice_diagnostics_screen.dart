import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/services/speech_recognition_service.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/core/widgets/app_card.dart';

/// Internal Developer Diagnostics Screen for Voice, TTS, and Speech Recognition.
class VoiceDiagnosticsScreen extends ConsumerStatefulWidget {
  const VoiceDiagnosticsScreen({super.key});

  @override
  ConsumerState<VoiceDiagnosticsScreen> createState() => _VoiceDiagnosticsScreenState();
}

class _VoiceDiagnosticsScreenState extends ConsumerState<VoiceDiagnosticsScreen> {
  Timer? _refreshTimer;
  String _micResultText = 'Press "TEST MICROPHONE" to speak';
  double _micConfidence = 0.0;
  String _lastTriggered = 'None';

  @override
  void initState() {
    super.initState();
    // Auto-refresh snapshot telemetry every 500ms
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _testWord() {
    setState(() => _lastTriggered = 'TEST WORD: "Cat."');
    ref.read(audioServiceProvider).playWord('Cat.');
  }

  void _testSentence() {
    setState(() => _lastTriggered = 'TEST SENTENCE: "This is a cat."');
    ref.read(audioServiceProvider).playSentence('This is a cat.');
  }

  void _testStory() {
    setState(() => _lastTriggered = 'TEST STORY: "The cat is small."');
    ref.read(audioServiceProvider).playStoryNarration('The cat is small.');
  }

  void _testTts() {
    setState(() => _lastTriggered = 'TEST TTS: "Can I borrow a pencil, please?"');
    ref.read(audioServiceProvider).playDialogue('Pip', 'Can I borrow a pencil, please?');
  }

  void _testMicrophone() async {
    final speechService = ref.read(speechRecognitionServiceProvider);
    setState(() {
      _lastTriggered = 'TEST MICROPHONE (Target: "cat")';
      _micResultText = 'Listening... Speak now 🎙️';
    });

    await speechService.startListening(
      onResult: (spoken, confidence) {
        if (!mounted) return;
        final similarity = ISpeechRecognitionService.calculateSimilarity('cat', spoken);
        setState(() {
          _micResultText = 'Spoken: "$spoken" (Match: ${(similarity * 100).toStringAsFixed(1)}%)';
          _micConfidence = confidence;
        });
      },
      onError: (err) {
        if (!mounted) return;
        setState(() {
          _micResultText = 'Mic Error: $err';
        });
      },
    );
  }

  void _stopAudio() {
    setState(() => _lastTriggered = 'STOP AUDIO');
    ref.read(audioServiceProvider).stop();
    ref.read(speechRecognitionServiceProvider).stopListening();
  }

  @override
  Widget build(BuildContext context) {
    final audioService = ref.watch(audioServiceProvider);
    final speechService = ref.watch(speechRecognitionServiceProvider);

    final audioSnapshot = audioService.getDiagnosticsSnapshot();
    final speechSnapshot = speechService.getDiagnosticsSnapshot();

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2E), // Professional dark telemetry aesthetic
      appBar: AppBar(
        title: const Text('🎙️ Voice & Audio Diagnostics [DEV]'),
        backgroundColor: const Color(0xFF181825),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Warning Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(40),
                borderRadius: AppRadius.roundedSm,
                border: Border.all(color: Colors.amber),
              ),
              child: const Row(
                children: [
                  Icon(Icons.security, color: Colors.amber),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'DEVELOPER ACCESS ONLY — Real-time Platform Audio Telemetry & TTS Diagnostics.',
                      style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TTS Telemetry Card
            AppCard(
              backgroundColor: const Color(0xFF24273A),
              borderColor: audioSnapshot.ttsInitialized ? Colors.green : Colors.red,
              borderWidth: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('TTS ENGINE STATUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: audioSnapshot.isPlaying ? Colors.green : Colors.grey,
                          borderRadius: AppRadius.roundedSm,
                        ),
                        child: Text(
                          audioSnapshot.isPlaying ? 'PLAYING 🔊' : 'IDLE ⏹️',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  _buildDiagnosticRow('TTS Available / Initialized', audioSnapshot.ttsInitialized ? 'YES ✅' : 'NO ❌', Colors.green),
                  _buildDiagnosticRow('Current Voice', audioSnapshot.currentVoice, Colors.cyan),
                  _buildDiagnosticRow('Speech Rate', audioSnapshot.speechRate.toStringAsFixed(2), Colors.white),
                  _buildDiagnosticRow('Volume', audioSnapshot.volume.toStringAsFixed(2), Colors.white),
                  _buildDiagnosticRow('Muted (SFX Off)', audioSnapshot.isMuted ? 'YES 🔇' : 'NO 🔊', Colors.white),
                  _buildDiagnosticRow('Current Priority', audioSnapshot.currentPriority?.name ?? 'None', Colors.amber),
                  _buildDiagnosticRow('Last Command Triggered', _lastTriggered, Colors.amberAccent),
                  _buildDiagnosticRow('Last Spoken Utterance', audioSnapshot.lastSpokenText.isEmpty ? '(none)' : '"${audioSnapshot.lastSpokenText}"', Colors.yellow),
                  _buildDiagnosticRow('Last Error', audioSnapshot.lastError ?? 'None', audioSnapshot.lastError != null ? Colors.redAccent : Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Speech Recognition Telemetry Card
            AppCard(
              backgroundColor: const Color(0xFF24273A),
              borderColor: speechSnapshot.hasPermission ? Colors.green : Colors.orange,
              borderWidth: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('SPEECH RECOGNITION STATUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: speechSnapshot.isListening ? Colors.red : Colors.grey,
                          borderRadius: AppRadius.roundedSm,
                        ),
                        child: Text(
                          speechSnapshot.isListening ? 'LISTENING 🔴' : 'IDLE 🎤',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white24, height: 20),
                  _buildDiagnosticRow('Speech Recognizer Available', speechSnapshot.speechAvailable ? 'YES ✅' : 'NO / FALLBACK ⚠️', Colors.green),
                  _buildDiagnosticRow('Microphone Permission', speechSnapshot.hasPermission ? 'GRANTED ✅' : 'DENIED / PENDING ⚠️', Colors.green),
                  _buildDiagnosticRow('Recognition State', speechSnapshot.state.name, Colors.cyan),
                  _buildDiagnosticRow('Live Test Result', _micResultText, Colors.lightGreenAccent),
                  _buildDiagnosticRow('Confidence', '${(_micConfidence * 100).toStringAsFixed(1)}%', Colors.white),
                  _buildDiagnosticRow('Last Error', speechSnapshot.lastError ?? 'None', speechSnapshot.lastError != null ? Colors.redAccent : Colors.white70),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Diagnostic Action Buttons Grid
            Text('DIAGNOSTIC TEST CONTROLS', style: AppTypography.headlineMedium.copyWith(color: Colors.white70)),
            const SizedBox(height: 12),

            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton('TEST WORD 🐱', Colors.blue, _testWord),
                _buildActionButton('TEST SENTENCE 📝', Colors.teal, _testSentence),
                _buildActionButton('TEST STORY 📖', Colors.indigo, _testStory),
                _buildActionButton('TEST TTS 🗣️', Colors.purple, _testTts),
                _buildActionButton('TEST MICROPHONE 🎤', Colors.deepOrange, _testMicrophone),
                _buildActionButton('STOP AUDIO ⏹️', Colors.red, _stopAudio),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return SizedBox(
      width: 160,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedSm),
        ),
        onPressed: onTap,
        child: Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}
