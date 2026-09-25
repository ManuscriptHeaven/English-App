import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_card.dart';
import '../providers/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Settings ⚙️', style: AppTypography.headlineLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Sound & Audio', style: AppTypography.headlineLarge),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Sound Effects (SFX)', style: AppTypography.titleLarge),
                  subtitle: Text('Play cheerful sounds during activities', style: AppTypography.bodyMedium),
                  value: settings.soundEffectsEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(appSettingsProvider.notifier).toggleSoundEffects(val);
                    ref.read(audioServiceProvider).setSfxEnabled(val);
                  },
                ),
                const Divider(),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Background Music', style: AppTypography.titleLarge),
                  subtitle: Text('Play gentle background melodies', style: AppTypography.bodyMedium),
                  value: settings.backgroundMusicEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(appSettingsProvider.notifier).toggleBackgroundMusic(val);
                    ref.read(audioServiceProvider).setMusicEnabled(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Accessibility & Speech', style: AppTypography.headlineLarge),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('High Contrast Text', style: AppTypography.titleLarge),
                  subtitle: Text('Improve text contrast for early readers', style: AppTypography.bodyMedium),
                  value: settings.highContrastMode,
                  activeThumbColor: AppColors.primary,
                  onChanged: (val) {
                    ref.read(appSettingsProvider.notifier).toggleHighContrast(val);
                  },
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Speech Pronunciation Speed', style: AppTypography.titleLarge),
                  subtitle: Text(
                    settings.speechRate < 0.9 ? 'Gentle / Slow (Beginner)' : 'Normal Speed',
                    style: AppTypography.bodyMedium,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        onPressed: () => ref.read(appSettingsProvider.notifier).setSpeechRate(0.7),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline_rounded),
                        onPressed: () => ref.read(appSettingsProvider.notifier).setSpeechRate(1.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 24),
            Text('Developer & QA Tools (Internal)', style: AppTypography.headlineLarge),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.menu_book_rounded, color: AppColors.sunDark),
                    title: Text('Curriculum QA Browser', style: AppTypography.titleLarge),
                    subtitle: Text('Inspect all 5 tracks, 150 lessons & launch exact activity', style: AppTypography.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () => context.push(RouteNames.curriculumBrowser),
                  ),
                  const Divider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.mic_rounded, color: AppColors.primary),
                    title: Text('Voice & Audio Diagnostics', style: AppTypography.titleLarge),
                    subtitle: Text('Test microphone input, speech recognition & TTS audio', style: AppTypography.bodyMedium),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    onTap: () => context.push(RouteNames.voiceDiagnostics),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
