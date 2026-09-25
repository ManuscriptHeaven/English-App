import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/adventure_button.dart';
import '../../../../core/widgets/pip_character_guide.dart';

/// Premium welcome screen — illustrated morning adventure scene.
/// First impression must immediately feel: "THIS IS FOR CHILDREN."
///
/// Layout:
///   Top: Custom painted sky with clouds + rolling hills
///   Center: Pip flying in with entrance animation
///   Bottom: App name + single large START ADVENTURE button
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  // Pip flies in from right
  late AnimationController _entranceCtrl;
  late Animation<double> _pipSlide;
  late Animation<double> _pipFade;

  // Title fades up
  late AnimationController _titleCtrl;
  late Animation<double> _titleSlide;
  late Animation<double> _titleFade;

  // Button fades up after title
  late AnimationController _btnCtrl;
  late Animation<double> _btnFade;

  Timer? _entranceTimer;
  Timer? _titleTimer;
  Timer? _btnTimer;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _pipSlide = Tween<double>(begin: 100, end: 0)
        .animate(CurvedAnimation(parent: _entranceCtrl, curve: AppMotion.enter));
    _pipFade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);

    _titleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _titleSlide = Tween<double>(begin: 20, end: 0)
        .animate(CurvedAnimation(parent: _titleCtrl, curve: AppMotion.enter));
    _titleFade = CurvedAnimation(parent: _titleCtrl, curve: Curves.easeOut);

    _btnCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _btnFade = CurvedAnimation(parent: _btnCtrl, curve: Curves.easeOut);

    // Staggered entrance
    _entranceTimer = Timer(const Duration(milliseconds: 200), () {
      if (mounted) _entranceCtrl.forward();
    });
    _titleTimer = Timer(const Duration(milliseconds: 700), () {
      if (mounted) _titleCtrl.forward();
    });
    _btnTimer = Timer(const Duration(milliseconds: 1100), () {
      if (mounted) _btnCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceTimer?.cancel();
    _titleTimer?.cancel();
    _btnTimer?.cancel();
    _entranceCtrl.dispose();
    _titleCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _entranceTimer?.cancel();
      _titleTimer?.cancel();
      _btnTimer?.cancel();
      _entranceCtrl.value = 1.0;
      _titleCtrl.value = 1.0;
      _btnCtrl.value = 1.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Scaffold(
      backgroundColor: AppColors.skyMorning,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxHeight < 600;

          return Stack(
            children: [
              // ── Painted world scene (full bleed) ──
              Positioned.fill(
                child: ExcludeSemantics(
                  excluding: true,
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _WelcomePainter(),
                    ),
                  ),
                ),
              ),

              // ── Decorative floating emoji in sky ──
              if (!isCompact) ...[
                Positioned(top: size.height * 0.06, left: size.width * 0.08,
                    child: const ExcludeSemantics(child: Text('☁️', style: TextStyle(fontSize: 36)))),
                Positioned(top: size.height * 0.10, right: size.width * 0.12,
                    child: const ExcludeSemantics(child: Text('☁️', style: TextStyle(fontSize: 28)))),
                Positioned(top: size.height * 0.04, left: size.width * 0.52,
                    child: const ExcludeSemantics(child: Text('🌟', style: TextStyle(fontSize: 22)))),
                Positioned(top: size.height * 0.14, left: size.width * 0.30,
                    child: const ExcludeSemantics(child: Text('✨', style: TextStyle(fontSize: 18)))),

                // ── Ground environment emoji ──
                Positioned(bottom: size.height * 0.26, left: size.width * 0.04,
                    child: const ExcludeSemantics(child: Text('🌳', style: TextStyle(fontSize: 52)))),
                Positioned(bottom: size.height * 0.24, right: size.width * 0.05,
                    child: const ExcludeSemantics(child: Text('🌲', style: TextStyle(fontSize: 44)))),
                Positioned(bottom: size.height * 0.22, left: size.width * 0.42,
                    child: const ExcludeSemantics(child: Text('🌻', style: TextStyle(fontSize: 32)))),
                Positioned(bottom: size.height * 0.20, left: size.width * 0.65,
                    child: const ExcludeSemantics(child: Text('🌿', style: TextStyle(fontSize: 28)))),
              ],

              // ── Foreground Interactive Elements ──
              if (isCompact)
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 12),
                        PipCharacterGuide(
                          state: PipState.excited,
                          characterSize: 90,
                          speechBubbleText: "Let's learn English! 🌟",
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Kids English Adventure',
                          style: AppTypography.sceneTitle.copyWith(
                            color: AppColors.earthDark,
                            fontSize: 28,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.mintLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '🌿 Fun English  •  Islamic Values  •  Adventure',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.mintDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        AdventureButton(
                          text: 'Start Adventure! 🚀',
                          backgroundColor: AppColors.sunYellow,
                          height: 62,
                          onPressed: () => context.go(RouteNames.childSelection),
                        ),
                      ],
                    ),
                  ),
                )
              else ...[
                // ── Pip entrance (slides from right) ──
                Positioned(
                  top: (size.height * 0.18).clamp(90.0, 220.0),
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _entranceCtrl,
                    builder: (_, child) {
                      if (disableAnimations) return child!;
                      return Transform.translate(
                        offset: Offset(_pipSlide.value, 0),
                        child: Opacity(opacity: _pipFade.value, child: child),
                      );
                    },
                    child: Center(
                      child: PipCharacterGuide(
                        state: PipState.excited,
                        characterSize: 120,
                        speechBubbleText: "Let's learn English! 🌟",
                      ),
                    ),
                  ),
                ),

                // ── Title & tagline ──
                Positioned(
                  bottom: (size.height * 0.22).clamp(110.0, 200.0),
                  left: 24,
                  right: 24,
                  child: AnimatedBuilder(
                    animation: _titleCtrl,
                    builder: (_, child) {
                      if (disableAnimations) return child!;
                      return Transform.translate(
                        offset: Offset(0, _titleSlide.value),
                        child: Opacity(opacity: _titleFade.value, child: child),
                      );
                    },
                    child: Column(
                      children: [
                        Text(
                          'Kids English\nAdventure',
                          style: AppTypography.sceneTitle.copyWith(
                            color: AppColors.earthDark,
                            height: 1.1,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.mintLight,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '🌿 Fun English  •  Islamic Values  •  Adventure',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.mintDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── START ADVENTURE button ──
                Positioned(
                  bottom: 36,
                  left: 28,
                  right: 28,
                  child: AnimatedBuilder(
                    animation: _btnCtrl,
                    builder: (_, child) {
                      if (disableAnimations) return child!;
                      return Opacity(opacity: _btnFade.value, child: child);
                    },
                    child: AdventureButton(
                      text: 'Start Adventure! 🚀',
                      backgroundColor: AppColors.sunYellow,
                      height: 68,
                      onPressed: () => context.go(RouteNames.childSelection),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Custom painter for the welcome screen's morning world scene.
class _WelcomePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final groundY = size.height * 0.72;

    // Sky gradient — morning warmth
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFB8E4FF), Color(0xFFD6EEFF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, groundY));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, groundY), skyPaint);

    // Sun
    final sunPaint = Paint()..color = const Color(0xFFFFD166).withAlpha(200);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.12), 42, sunPaint);
    final sunGlowPaint = Paint()..color = const Color(0xFFFFD166).withAlpha(60);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.12), 60, sunGlowPaint);

    // Rolling hills — far
    final farHillPaint = Paint()..color = const Color(0xFF9CCC65);
    final farHillPath = Path();
    farHillPath.moveTo(0, groundY);
    farHillPath.cubicTo(size.width * 0.2, groundY - 45, size.width * 0.4, groundY - 30,
        size.width * 0.6, groundY - 55);
    farHillPath.cubicTo(size.width * 0.75, groundY - 65, size.width * 0.9, groundY - 35,
        size.width, groundY - 20);
    farHillPath.lineTo(size.width, groundY);
    farHillPath.lineTo(0, groundY);
    farHillPath.close();
    canvas.drawPath(farHillPath, farHillPaint);

    // Ground
    final groundPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF8BC34A), Color(0xFF558B2F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, groundY, size.width, size.height - groundY));

    final groundPath = Path();
    groundPath.moveTo(0, groundY + 10);
    groundPath.cubicTo(size.width * 0.25, groundY - 12, size.width * 0.55, groundY + 8,
        size.width * 0.78, groundY - 8);
    groundPath.cubicTo(size.width * 0.9, groundY - 4, size.width, groundY + 6,
        size.width, groundY + 10);
    groundPath.lineTo(size.width, size.height);
    groundPath.lineTo(0, size.height);
    groundPath.close();
    canvas.drawPath(groundPath, groundPaint);
  }

  @override
  bool shouldRepaint(_WelcomePainter oldDelegate) => false;
}
