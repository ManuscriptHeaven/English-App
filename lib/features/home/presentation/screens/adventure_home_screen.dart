import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/world_themes.dart';
import '../../../../core/widgets/adventure_button.dart';
import '../../../../core/widgets/adventure_scaffold.dart';
import '../../../../core/widgets/child_bottom_nav_helper.dart';
import '../../../../core/widgets/parent_gate_dialog.dart';
import '../../../../core/widgets/pip_character_guide.dart';
import '../../../../core/widgets/state_views.dart';
import '../../../adventure_brain/domain/adaptive/learning_session.dart';
import '../../../adventure_brain/presentation/providers/adventure_brain_providers.dart';
import '../../../adventure_brain/presentation/widgets/session_progress_bar.dart';
import '../../../child_profile/presentation/providers/child_profile_providers.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../../worlds/presentation/providers/world_providers.dart';

/// Child Adventure Home — Premium redesign.
///
/// Layout:
///   Full-bleed illustrated scene (sky + hills + trees)
///   Pip at center stage — animated, speaking recommendation
///   ONE large primary CTA: START ADVENTURE
///   ChildBottomNav at bottom: Home / Map / Rewards / Pip
///
/// This screen must immediately communicate:
///   "THIS IS A CHILDREN'S ADVENTURE APP"
class AdventureHomeScreen extends ConsumerStatefulWidget {
  const AdventureHomeScreen({super.key});

  @override
  ConsumerState<AdventureHomeScreen> createState() =>
      _AdventureHomeScreenState();
}

