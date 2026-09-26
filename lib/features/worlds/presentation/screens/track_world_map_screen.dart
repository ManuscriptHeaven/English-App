import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../curriculum/domain/models/curriculum_track.dart';
import '../../domain/models/world.dart';
import '../providers/world_providers.dart';

/// Production Track World Map screen visibly exposing all worlds for the child's active curriculum track.
/// Allows children to see their entire progression path and select any accessible world.
class TrackWorldMapScreen extends ConsumerWidget {
  const TrackWorldMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final worldsAsync = ref.watch(worldsListProvider);
    final track = activeChild != null
        ? CurriculumTrack.forAge(activeChild.age)
        : CurriculumTrack.track1LittleListeners;

    final theme = WorldTheme.animalAdventure;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Stack(
        children: [
          // Background Painter
          Positioned.fill(
            child: ExcludeSemantics(
              excluding: true,
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: WorldScenePainter(
                    theme: theme,
                    groundHeightFraction: 0.15,
                  ),
                ),
              ),
            ),
          ),

          // Child AppBar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ChildAppBar(
              title: '${track.shortName} Map 🗺️',
              showBack: true,
              stars: activeChild?.stars ?? 0,
              coins: activeChild?.coins ?? 0,
              worldTheme: theme,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 64),

                // Pip Adventure Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(235),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.sunYellow, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sunYellow.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      PipCharacterGuide(
                        state: PipState.speaking,
                        characterSize: 52,
                        showSpeechBubble: false,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose Your World! 🌟',
                              style: AppTypography.headlineMedium.copyWith(color: AppColors.earthDark),
                            ),
                            Text(
                              'Explore each magical world on your learning journey!',
                              style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Worlds List
                Expanded(
                  child: worldsAsync.when(
                    loading: () => const LoadingView(message: 'Loading your worlds...'),
                    error: (err, _) => ErrorView(message: err.toString()),
                    data: (worlds) {
                      if (worlds.isEmpty) {
                        return const EmptyView(
                          title: 'No Worlds Found',
                          subtitle: 'Worlds for this track are being prepared.',
                        );
                      }

                      final completedIds = activeChild?.completedLessonIds ?? [];

                      return ListView.separated(
                        key: const Key('track_world_map_list'),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: worlds.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final world = worlds[index];
                          final worldTheme = WorldTheme.forWorldId(world.id);

                          // Calculate world-local progress
                          final worldLessons = world.chapters
                              .expand((c) => c.units)
                              .expand((u) => u.lessons)
                              .toList();
                          final completedInWorld = worldLessons
                              .where((l) => completedIds.contains(l.id))
                              .length;
                          final totalInWorld = worldLessons.length;
                          final isWorldCompleted = totalInWorld > 0 && completedInWorld == totalInWorld;

                          return _WorldCard(
                            world: world,
                            worldTheme: worldTheme,
                            worldIndex: index + 1,
                            completedCount: completedInWorld,
                            totalCount: totalInWorld,
                            isCompleted: isWorldCompleted,
                            onTap: () => context.push(RouteNames.worldDetailPath(world.id)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorldCard extends StatelessWidget {
  final World world;
  final WorldTheme worldTheme;
  final int worldIndex;
  final int completedCount;
  final int totalCount;
  final bool isCompleted;
  final VoidCallback onTap;

  const _WorldCard({
    required this.world,
    required this.worldTheme,
    required this.worldIndex,
    required this.completedCount,
    required this.totalCount,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isCompleted
                  ? const Color(0xFF4CAF50)
                  : worldTheme.accentColor.withAlpha(160),
              width: isCompleted ? 2.5 : 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (isCompleted ? const Color(0xFF4CAF50) : worldTheme.accentColor).withAlpha(30),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // World Index & Badge
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFFE8F5E9)
                      : worldTheme.accentColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isCompleted ? const Color(0xFF4CAF50) : worldTheme.accentColor,
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    isCompleted ? '⭐' : '$worldIndex',
                    style: TextStyle(
                      fontSize: isCompleted ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFF2E7D32) : worldTheme.accentColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Title & Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            world.title,
                            style: AppTypography.headlineMedium.copyWith(
                              fontSize: 18,
                              color: AppColors.earthDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFF4CAF50)),
                            ),
                            child: const Text(
                              'Complete 🎉',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      world.description,
                      style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // Progress Bar & Count
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: totalCount > 0 ? (completedCount / totalCount).clamp(0.0, 1.0) : 0.0,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isCompleted ? const Color(0xFF4CAF50) : worldTheme.accentColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '$completedCount/$totalCount ⭐',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? const Color(0xFF2E7D32) : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: isCompleted ? const Color(0xFF4CAF50) : worldTheme.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
