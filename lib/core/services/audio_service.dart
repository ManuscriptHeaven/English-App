import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Audio priority levels for the centralized audio priority system.
enum AudioPriority {
  safety(1),
  storyNarration(2),
  learningInstruction(3),
  vocabularyPronunciation(4),
  characterDialogue(5),
  gameFeedback(6),
  backgroundMusic(7);

  final int value;
  const AudioPriority(this.value);

  bool canInterrupt(AudioPriority other) => value <= other.value;
}

/// Playback state for UI components like AudioPlayButton.
enum AudioPlaybackState {
  idle,
  loading,
  playing,
  paused,
  error,
}

/// Sound effect types.
enum SoundEffect {
  click,
  correct,
  tryAgain,
  starEarned,
  levelComplete,
  rewardUnlocked,
}

/// Diagnostic metadata snapshot for Voice Diagnostics screen.
class AudioDiagnosticsSnapshot {
  final bool ttsInitialized;
  final bool isPlaying;
  final String currentVoice;
  final double speechRate;
  final double volume;
  final bool isMuted;
  final String lastSpokenText;
  final AudioPriority? currentPriority;
  final String? lastError;
  final DateTime? lastPlaybackTime;

  const AudioDiagnosticsSnapshot({
    required this.ttsInitialized,
    required this.isPlaying,
    required this.currentVoice,
    required this.speechRate,
    required this.volume,
    required this.isMuted,
    required this.lastSpokenText,
    this.currentPriority,
    this.lastError,
    this.lastPlaybackTime,
  });
}

/// Abstract contract for audio playback and text-to-speech services.
abstract class IAudioService {
  // Speech & Narration
  Future<void> playWord(String word, {String? assetPath, AudioPriority priority = AudioPriority.vocabularyPronunciation});
  Future<void> playSentence(String sentence, {String? assetPath, AudioPriority priority = AudioPriority.learningInstruction});
  Future<void> playStoryNarration(String text, {String? assetPath, AudioPriority priority = AudioPriority.storyNarration});
  Future<void> playDialogue(String character, String text, {AudioPriority priority = AudioPriority.characterDialogue});
  Future<void> playGamePrompt(String prompt, {AudioPriority priority = AudioPriority.learningInstruction});

  // Backward-compatible helpers
  Future<void> playWordPronunciation(String word, {String? audioUrl});
  Future<void> playNarration(String audioUrl);

  // SFX shortcuts
  Future<void> playSuccess();
  Future<void> playRetry();
  Future<void> playReward();
  Future<void> playSoundEffect(SoundEffect effect);

  // Controls
  Future<void> stop();
  Future<void> stopNarration();
  Future<void> pause();
  Future<void> resume();

  // Settings & Configuration
  Future<void> setMusicEnabled(bool enabled);
  Future<void> setSfxEnabled(bool enabled);
  Future<void> setSpeechRate(double rate);
  Future<void> setAgeAdaptiveRate(int childAge);

  bool get isMusicEnabled;
  bool get isSfxEnabled;
  double get speechRate;
  bool get isPlaying;
  AudioPlaybackState get playbackState;

  // Streams & Diagnostics
  Stream<AudioPlaybackState> get stateStream;
  AudioDiagnosticsSnapshot getDiagnosticsSnapshot();
}

/// Production Device Audio Service with FlutterTts & Centralized Priority System.
class DeviceAudioService implements IAudioService {
  FlutterTts? _flutterTts;
  bool _isInitialized = false;
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _speechRate = 0.45; // FlutterTts normal is ~0.5, 0.45 is clear & child-friendly
  final double _volume = 1.0;
  double _pitch = 1.05; // Slightly warm/friendly pitch for kids

  AudioPlaybackState _playbackState = AudioPlaybackState.idle;
  final _stateController = StreamController<AudioPlaybackState>.broadcast();

  AudioPriority? _currentPriority;
  String _lastSpokenText = '';
  String? _lastError;
  DateTime? _lastPlaybackTime;
  DateTime? _lastSpeakCallTime;

  DeviceAudioService() {
    _initTts();
  }

