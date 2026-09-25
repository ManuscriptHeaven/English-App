import 'package:equatable/equatable.dart';

/// User and app-wide preference configuration.
class AppSettings extends Equatable {
  final bool soundEffectsEnabled;
  final bool backgroundMusicEnabled;
  final double soundVolume;
  final double speechRate; // 0.8 for slow clear speech, 1.0 normal
  final bool highContrastMode;
  final bool largeTouchTargets;
  final int dailyScreenTimeLimitMinutes;
  final bool autoPlayPronunciation;
  final bool reducedMotionEnabled;

  const AppSettings({
    this.soundEffectsEnabled = true,
    this.backgroundMusicEnabled = true,
    this.soundVolume = 1.0,
    this.speechRate = 0.9,
    this.highContrastMode = false,
    this.largeTouchTargets = true,
    this.dailyScreenTimeLimitMinutes = 30,
    this.autoPlayPronunciation = true,
    this.reducedMotionEnabled = false,
  });

  AppSettings copyWith({
    bool? soundEffectsEnabled,
    bool? backgroundMusicEnabled,
    double? soundVolume,
    double? speechRate,
    bool? highContrastMode,
    bool? largeTouchTargets,
    int? dailyScreenTimeLimitMinutes,
    bool? autoPlayPronunciation,
    bool? reducedMotionEnabled,
  }) {
    return AppSettings(
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      backgroundMusicEnabled: backgroundMusicEnabled ?? this.backgroundMusicEnabled,
      soundVolume: soundVolume ?? this.soundVolume,
      speechRate: speechRate ?? this.speechRate,
      highContrastMode: highContrastMode ?? this.highContrastMode,
      largeTouchTargets: largeTouchTargets ?? this.largeTouchTargets,
      dailyScreenTimeLimitMinutes:
          dailyScreenTimeLimitMinutes ?? this.dailyScreenTimeLimitMinutes,
      autoPlayPronunciation:
          autoPlayPronunciation ?? this.autoPlayPronunciation,
      reducedMotionEnabled:
          reducedMotionEnabled ?? this.reducedMotionEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'soundEffectsEnabled': soundEffectsEnabled,
        'backgroundMusicEnabled': backgroundMusicEnabled,
        'soundVolume': soundVolume,
        'speechRate': speechRate,
        'highContrastMode': highContrastMode,
        'largeTouchTargets': largeTouchTargets,
        'dailyScreenTimeLimitMinutes': dailyScreenTimeLimitMinutes,
        'autoPlayPronunciation': autoPlayPronunciation,
        'reducedMotionEnabled': reducedMotionEnabled,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        soundEffectsEnabled: json['soundEffectsEnabled'] as bool? ?? true,
        backgroundMusicEnabled: json['backgroundMusicEnabled'] as bool? ?? true,
        soundVolume: (json['soundVolume'] as num?)?.toDouble() ?? 1.0,
        speechRate: (json['speechRate'] as num?)?.toDouble() ?? 0.9,
        highContrastMode: json['highContrastMode'] as bool? ?? false,
        largeTouchTargets: json['largeTouchTargets'] as bool? ?? true,
        dailyScreenTimeLimitMinutes: json['dailyScreenTimeLimitMinutes'] as int? ?? 30,
        autoPlayPronunciation: json['autoPlayPronunciation'] as bool? ?? true,
        reducedMotionEnabled: json['reducedMotionEnabled'] as bool? ?? false,
      );

  @override
  List<Object?> get props => [
        soundEffectsEnabled,
        backgroundMusicEnabled,
        soundVolume,
        speechRate,
        highContrastMode,
        largeTouchTargets,
        dailyScreenTimeLimitMinutes,
        autoPlayPronunciation,
        reducedMotionEnabled,
      ];
}
