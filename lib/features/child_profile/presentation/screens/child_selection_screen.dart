import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/parent_gate_dialog.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/child_profile_providers.dart';

/// Child Profile Selection Screen — Redesigned for joy and warmth.
class ChildSelectionScreen extends ConsumerWidget {
  const ChildSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profilesAsync = ref.watch(childProfilesProvider);
    final theme = WorldTheme.animalAdventure;

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: Stack(
        children: [
          // Background painter
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: theme,
                    groundHeightFraction: 0.22,
                  ),
                ),
              ),
            ),
          ),

          // Custom Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.skyColor, theme.skyColorBottom],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: SizedBox(
                  height: 60,
                  child: Row(
                    children: [
                      const Text('🌟', style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Who is Playing? 🧒👧',
                          style: AppTypography.headlineLarge.copyWith(color: AppColors.earthDark),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shield_rounded, color: AppColors.earthDark),
                        tooltip: 'Parent Zone',
                        onPressed: () async {
                          final gateService = ref.read(parentGateServiceProvider);
                          final verified = await ParentGateDialog.show(context, gateService);
                          if (verified == true && context.mounted) {
                            context.push(RouteNames.parent);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  const SizedBox(height: 68),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: PipCharacterGuide(
                      state: PipState.happy,
                      characterSize: 64,
                      speechBubbleText: 'Tap your profile to start exploring!',
                    ),
                  ),
                  const SizedBox(height: 8),

                  Expanded(
                    child: profilesAsync.when(
                      loading: () => const LoadingView(message: 'Loading explorers...'),
                      error: (err, _) => ErrorView(
                        message: err.toString(),
                        onRetry: () => ref.refresh(childProfilesProvider),
                      ),
                      data: (profiles) {
                        return GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: profiles.length + 1,
                          itemBuilder: (context, index) {
                            if (index == profiles.length) {
                              // Add profile tile
                              return GestureDetector(
                                onTap: () => context.push(RouteNames.createChild),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha(200),
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(color: AppColors.meadowGreen, width: 2.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.meadowGreen.withAlpha(30),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: AppColors.meadowLight,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.add_rounded, size: 36, color: AppColors.meadowDark),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        AppStrings.addProfile,
                                        style: AppTypography.titleLarge.copyWith(color: AppColors.meadowDark),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final child = profiles[index];
                            return GestureDetector(
                              onTap: () {
                                ref.read(activeChildProfileProvider.notifier).selectChild(child);
                                context.go(RouteNames.home);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: AppColors.sunYellow, width: 2.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.sunYellow.withAlpha(50),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 72,
                                      height: 72,
                                      decoration: BoxDecoration(
                                        color: AppColors.sunLight,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: AppColors.sunYellow, width: 2),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        child.gender == 'girl' ? '👧' : '🧒',
                                        style: const TextStyle(fontSize: 38),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      child.name,
                                      style: AppTypography.headlineMedium.copyWith(color: AppColors.earthDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.mintLight,
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: Text(
                                        'Age ${child.age} • ${child.ageGroup.title}',
                                        style: AppTypography.badgeText.copyWith(
                                          color: AppColors.mintDark,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '⭐ ${child.stars}   🪙 ${child.coins}',
                                      style: AppTypography.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.sunDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