  Future<void> _initTts() async {
    if (_isInitialized) return;
    try {
      if (!kIsWeb) {
        _flutterTts = FlutterTts();
        await _flutterTts!.setLanguage('en-US');
        await _flutterTts!.setSpeechRate(_speechRate);
        await _flutterTts!.setVolume(_volume);
        await _flutterTts!.setPitch(_pitch);

        _flutterTts!.setStartHandler(() {
          _setPlaybackState(AudioPlaybackState.playing);
        });

        _flutterTts!.setCompletionHandler(() {
          _currentPriority = null;
          _setPlaybackState(AudioPlaybackState.idle);
        });

        _flutterTts!.setCancelHandler(() {
          _currentPriority = null;
          _setPlaybackState(AudioPlaybackState.idle);
        });

        _flutterTts!.setErrorHandler((msg) {
          _lastError = msg.toString();
          dev.log('⚠️ [AudioService:TTS Error] $msg');
          _currentPriority = null;
          _setPlaybackState(AudioPlaybackState.idle);
        });
      }
      _isInitialized = true;
    } catch (e) {
      _lastError = e.toString();
      dev.log('⚠️ [AudioService:Init Error] $e');
      _isInitialized = true; // Fallback mode active
    }
  }

  void _setPlaybackState(AudioPlaybackState state) {
    _playbackState = state;
    _stateController.add(state);
  }

  /// Centralized speech coordinator with priority and rapid-tap debouncing.
  Future<void> _speak(String text, AudioPriority priority) async {
    final now = DateTime.now();

    // 1. Rapid-tap debounce: If the exact same text was requested within 400ms and is playing, ignore
    if (_lastSpokenText == text &&
        _lastSpeakCallTime != null &&
        now.difference(_lastSpeakCallTime!).inMilliseconds < 400 &&
        _playbackState == AudioPlaybackState.playing) {
      return;
    }
    _lastSpeakCallTime = now;

    // 2. Priority check: If a higher priority audio is playing, do not interrupt
    if (_currentPriority != null && _playbackState == AudioPlaybackState.playing) {
      if (!priority.canInterrupt(_currentPriority!)) {
        dev.log('🛑 [AudioService] Ignored lower priority audio ($priority) during ($_currentPriority)');
        return;
      }
      // Interrupt current lower priority
      await stop();
    }

    _currentPriority = priority;
    _lastSpokenText = text;
    _lastPlaybackTime = now;
    _setPlaybackState(AudioPlaybackState.loading);

    try {
      if (_flutterTts != null && !kIsWeb) {
        await _flutterTts!.setSpeechRate(_speechRate);
        await _flutterTts!.setPitch(_pitch);
        final result = await _flutterTts!.speak(text);
        if (result == 1) {
          _setPlaybackState(AudioPlaybackState.playing);
        } else {
          _setPlaybackState(AudioPlaybackState.idle);
        }
      } else {
        // Web / Desktop simulated speech fallback
        _setPlaybackState(AudioPlaybackState.playing);
        dev.log('🗣️ [AudioService:Simulated] ($priority) "$text"');
        final estimatedDurationMs = (text.split(' ').length * 350).clamp(600, 4000);
        Future.delayed(Duration(milliseconds: estimatedDurationMs), () {
          if (_lastSpokenText == text) {
            _currentPriority = null;
            _setPlaybackState(AudioPlaybackState.idle);
          }
        });
      }
    } catch (e) {
      _lastError = e.toString();
      dev.log('⚠️ [AudioService:Speak Error] $e');
      _currentPriority = null;
      _setPlaybackState(AudioPlaybackState.idle);
    }
  }

  @override
  Future<void> playWord(String word, {String? assetPath, AudioPriority priority = AudioPriority.vocabularyPronunciation}) async {
    await _speak(word, priority);
  }

  @override
  Future<void> playSentence(String sentence, {String? assetPath, AudioPriority priority = AudioPriority.learningInstruction}) async {
    await _speak(sentence, priority);
  }

  @override
  Future<void> playStoryNarration(String text, {String? assetPath, AudioPriority priority = AudioPriority.storyNarration}) async {
    await _speak(text, priority);
  }

  @override
  Future<void> playDialogue(String character, String text, {AudioPriority priority = AudioPriority.characterDialogue}) async {
    await _speak(text, priority);
  }