class _AdventureHomeScreenState extends ConsumerState<AdventureHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctaCtrl;
  late Animation<double> _ctaBounce;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    // CTA gentle heartbeat bounce — draws eye to main action
    _ctaCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat(reverse: true);
    _ctaBounce = Tween<double>(begin: 1.0, end: 1.04)
        .animate(CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctaCtrl.dispose();
    super.dispose();
  }

  String _greeting(String name, int age) {
    if (age <= 4) return '👋 Hi $name!';
    if (age <= 6) return 'Hello $name! Ready to play?';
    if (age <= 8) return 'Welcome back, $name!';
    return 'Ready for your challenge, $name?';
  }

  @override
  Widget build(BuildContext context) {
    final activeChild = ref.watch(activeChildProfileProvider);
    final recommendationAsync = ref.watch(currentRecommendationProvider);
    final worldsAsync = ref.watch(worldsListProvider);
    final activeSession = ref.watch(activeLearningSessionProvider);

    if (activeChild == null) {
      return const Scaffold(body: LoadingView(message: 'Preparing adventure...'));
    }

    final theme = WorldTheme.animalAdventure;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      bottomNavigationBar: ChildBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => _handleNav(context, i, ref, worldsAsync.value),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 620;
          final disableAnimations = MediaQuery.of(context).disableAnimations;

          return Stack(
            children: [
              // ── Full-bleed painted scene ──
              Positioned.fill(
                child: ExcludeSemantics(
                  excluding: true,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: WorldScenePainter(
                        theme: theme,
                        groundHeightFraction: 0.30,
                      ),
                    ),
                  ),
                ),
              ),

              // ── Sky decorations ──
              if (!isCompact) ...[
                Positioned(top: 60, left: 20,
                    child: const ExcludeSemantics(child: Text('☁️', style: TextStyle(fontSize: 32)))),
                Positioned(top: 80, right: 30,
                    child: const ExcludeSemantics(child: Text('☁️', style: TextStyle(fontSize: 24)))),
                Positioned(top: 44, left: size.width * 0.45,
                    child: const ExcludeSemantics(child: Text('⭐', style: TextStyle(fontSize: 18)))),

                // ── Ground decorations ──
                Positioned(bottom: 82, left: 8,
                    child: const ExcludeSemantics(child: Text('🌳', style: TextStyle(fontSize: 48)))),
                Positioned(bottom: 80, right: 4,
                    child: const ExcludeSemantics(child: Text('🌲', style: TextStyle(fontSize: 40)))),
                Positioned(bottom: 76, left: size.width * 0.38,
                    child: const ExcludeSemantics(child: Text('🌸', style: TextStyle(fontSize: 28)))),
              ],

          // ── Safe-area content ──
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Top row: greeting + stars ──
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      // Avatar
                      GestureDetector(
                        onTap: () => context.push(RouteNames.childSelection),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: theme.accentColor.withAlpha(80),
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: theme.accentColor, width: 2.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            activeChild.gender == 'girl' ? '👧' : '🧒',
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _greeting(activeChild.name, activeChild.age),
                          style: AppTypography.headlineLarge.copyWith(
                            color: AppColors.earthDark,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Rewards pill
                      GestureDetector(
                        onTap: () => context.push(RouteNames.rewards),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(200),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: AppColors.sunYellow, width: 2),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⭐', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 3),
                              Text('${activeChild.stars}',
                                  style: AppTypography.labelLarge.copyWith(
                                      color: AppColors.sunDark,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(width: 6),
                              const Text('🔥', style: TextStyle(fontSize: 16)),
                              const SizedBox(width: 3),
                              Text('${activeChild.streakDays}d',
                                  style: AppTypography.labelLarge.copyWith(
                                      color: AppColors.coralDark,
                                      fontWeight: FontWeight.w800)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Pip character center stage ──
                const SizedBox(height: 12),
                Expanded(
                  child: Center(
                    child: recommendationAsync.when(
                      loading: () => PipCharacterGuide(
                        state: PipState.thinking,
                        speechBubbleText: 'Getting your adventure ready...',
                        characterSize: 116,
                      ),
                      error: (err, stack) => PipCharacterGuide(
                        state: PipState.happy,
                        speechBubbleText: "Let's explore together! 🌟",
                        characterSize: 116,
                        onTap: () => context.push(RouteNames.talkWithPip),
                      ),
                      data: (rec) => PipCharacterGuide(
                        state: PipState.excited,
                        speechBubbleText: rec.childFriendlyPrompt,
                        characterSize: 116,
                        onTap: () => context.push(RouteNames.talkWithPip),
                      ),
                    ),
                  ),
                ),

                // ── Session mission progress indicator (paws / stars) ──
                if (activeSession != null &&
                    (activeSession.status == SessionStatus.inProgress ||
                        activeSession.status == SessionStatus.paused)) ...[
                  SessionProgressBar(session: activeSession),
                  const SizedBox(height: 6),
                ],

                // ── Primary CTA: START ADVENTURE ──
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ScaleTransition(
                    scale: disableAnimations ? const AlwaysStoppedAnimation(1.0) : _ctaBounce,
                    child: recommendationAsync.when(
                      loading: () => AdventureButton(
                        text: 'START ADVENTURE 🚀',
                        backgroundColor: AppColors.sunYellow,
                        height: 72,
                        childAge: activeChild.age,
                        isLoading: true,
                      ),
                      error: (err, stack) => AdventureButton(
                        text: 'START ADVENTURE 🚀',
                        backgroundColor: AppColors.sunYellow,
                        height: 72,
                        childAge: activeChild.age,
                        onPressed: () => context
                            .push(RouteNames.worldDetailPath('world_animal')),
                      ),
                      data: (rec) => AdventureButton(
                        text: 'CONTINUE ADVENTURE 🚀',
                        backgroundColor: AppColors.sunYellow,
                        height: 72,
                        childAge: activeChild.age,
                        onPressed: () => context.push(rec.routePath),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80), // space for bottom nav
              ],
            ),
          ),

          // ── Parent zone link (small, top-right corner) ──
          Positioned(
            top: 8,
            right: 8,
            child: SafeArea(
              child: GestureDetector(
                onTap: () async {
                  final gateService = ref.read(parentGateServiceProvider);
                  final ok = await ParentGateDialog.show(context, gateService);
                  if (ok == true && context.mounted) {
                    context.push(RouteNames.parent);
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(180),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shield_rounded,
                          size: 14, color: AppColors.textMuted),
                      SizedBox(width: 4),
                      Text('Parents',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  ),
);
  }

  void _handleNav(BuildContext context, int index, WidgetRef ref,
      List<dynamic>? worlds) {
    setState(() => _navIndex = index);
    switch (index) {
      case 0: // Home — already here
        break;
      case 1: // Map
        final worldId =
            worlds != null && worlds.isNotEmpty ? worlds.first.id : 'world_animal';
        context.push(RouteNames.worldDetailPath(worldId));
        break;
      case 2: // Rewards
        context.push(RouteNames.rewards);
        break;
      case 3: // Pip
        context.push(RouteNames.talkWithPip);
        break;
    }
    // Reset after navigation so tab isn't "stuck"
    Future.delayed(const Duration(milliseconds: 200),
        () => setState(() => _navIndex = 0));
  }
}
