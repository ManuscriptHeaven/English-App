import 'package:equatable/equatable.dart';

/// Semantic production sound identifiers for Kids English Adventure.
enum SemanticSound {
  tap,
  selection,
  correctSoft,
  correctIndependent,
  speakingSuccess,
  recoverySuccess,
  gentleRetry,
  hint,
  streak,
  starEarned,
  treasureOpen,
  lessonComplete,
  missionComplete,
  worldUnlock,
  pipAppear,
}

/// Asset lifecycle status adhering to the Phase 16 Sound Asset Reality Rule.
enum SoundAssetStatus {
  /// Production architecture, channels, and asset slots are fully defined,
  /// with final studio recordings / human acoustic approval pending.
  audioAssetProductionPending,

  /// Final studio recording installed and approved.
  productionReady,
}

/// Acoustic and emotional design specification for a single semantic sound.
class SoundDesignSpec extends Equatable {
  final SemanticSound sound;
  final String assetPath;
  final String acousticCharacter;
  final String intendedEmotion;
  final Duration targetDuration;
  final Duration cooldown;
  final double defaultVolume;
  final SoundAssetStatus status;

  const SoundDesignSpec({
    required this.sound,
    required this.assetPath,
    required this.acousticCharacter,
    required this.intendedEmotion,
    required this.targetDuration,
    required this.cooldown,
    this.defaultVolume = 1.0,
    this.status = SoundAssetStatus.audioAssetProductionPending,
  });

  @override
  List<Object?> get props => [
        sound,
        assetPath,
        acousticCharacter,
        intendedEmotion,
        targetDuration,
        cooldown,
        defaultVolume,
        status,
      ];
}

