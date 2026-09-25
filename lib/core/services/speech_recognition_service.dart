import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// State of speech recognition for reactive UI updates (e.g. MicrophoneButton).
enum SpeechRecognitionState {
  idle,
  listening,
  processing,
  success,
  error,
  permissionDenied,
}

/// Diagnostic metadata snapshot for Voice Diagnostics screen.
class SpeechDiagnosticsSnapshot {
  final bool speechAvailable;
  final bool isListening;
  final SpeechRecognitionState state;
  final bool hasPermission;
  final String lastRecognizedText;
  final double lastConfidence;
  final String? lastError;

  const SpeechDiagnosticsSnapshot({
    required this.speechAvailable,
    required this.isListening,
    required this.state,
    required this.hasPermission,
    required this.lastRecognizedText,
    required this.lastConfidence,
    this.lastError,
  });
}

/// Contract for device / platform speech recognition.
abstract class ISpeechRecognitionService {
  Future<bool> isAvailable();
  bool get isListening;
  SpeechRecognitionState get state;
  Stream<SpeechRecognitionState> get stateStream;
  Stream<double> get soundLevelStream;

  Future<void> startListening({
    required void Function(String recognizedText, double confidence) onResult,
    void Function(String error)? onError,
    Duration listenFor = const Duration(seconds: 8),
    Duration pauseFor = const Duration(seconds: 3),
  });

  Future<void> stopListening();
  Future<void> cancel();

  SpeechDiagnosticsSnapshot getDiagnosticsSnapshot();

  /// Normalizes spoken and target text for child-friendly lenient comparison.
  static String normalizeText(String input) {
    var text = input.toLowerCase().trim();

    // Expand common contractions
    text = text
        .replaceAll("it's", 'it is')
        .replaceAll("that's", 'that is')
        .replaceAll("this's", 'this is')
        .replaceAll("i'm", 'i am')
        .replaceAll("he's", 'he is')
        .replaceAll("she's", 'she is')
        .replaceAll("they're", 'they are')
        .replaceAll("we're", 'we are')
        .replaceAll("don't", 'do not')
        .replaceAll("can't", 'cannot');

    // Remove punctuation
    text = text.replaceAll(RegExp(r'[^\w\s]'), '');

    // Normalize multiple spaces
    text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    return text;
  }

  /// Calculates similarity score between 0.0 and 1.0.
  static double calculateSimilarity(String target, String spoken) {
    final normTarget = normalizeText(target);
    final normSpoken = normalizeText(spoken);

    if (normTarget.isEmpty || normSpoken.isEmpty) return 0.0;
    if (normTarget == normSpoken) return 1.0;

    final targetWords = normTarget.split(' ');
    final spokenWords = normSpoken.split(' ');

    // Check token overlap
    int matchingTokens = 0;
    for (final word in targetWords) {
      if (spokenWords.contains(word)) {
        matchingTokens++;
      }
    }

    final tokenRatio = matchingTokens / targetWords.length;

    // Check substring inclusion
    if (normSpoken.contains(normTarget) || normTarget.contains(normSpoken)) {
      return (tokenRatio + 0.9) / 2;
    }

    return tokenRatio;
  }
}

/// Production Device Speech Recognition Service using `speech_to_text`.
class DeviceSpeechRecognitionService implements ISpeechRecognitionService {
  SpeechToText? _speech;
  bool _isAvailable = false;
  bool _hasPermission = false;
  SpeechRecognitionState _state = SpeechRecognitionState.idle;

  final _stateController = StreamController<SpeechRecognitionState>.broadcast();
  final _soundLevelController = StreamController<double>.broadcast();

  String _lastRecognizedText = '';
  double _lastConfidence = 0.0;
  String? _lastError;

