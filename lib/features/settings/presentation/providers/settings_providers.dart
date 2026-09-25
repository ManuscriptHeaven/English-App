import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/services/parent_gate_service.dart';
import '../../domain/models/app_settings.dart';

export '../../../../core/services/audio_service.dart' show audioServiceProvider;

final analyticsServiceProvider = Provider<IAnalyticsService>((ref) {
  return MockAnalyticsService();
});

final parentGateServiceProvider = Provider<ParentGateService>((ref) {
  return ParentGateService();
});

class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier() : super(const AppSettings());

  void toggleSoundEffects(bool enabled) {
    state = state.copyWith(soundEffectsEnabled: enabled);
  }

  void toggleBackgroundMusic(bool enabled) {
    state = state.copyWith(backgroundMusicEnabled: enabled);
  }

  void setVolume(double volume) {
    state = state.copyWith(soundVolume: volume);
  }

  void setSpeechRate(double rate) {
    state = state.copyWith(speechRate: rate);
  }

  void setDailyScreenTimeLimit(int minutes) {
    state = state.copyWith(dailyScreenTimeLimitMinutes: minutes);
  }

  void toggleHighContrast(bool enabled) {
    state = state.copyWith(highContrastMode: enabled);
  }
}

final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  return AppSettingsNotifier();
});
