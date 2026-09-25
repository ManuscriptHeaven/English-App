import 'dart:async';
import 'dart:developer' as dev;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';
import 'sound_design_system.dart';

/// Audio priority channel classification for hierarchy management.
enum AudioChannel {
  voice,
  sfx,
  ambientMusic,
}

/// Centralized audio manager coordinating channel concurrency, rapid-tap
/// deduplication, voice audio priority, ducking, and sound cooldowns.
class ChildAudioManager {
  final IAudioService baseAudio;

  bool _sfxEnabled = true;
  bool _voiceEnabled = true;
  bool _musicEnabled = true;

  double _sfxVolume = 1.0;
  double _voiceVolume = 1.0;
  double _musicVolume = 0.5;

  /// Tracks last playback timestamp for each semantic sound to enforce cooldowns.
  final Map<SemanticSound, DateTime> _lastPlaybackTimes = {};

  /// Currently active sound in high-intensity milestone celebration.
  SemanticSound? _activeCelebrationSound;
  DateTime? _celebrationStartTime;

  /// Concurrency counter for active voice playback.
  bool _isVoiceActive = false;

  ChildAudioManager({required this.baseAudio});

  bool get isSfxEnabled => _sfxEnabled;
  bool get isVoiceEnabled => _voiceEnabled;
  bool get isMusicEnabled => _musicEnabled;
  bool get isVoiceActive => _isVoiceActive;
  double get sfxVolume => _sfxVolume;
  double get voiceVolume => _voiceVolume;
  double get musicVolume => _musicVolume;

  void setSfxEnabled(bool enabled) {
    _sfxEnabled = enabled;
    baseAudio.setSfxEnabled(enabled);
  }

  void setVoiceEnabled(bool enabled) {
    _voiceEnabled = enabled;
  }

  void setMusicEnabled(bool enabled) {
    _musicEnabled = enabled;
    baseAudio.setMusicEnabled(enabled);
  }

  void setSfxVolume(double volume) => _sfxVolume = volume.clamp(0.0, 1.0);
  void setVoiceVolume(double volume) => _voiceVolume = volume.clamp(0.0, 1.0);
  void setMusicVolume(double volume) => _musicVolume = volume.clamp(0.0, 1.0);

  /// Plays a semantic sound effect respecting channel mute, cooldown, and voice priority.
  Future<bool> playSound(SemanticSound sound) async {
    if (!_sfxEnabled) return false;

    final spec = SoundDesignSystem.getSpec(sound);
    final now = DateTime.now();

    // 1. Cooldown Guard: Ignore if played too recently
    final lastTime = _lastPlaybackTimes[sound];
    if (lastTime != null && now.difference(lastTime) < spec.cooldown) {
      dev.log('🛑 [ChildAudio] Cooldown suppressed: ${sound.name}');
      return false;
    }

    // 2. Celebration Concurrency Guard: Only 1 active celebration sound at a time
    if (_isCelebrationSound(sound)) {
      if (_activeCelebrationSound != null && _celebrationStartTime != null) {
        final activeSpec = SoundDesignSystem.getSpec(_activeCelebrationSound!);
        if (now.difference(_celebrationStartTime!) < activeSpec.targetDuration) {
          dev.log('🛑 [ChildAudio] Suppressed overlapping celebration: ${sound.name}');
          return false;
        }
      }
      _activeCelebrationSound = sound;
      _celebrationStartTime = now;
    }

    // 3. Voice Priority Guard: If instructional/Pip voice is active, suppress decorative SFX
    if (_isVoiceActive && _isDecorativeSound(sound)) {
      dev.log('🛑 [ChildAudio] Decorative sound suppressed during voice: ${sound.name}');
      return false;
    }

    _lastPlaybackTimes[sound] = now;
    dev.log('🔊 [ChildAudio] Playing ${sound.name} (${spec.acousticCharacter}) vol:${(_sfxVolume * spec.defaultVolume).toStringAsFixed(2)}');

    // In production, playback uses asset slot via sound pool/audioplayers when installed.
    // Base audio service bridges backward compatibility.
    await _dispatchSoundEffect(sound);
    return true;
  }

  /// Plays instructional voice or dialogue with strict priority over decorative SFX.
  Future<void> playVoicePrompt(String text, {AudioPriority priority = AudioPriority.learningInstruction}) async {
    if (!_voiceEnabled) return;

    _isVoiceActive = true;
    try {
      await baseAudio.playSentence(text, priority: priority);
    } finally {
      // Small cooldown buffer after voice finishes to avoid immediate SFX collision
      Future.delayed(const Duration(milliseconds: 150), () {
        _isVoiceActive = false;
      });
    }
  }

  /// Plays Pip dialogue, ensuring Pip voice never overlaps or stacks.
  Future<void> playPipDialogue(String character, String text) async {
    if (!_voiceEnabled) return;

    // Stop any existing speech before starting new Pip dialogue
    await baseAudio.stop();
    _isVoiceActive = true;
    try {
      await baseAudio.playDialogue(character, text, priority: AudioPriority.characterDialogue);
    } finally {
      Future.delayed(const Duration(milliseconds: 150), () {
        _isVoiceActive = false;
      });
    }
  }

  /// Cancels all active sound effects and voice immediately.
  Future<void> stopAll() async {
    _activeCelebrationSound = null;
    _celebrationStartTime = null;
    _isVoiceActive = false;
    await baseAudio.stop();
  }

  bool _isCelebrationSound(SemanticSound sound) {
    return sound == SemanticSound.lessonComplete ||
        sound == SemanticSound.missionComplete ||
        sound == SemanticSound.worldUnlock ||
        sound == SemanticSound.treasureOpen;
  }

  bool _isDecorativeSound(SemanticSound sound) {
    return sound == SemanticSound.tap ||
        sound == SemanticSound.selection ||
        sound == SemanticSound.starEarned;
  }

  Future<void> _dispatchSoundEffect(SemanticSound sound) async {
    switch (sound) {
      case SemanticSound.tap:
      case SemanticSound.selection:
        await baseAudio.playSoundEffect(SoundEffect.click);
        break;
      case SemanticSound.correctSoft:
      case SemanticSound.correctIndependent:
      case SemanticSound.speakingSuccess:
      case SemanticSound.recoverySuccess:
        await baseAudio.playSoundEffect(SoundEffect.correct);
        break;
      case SemanticSound.gentleRetry:
        // Gentle neutral cue
        await baseAudio.playSoundEffect(SoundEffect.tryAgain);
        break;
      case SemanticSound.starEarned:
        await baseAudio.playSoundEffect(SoundEffect.starEarned);
        break;
      case SemanticSound.treasureOpen:
      case SemanticSound.lessonComplete:
      case SemanticSound.missionComplete:
      case SemanticSound.worldUnlock:
        await baseAudio.playSoundEffect(SoundEffect.levelComplete);
        break;
      case SemanticSound.hint:
      case SemanticSound.streak:
      case SemanticSound.pipAppear:
        await baseAudio.playSoundEffect(SoundEffect.click);
        break;
    }
  }
}

/// Global provider for ChildAudioManager.
final childAudioManagerProvider = Provider<ChildAudioManager>((ref) {
  final base = ref.watch(audioServiceProvider);
  return ChildAudioManager(baseAudio: base);
});