  DeviceSpeechRecognitionService() {
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      if (!kIsWeb) {
        _speech = SpeechToText();
        _isAvailable = await _speech!.initialize(
          onError: _handleError,
          onStatus: _handleStatus,
          debugLogging: kDebugMode,
        );
        _hasPermission = await _speech!.hasPermission;
      } else {
        _isAvailable = false; // Web fallback mode
      }
    } catch (e) {
      _lastError = e.toString();
      _isAvailable = false;
      dev.log('⚠️ [SpeechService:Init Error] $e');
    }
  }

  void _handleStatus(String status) {
    dev.log('🎙️ [SpeechService:Status] $status');
    if (status == 'listening') {
      _setState(SpeechRecognitionState.listening);
    } else if (status == 'notListening' || status == 'done') {
      if (_state == SpeechRecognitionState.listening) {
        _setState(SpeechRecognitionState.processing);
      }
    }
  }

  void _handleError(SpeechRecognitionError error) {
    dev.log('⚠️ [SpeechService:Error] ${error.errorMsg}');
    _lastError = error.errorMsg;
    if (error.errorMsg.toLowerCase().contains('permission')) {
      _setState(SpeechRecognitionState.permissionDenied);
    } else {
      _setState(SpeechRecognitionState.error);
    }
  }

  void _setState(SpeechRecognitionState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  @override
  Future<bool> isAvailable() async {
    if (_speech == null) await _initSpeech();
    return _isAvailable;
  }

  @override
  bool get isListening => _state == SpeechRecognitionState.listening;

  @override
  SpeechRecognitionState get state => _state;

  @override
  Stream<SpeechRecognitionState> get stateStream => _stateController.stream;

  @override
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  @override
  Future<void> startListening({
    required void Function(String recognizedText, double confidence) onResult,
    void Function(String error)? onError,
    Duration listenFor = const Duration(seconds: 8),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    if (_speech == null || !_isAvailable) {
      await _initSpeech();
    }

    if (!_isAvailable || _speech == null) {
      _setState(SpeechRecognitionState.permissionDenied);
      onError?.call('Microphone access is unavailable on this device.');
      return;
    }

    try {
      _setState(SpeechRecognitionState.listening);
      await _speech!.listen(
        onResult: (result) {
          _lastRecognizedText = result.recognizedWords;
          _lastConfidence = result.confidence;
          if (result.finalResult) {
            _setState(SpeechRecognitionState.success);
            onResult(result.recognizedWords, result.confidence);
          }
        },
        listenOptions: SpeechListenOptions(
          listenFor: listenFor,
          pauseFor: pauseFor,
          cancelOnError: true,
        ),
        onSoundLevelChange: (level) {
          _soundLevelController.add(level);
        },
      );
    } catch (e) {
      _lastError = e.toString();
      _setState(SpeechRecognitionState.error);
      onError?.call(e.toString());
    }
  }

  @override
  Future<void> stopListening() async {
    try {
      if (_speech != null && _speech!.isListening) {
        await _speech!.stop();
      }
    } catch (e) {
      dev.log('⚠️ [SpeechService:Stop Error] $e');
    } finally {
      _setState(SpeechRecognitionState.idle);
    }
  }

  @override
  Future<void> cancel() async {
    try {
      if (_speech != null && _speech!.isListening) {
        await _speech!.cancel();
      }
    } catch (e) {
      dev.log('⚠️ [SpeechService:Cancel Error] $e');
    } finally {
      _setState(SpeechRecognitionState.idle);
    }
  }

  @override
  SpeechDiagnosticsSnapshot getDiagnosticsSnapshot() {
    return SpeechDiagnosticsSnapshot(
      speechAvailable: _isAvailable,
      isListening: isListening,
      state: _state,
      hasPermission: _hasPermission,
      lastRecognizedText: _lastRecognizedText,
      lastConfidence: _lastConfidence,
      lastError: _lastError,
    );
  }
}

/// Fallback / Mock Speech Recognition implementation for testing and web simulation.
class MockSpeechRecognitionService implements ISpeechRecognitionService {
  SpeechRecognitionState _state = SpeechRecognitionState.idle;
  final _stateController = StreamController<SpeechRecognitionState>.broadcast();
  final _soundLevelController = StreamController<double>.broadcast();

  String? _simulatedSpeech;
  String _lastRecognizedText = '';
  final double _lastConfidence = 0.95;

  @override
  bool get isListening => _state == SpeechRecognitionState.listening;

  @override
  SpeechRecognitionState get state => _state;

  @override
  Stream<SpeechRecognitionState> get stateStream => _stateController.stream;

  @override
  Stream<double> get soundLevelStream => _soundLevelController.stream;

  void setSimulatedSpeech(String speech) {
    _simulatedSpeech = speech;
  }

  @override
  Future<bool> isAvailable() async => true;

  @override
  Future<void> startListening({
    required void Function(String recognizedText, double confidence) onResult,
    void Function(String error)? onError,
    Duration listenFor = const Duration(seconds: 8),
    Duration pauseFor = const Duration(seconds: 3),
  }) async {
    _state = SpeechRecognitionState.listening;
    _stateController.add(_state);

    // Simulate recognition delay
    Timer(const Duration(milliseconds: 600), () {
      if (_state == SpeechRecognitionState.listening) {
        _state = SpeechRecognitionState.success;
        _stateController.add(_state);
        final result = _simulatedSpeech ?? 'This is a cat';
        _lastRecognizedText = result;
        onResult(result, _lastConfidence);
      }
    });
  }

  @override
  Future<void> stopListening() async {
    _state = SpeechRecognitionState.idle;
    _stateController.add(_state);
  }

  @override
  Future<void> cancel() async {
    _state = SpeechRecognitionState.idle;
    _stateController.add(_state);
  }

  @override
  SpeechDiagnosticsSnapshot getDiagnosticsSnapshot() {
    return SpeechDiagnosticsSnapshot(
      speechAvailable: true,
      isListening: isListening,
      state: _state,
      hasPermission: true,
      lastRecognizedText: _lastRecognizedText,
      lastConfidence: _lastConfidence,
    );
  }
}

/// Global provider for speech recognition service.
final speechRecognitionServiceProvider = Provider<ISpeechRecognitionService>((ref) {
  return DeviceSpeechRecognitionService();
});
