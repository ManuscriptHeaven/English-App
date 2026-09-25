import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/models/ai_parent_settings.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_tutor_service.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/ai_usage_manager.dart';
import 'package:kids_english_adventure/features/ai_tutor/domain/services/mock_ai_provider.dart';

final aiUsageManagerProvider = Provider<AiUsageManager>((ref) {
  return AiUsageManager();
});

final aiTutorServiceProvider = Provider<AiTutorService>((ref) {
  final usageManager = ref.watch(aiUsageManagerProvider);
  return AiTutorService(
    provider: const MockAiProvider(simulateLatency: true),
    usageManager: usageManager,
  );
});

class AiParentSettingsNotifier extends StateNotifier<AiParentSettings> {
  AiParentSettingsNotifier() : super(const AiParentSettings());

  void updateSettings({
    bool? aiTutorEnabled,
    bool? voiceConversationEnabled,
    bool? speakingPracticeEnabled,
    bool? storyVariationsEnabled,
    bool? aiFallbackEnabled,
    int? dailyMinutesLimit,
    int? dailyTurnsLimit,
    bool? costSaverMode,
  }) {
    state = state.copyWith(
      aiTutorEnabled: aiTutorEnabled,
      voiceConversationEnabled: voiceConversationEnabled,
      speakingPracticeEnabled: speakingPracticeEnabled,
      storyVariationsEnabled: storyVariationsEnabled,
      aiFallbackEnabled: aiFallbackEnabled,
      dailyMinutesLimit: dailyMinutesLimit,
      dailyTurnsLimit: dailyTurnsLimit,
      costSaverMode: costSaverMode,
    );
  }
}

final aiParentSettingsProvider = StateNotifierProvider<AiParentSettingsNotifier, AiParentSettings>((ref) {
  return AiParentSettingsNotifier();
});