  @override
  Future<void> playGamePrompt(String prompt, {AudioPriority priority = AudioPriority.learningInstruction}) async {
    await _speak(prompt, priority);
  }

  @override
  Future<void> playWordPronunciation(String word, {String? audioUrl}) => playWord(word);

  @override
  Future<void> playNarration(String audioUrl) => playStoryNarration(audioUrl);

  @override
  Future<void> playSuccess() => playSoundEffect(SoundEffect.correct);

  @override
  Future<void> playRetry() => playSoundEffect(SoundEffect.tryAgain);

  @override
  Future<void> playReward() => playSoundEffect(SoundEffect.rewardUnlocked);

  @override
  Future<void> playSoundEffect(SoundEffect effect) async {
    if (!_sfxEnabled) return;
    dev.log('🔊 [AudioService:SFX] ${effect.name}');
  }

  @override
  Future<void> stop() async {
    try {
      if (_flutterTts != null && !kIsWeb) {
        await _flutterTts!.stop();
      }
    } catch (e) {
      dev.log('⚠️ [AudioService:Stop Error] $e');
    } finally {
      _currentPriority = null;
      _setPlaybackState(AudioPlaybackState.idle);
    }
  }

  @override
  Future<void> stopNarration() => stop();

  @override
  Future<void> pause() async {
    try {
      if (_flutterTts != null && !kIsWeb) {
        await _flutterTts!.pause();
      }
    } catch (e) {
      dev.log('⚠️ [AudioService:Pause Error] $e');
    } finally {
      _setPlaybackState(AudioPlaybackState.paused);
    }
  }

  @override
  Future<void> resume() async {
    _setPlaybackState(AudioPlaybackState.playing);
  }

  @override
  Future<void> setMusicEnabled(bool enabled) async {
    _musicEnabled = enabled;
  }

  @override
  Future<void> setSfxEnabled(bool enabled) async {
    _sfxEnabled = enabled;
  }

  @override
  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.25, 0.85);
    if (_flutterTts != null && !kIsWeb) {
      await _flutterTts!.setSpeechRate(_speechRate);
    }
  }

  @override
  Future<void> setAgeAdaptiveRate(int childAge) async {
    if (childAge <= 4) {
      _speechRate = 0.35; // slower, very clear
      _pitch = 1.10;
    } else if (childAge <= 6) {
      _speechRate = 0.42; // slightly relaxed
      _pitch = 1.05;
    } else if (childAge <= 8) {
      _speechRate = 0.48; // natural
      _pitch = 1.0;
    } else {
      _speechRate = 0.52; // fluent
      _pitch = 1.0;
    }

    if (_flutterTts != null && !kIsWeb) {
      await _flutterTts!.setSpeechRate(_speechRate);
      await _flutterTts!.setPitch(_pitch);
    }
  }

  @override
  bool get isMusicEnabled => _musicEnabled;

  @override
  bool get isSfxEnabled => _sfxEnabled;

  @override
  double get speechRate => _speechRate;

  @override
  bool get isPlaying => _playbackState == AudioPlaybackState.playing;

  @override
  AudioPlaybackState get playbackState => _playbackState;

  @override
  Stream<AudioPlaybackState> get stateStream => _stateController.stream;

  @override
  AudioDiagnosticsSnapshot getDiagnosticsSnapshot() {
    return AudioDiagnosticsSnapshot(
      ttsInitialized: _isInitialized,
      isPlaying: isPlaying,
      currentVoice: 'en-US (Child Default)',
      speechRate: _speechRate,
      volume: _volume,
      isMuted: !_sfxEnabled,
      lastSpokenText: _lastSpokenText,
      currentPriority: _currentPriority,
      lastError: _lastError,
      lastPlaybackTime: _lastPlaybackTime,
    );
  }
}

/// Fallback / Mock audio service for unit testing without platform channels.
class MockAudioService implements IAudioService {
  bool _musicEnabled = true;
  bool _sfxEnabled = true;
  double _speechRate = 0.45;
  AudioPlaybackState _playbackState = AudioPlaybackState.idle;
  final _stateController = StreamController<AudioPlaybackState>.broadcast();
  String _lastSpokenText = '';
  AudioPriority? _currentPriority;