/// Production Sound Design System defining all semantic sound slots,
/// their acoustic profiles, non-punitive retry cues, and cooldown guards.
class SoundDesignSystem {
  /// Complete production sound specifications.
  static const Map<SemanticSound, SoundDesignSpec> specifications = {
    SemanticSound.tap: SoundDesignSpec(
      sound: SemanticSound.tap,
      assetPath: 'assets/audio/sfx/tap_pop.mp3',
      acousticCharacter: 'Subtle wooden pop (80ms)',
      intendedEmotion: 'Light, responsive touch affirmation',
      targetDuration: Duration(milliseconds: 100),
      cooldown: Duration(milliseconds: 60),
      defaultVolume: 0.6,
    ),
    SemanticSound.selection: SoundDesignSpec(
      sound: SemanticSound.selection,
      assetPath: 'assets/audio/sfx/card_select.mp3',
      acousticCharacter: 'Gentle marimba tone (120ms)',
      intendedEmotion: 'Playful focus and card choice confirmation',
      targetDuration: Duration(milliseconds: 140),
      cooldown: Duration(milliseconds: 100),
      defaultVolume: 0.7,
    ),
    SemanticSound.correctSoft: SoundDesignSpec(
      sound: SemanticSound.correctSoft,
      assetPath: 'assets/audio/sfx/correct_soft_bell.mp3',
      acousticCharacter: 'Warm xylophone major third (180ms)',
      intendedEmotion: 'Gentle affirmation without overwhelming distraction',
      targetDuration: Duration(milliseconds: 220),
      cooldown: Duration(milliseconds: 150),
      defaultVolume: 0.8,
    ),
    SemanticSound.correctIndependent: SoundDesignSpec(
      sound: SemanticSound.correctIndependent,
      assetPath: 'assets/audio/sfx/correct_independent_chime.mp3',
      acousticCharacter: 'Resonant wooden chime with bright harmonic (350ms)',
      intendedEmotion: 'Pride in independent recall and clear pronunciation',
      targetDuration: Duration(milliseconds: 380),
      cooldown: Duration(milliseconds: 250),
      defaultVolume: 0.85,
    ),
    SemanticSound.speakingSuccess: SoundDesignSpec(
      sound: SemanticSound.speakingSuccess,
      assetPath: 'assets/audio/sfx/speaking_success_flute.mp3',
      acousticCharacter: 'Upward melodic bird chirp / gentle flute note (400ms)',
      intendedEmotion: 'Delight in vocalizing English aloud',
      targetDuration: Duration(milliseconds: 450),
      cooldown: Duration(milliseconds: 300),
      defaultVolume: 0.9,
    ),
    SemanticSound.recoverySuccess: SoundDesignSpec(
      sound: SemanticSound.recoverySuccess,
      assetPath: 'assets/audio/sfx/recovery_warmth.mp3',
      acousticCharacter: 'Warm acoustic guitar strum ascending (320ms)',
      intendedEmotion: 'Relief and encouragement for persistent effort',
      targetDuration: Duration(milliseconds: 350),
      cooldown: Duration(milliseconds: 250),
      defaultVolume: 0.85,
    ),
    SemanticSound.gentleRetry: SoundDesignSpec(
      sound: SemanticSound.gentleRetry,
      assetPath: 'assets/audio/sfx/gentle_retry_neutral.mp3',
      acousticCharacter: 'Soft low marimba drop (neutral, non-punitive, 150ms)',
      intendedEmotion: 'Calm invitation to listen again; strictly zero failure shame',
      targetDuration: Duration(milliseconds: 180),
      cooldown: Duration(milliseconds: 200),
      defaultVolume: 0.5,
    ),
    SemanticSound.hint: SoundDesignSpec(
      sound: SemanticSound.hint,
      assetPath: 'assets/audio/sfx/hint_shimmer.mp3',
      acousticCharacter: 'Delicate wind-chime shimmer (250ms)',
      intendedEmotion: 'Friendly assistance and insight',
      targetDuration: Duration(milliseconds: 280),
      cooldown: Duration(milliseconds: 300),
      defaultVolume: 0.65,
    ),
    SemanticSound.streak: SoundDesignSpec(
      sound: SemanticSound.streak,
      assetPath: 'assets/audio/sfx/streak_momentum.mp3',
      acousticCharacter: 'Short energetic bell triad (300ms)',
      intendedEmotion: 'Playful rhythm and momentum without addictive hype',
      targetDuration: Duration(milliseconds: 320),
      cooldown: Duration(milliseconds: 400),
      defaultVolume: 0.8,
    ),
    SemanticSound.starEarned: SoundDesignSpec(
      sound: SemanticSound.starEarned,
      assetPath: 'assets/audio/sfx/star_twinkle.mp3',
      acousticCharacter: 'Bright melodic music box chime (400ms)',
      intendedEmotion: 'Earned progress satisfaction',
      targetDuration: Duration(milliseconds: 450),
      cooldown: Duration(milliseconds: 200),
      defaultVolume: 0.85,
    ),
    SemanticSound.treasureOpen: SoundDesignSpec(
      sound: SemanticSound.treasureOpen,
      assetPath: 'assets/audio/sfx/chest_open_wonder.mp3',
      acousticCharacter: 'Acoustic harp glissando into gentle bass drum warm thud (700ms)',
      intendedEmotion: 'Delightful discovery and wonder',
      targetDuration: Duration(milliseconds: 800),
      cooldown: Duration(milliseconds: 1000),
      defaultVolume: 0.9,
    ),
    SemanticSound.lessonComplete: SoundDesignSpec(
      sound: SemanticSound.lessonComplete,
      assetPath: 'assets/audio/sfx/lesson_complete_fanfare.mp3',
      acousticCharacter: 'Warm 4-bar acoustic celebration melody (900ms)',
      intendedEmotion: 'Accomplishment and readiness to explore further',
      targetDuration: Duration(milliseconds: 1000),
      cooldown: Duration(milliseconds: 2000),
      defaultVolume: 0.9,
    ),
    SemanticSound.missionComplete: SoundDesignSpec(
      sound: SemanticSound.missionComplete,
      assetPath: 'assets/audio/sfx/mission_complete_anthem.mp3',
      acousticCharacter: 'Joyful orchestral brass & glockenspiel resolution (1100ms)',
      intendedEmotion: 'Proud milestone achievement',
      targetDuration: Duration(milliseconds: 1200),
      cooldown: Duration(milliseconds: 3000),
      defaultVolume: 0.95,
    ),
    SemanticSound.worldUnlock: SoundDesignSpec(
      sound: SemanticSound.worldUnlock,
      assetPath: 'assets/audio/sfx/world_unlock_wonder.mp3',
      acousticCharacter: 'Expansive wind chime swell with warm French horn resolve (1200ms)',
      intendedEmotion: 'Adventure expanding into exciting new horizons',
      targetDuration: Duration(milliseconds: 1300),
      cooldown: Duration(milliseconds: 4000),
      defaultVolume: 0.95,
    ),
    SemanticSound.pipAppear: SoundDesignSpec(
      sound: SemanticSound.pipAppear,
      assetPath: 'assets/audio/sfx/pip_chirp_flutter.mp3',
      acousticCharacter: 'Friendly wing flutter with double cheerful chirp (250ms)',
      intendedEmotion: 'Warm greeting from child\'s faithful companion',
      targetDuration: Duration(milliseconds: 300),
      cooldown: Duration(milliseconds: 500),
      defaultVolume: 0.75,
    ),
  };

  /// Returns the design specification for [sound].
  static SoundDesignSpec getSpec(SemanticSound sound) => specifications[sound]!;
}
