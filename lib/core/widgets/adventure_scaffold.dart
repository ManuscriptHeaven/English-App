import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';
import '../theme/world_themes.dart';

/// CustomPainter for world-specific illustrated backgrounds.
/// Creates layered sky + ground + environmental decoration without image assets.
class WorldScenePainter extends CustomPainter {
  final WorldTheme theme;
  final double groundHeightFraction; // 0.0–1.0, how much of screen is ground

  const WorldScenePainter({
    required this.theme,
    this.groundHeightFraction = 0.38,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height * (1.0 - groundHeightFraction);

    // Sky gradient
    final skyPaint = Paint()
      ..shader = theme.skyGradient.createShader(
          Rect.fromLTWH(0, 0, size.width, groundY));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, groundY), skyPaint);

    // Clouds
    _drawCloud(canvas, size.width * 0.15, groundY * 0.25, 40);
    _drawCloud(canvas, size.width * 0.65, groundY * 0.18, 30);
    _drawCloud(canvas, size.width * 0.85, groundY * 0.35, 24);

    // Ground — rolling hills
    final groundPath = Path();
    groundPath.moveTo(0, groundY + 20);
    groundPath.cubicTo(
      size.width * 0.25, groundY - 20,
      size.width * 0.5, groundY + 10,
      size.width * 0.75, groundY - 15,
    );
    groundPath.cubicTo(
      size.width * 0.9, groundY - 5,
      size.width, groundY + 5,
      size.width, groundY + 20,
    );
    groundPath.lineTo(size.width, size.height);
    groundPath.lineTo(0, size.height);
    groundPath.close();

    final groundPaint = Paint()
      ..shader = theme.groundGradient.createShader(
          Rect.fromLTWH(0, groundY - 20, size.width, size.height - groundY + 20));
    canvas.drawPath(groundPath, groundPaint);
  }

  void _drawCloud(Canvas canvas, double cx, double cy, double r) {
    final paint = Paint()..color = Colors.white.withAlpha(210);
    canvas.drawCircle(Offset(cx, cy), r, paint);
    canvas.drawCircle(Offset(cx + r * 0.75, cy + r * 0.1), r * 0.75, paint);
    canvas.drawCircle(Offset(cx - r * 0.65, cy + r * 0.15), r * 0.65, paint);
    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(cx, cy + r * 0.5),
            width: r * 2.8,
            height: r * 0.9),
        paint);
  }

  @override
  bool shouldRepaint(WorldScenePainter oldDelegate) =>
      oldDelegate.theme.worldId != theme.worldId ||
      oldDelegate.groundHeightFraction != groundHeightFraction;
}

/// Illustrated non-Material app bar for child-facing screens.
/// Has world-themed gradient, back button (if needed), title, and compact stats row.
class ChildAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final int stars;
  final int coins;
  final WorldTheme? worldTheme;
  final List<Widget>? actions;

  const ChildAppBar({
    super.key,
    required this.title,
    this.showBack = false,
    this.stars = 0,
    this.coins = 0,
    this.worldTheme,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final theme = worldTheme ?? WorldTheme.animalAdventure;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.skyColor, theme.skyColorBottom],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.accentColor.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              if (showBack)
                _IconBtn(
                  icon: Icons.arrow_back_ios_new_rounded,
                  color: AppColors.earthDark,
                  onTap: () => Navigator.of(context).maybePop(),
                )
              else
                const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.earthDark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Compact stats
              _StatPill(label: '$stars ⭐'),
              const SizedBox(width: 4),
              _StatPill(label: '$coins 🪙'),
              const SizedBox(width: 8),

              ...?actions,
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  const _StatPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(180),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: AppTypography.labelLarge.copyWith(
          color: AppColors.textPrimary,
          fontSize: 13,
        ),
      ),
    );
  }
}

/// Full-screen adventure scaffold with painted world background.
/// All child-facing activity screens should use this instead of [Scaffold].
class AdventureScaffold extends StatelessWidget {
  final WorldTheme worldTheme;
  final String title;
  final bool showBack;
  final int stars;
  final int coins;
  final Widget body;
  final List<Widget>? appBarActions;
  final Widget? floatingBottom;
  final double groundHeightFraction;

  const AdventureScaffold({
    super.key,
    required this.worldTheme,
    required this.title,
    required this.body,
    this.showBack = true,
    this.stars = 0,
    this.coins = 0,
    this.appBarActions,
    this.floatingBottom,
    this.groundHeightFraction = 0.0, // 0 = no scene background; >0 = painted scene
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: worldTheme.backgroundColor,
      appBar: ChildAppBar(
        title: title,
        showBack: showBack,
        stars: stars,
        coins: coins,
        worldTheme: worldTheme,
        actions: appBarActions,
      ),
      body: groundHeightFraction > 0
          ? Stack(
              children: [
                // Painted scene background
                Positioned.fill(
                  child: ExcludeSemantics(
                    excluding: true,
                    child: RepaintBoundary(
                      child: CustomPaint(
                        painter: WorldScenePainter(
                          theme: worldTheme,
                          groundHeightFraction: groundHeightFraction,
                        ),
                      ),
                    ),
                  ),
                ),
                body,
                if (floatingBottom != null)
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 24,
                    child: floatingBottom!,
                  ),
              ],
            )
          : floatingBottom != null
              ? Stack(
                  children: [
                    body,
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 24,
                      child: floatingBottom!,
                    ),
                  ],
                )
              : body,
    );
  }
}

/// Bottom navigation bar for child-facing screens.
/// Tabs: Home | Map | Rewards | Pip
class ChildBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ChildBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItem(emoji: '🏠', label: 'Home'),
      _NavItem(emoji: '🗺️', label: 'Map'),
      _NavItem(emoji: '🎁', label: 'Rewards'),
      _NavItem(emoji: '🦜', label: 'Pip'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: AppMotion.stateChange,
                    curve: AppMotion.standard,
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: selected ? 1.25 : 1.0,
                            duration: AppMotion.stateChange,
                            child: Text(
                              items[i].emoji,
                              style: TextStyle(fontSize: selected ? 26 : 22),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].label,
                            style: AppTypography.bodySmall.copyWith(
                              color: selected
                                  ? AppColors.meadowDark
                                  : AppColors.textMuted,
                              fontWeight: selected
                                  ? FontWeight.w800
                                  : FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String emoji;
  final String label;
  const _NavItem({required this.emoji, required this.label});
}