  @override
  bool get isMusicEnabled => _musicEnabled;

  @override
  bool get isSfxEnabled => _sfxEnabled;

  @override
  double get speechRate => _speechRate;

  @override
  bool get isPlaying => _playbackState == AudioPlaybackState.playing;

  @override
  AudioPlaybackState get playbackState => _playbackState;

  @override
  Stream<AudioPlaybackState> get stateStream => _stateController.stream;

  @override
  Future<void> playWord(String word, {String? assetPath, AudioPriority priority = AudioPriority.vocabularyPronunciation}) async {
    _lastSpokenText = word;
    _currentPriority = priority;
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
    dev.log('🗣️ [MockAudio:Word] "$word"');
  }

  @override
  Future<void> playSentence(String sentence, {String? assetPath, AudioPriority priority = AudioPriority.learningInstruction}) async {
    _lastSpokenText = sentence;
    _currentPriority = priority;
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
    dev.log('🗣️ [MockAudio:Sentence] "$sentence"');
  }

  @override
  Future<void> playStoryNarration(String text, {String? assetPath, AudioPriority priority = AudioPriority.storyNarration}) async {
    _lastSpokenText = text;
    _currentPriority = priority;
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
    dev.log('📖 [MockAudio:Story] "$text"');
  }

  @override
  Future<void> playDialogue(String character, String text, {AudioPriority priority = AudioPriority.characterDialogue}) async {
    _lastSpokenText = text;
    _currentPriority = priority;
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
    dev.log('💬 [MockAudio:Dialogue] $character: "$text"');
  }

  @override
  Future<void> playGamePrompt(String prompt, {AudioPriority priority = AudioPriority.learningInstruction}) async {
    _lastSpokenText = prompt;
    _currentPriority = priority;
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
    dev.log('🎮 [MockAudio:GamePrompt] "$prompt"');
  }

  @override
  Future<void> playWordPronunciation(String word, {String? audioUrl}) => playWord(word);

  @override
  Future<void> playNarration(String audioUrl) => playStoryNarration(audioUrl);

  @override
  Future<void> playSuccess() => playSoundEffect(SoundEffect.correct);

  @override
  Future<void> playRetry() => playSoundEffect(SoundEffect.tryAgain);

  @override
  Future<void> playReward() => playSoundEffect(SoundEffect.rewardUnlocked);

  @override
  Future<void> playSoundEffect(SoundEffect effect) async {
    if (!_sfxEnabled) return;
    dev.log('🔊 [MockAudio:SFX] ${effect.name}');
  }

  @override
  Future<void> stop() async {
    _playbackState = AudioPlaybackState.idle;
    _currentPriority = null;
    _stateController.add(_playbackState);
  }

  @override
  Future<void> stopNarration() => stop();

  @override
  Future<void> pause() async {
    _playbackState = AudioPlaybackState.paused;
    _stateController.add(_playbackState);
  }

  @override
  Future<void> resume() async {
    _playbackState = AudioPlaybackState.playing;
    _stateController.add(_playbackState);
  }

  @override
  Future<void> setMusicEnabled(bool enabled) async => _musicEnabled = enabled;

  @override
  Future<void> setSfxEnabled(bool enabled) async => _sfxEnabled = enabled;

  @override
  Future<void> setSpeechRate(double rate) async => _speechRate = rate;

  @override
  Future<void> setAgeAdaptiveRate(int childAge) async {
    if (childAge <= 4) {
      _speechRate = 0.35;
    } else if (childAge <= 6) {
      _speechRate = 0.42;
    } else {
      _speechRate = 0.48;
    }
  }

  @override
  AudioDiagnosticsSnapshot getDiagnosticsSnapshot() {
    return AudioDiagnosticsSnapshot(
      ttsInitialized: true,
      isPlaying: isPlaying,
      currentVoice: 'en-US (Mock Test Voice)',
      speechRate: _speechRate,
      volume: 1.0,
      isMuted: !_sfxEnabled,
      lastSpokenText: _lastSpokenText,
      currentPriority: _currentPriority,
      lastPlaybackTime: DateTime.now(),
    );
  }
}

/// Global provider for audio service.
final audioServiceProvider = Provider<IAudioService>((ref) {
  return DeviceAudioService();
});
