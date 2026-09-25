import 'package:flutter/material.dart';

/// Motion design language for Kids English Adventure.
/// Principle: animate with purpose — celebrate success, guide attention, signal state.
/// Never animate constantly; never use harsh/jarring transitions.
class AppMotion {
  // ══════════════════════════════════════════════
  // FORMAL MOTION CLASSES (Section 19)
  // ══════════════════════════════════════════════

  /// Instant response (80–120ms): tap response
  static const Duration durationInstant = Duration(milliseconds: 100);

  /// Fast interaction (150–220ms): button state, selection, small correct feedback
  static const Duration durationFast = Duration(milliseconds: 180);

  /// Normal transition (250–400ms): card movement, Pip transition, activity success
  static const Duration durationNormal = Duration(milliseconds: 300);

  /// Celebration milestone (600–1200ms): lesson/mission milestones
  static const Duration durationCelebration = Duration(milliseconds: 800);

  // Micro-feedback: button press scale, icon swap
  static const Duration tapResponse = Duration(milliseconds: 100);

  /// Standard UI state change: color shift, opacity
  static const Duration stateChange = Duration(milliseconds: 180);

  /// Navigation, modal appear
  static const Duration slideIn = Duration(milliseconds: 300);

  /// Page transition between screens
  static const Duration pageTransition = Duration(milliseconds: 350);

  /// Character reaction to child's answer
  static const Duration characterReaction = Duration(milliseconds: 400);

  /// Celebration: stars burst, reward reveal
  static const Duration celebration = Duration(milliseconds: 700);

  /// Node appearing on trail map
  static const Duration nodeAppear = Duration(milliseconds: 250);

  /// Pip idle bob cycle (continuous loop)
  static const Duration pipIdleBob = Duration(milliseconds: 1800);

  /// Reward confetti duration (Tier 4 major achievements only)
  static const Duration confetti = Duration(milliseconds: 1200);

  /// Resolves effective animation duration respecting reduced motion preference.
  static Duration resolveDuration(BuildContext context, Duration normalDuration) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    return disableAnimations ? Duration.zero : normalDuration;
  }

  // ══════════════════════════════════════════════
  // CURVES
  // ══════════════════════════════════════════════

  /// Default for most transitions — smooth, professional
  static const Curve standard = Curves.easeInOut;

  /// Entering elements — quick start, gentle settle
  static const Curve enter = Curves.easeOut;

  /// Leaving elements
  static const Curve exit = Curves.easeIn;

  /// Celebration pop — springy and fun
  static const Curve spring = Curves.elasticOut;

  /// Gentle bounce for character
  static const Curve bounce = Curves.bounceOut;

  /// Smooth character bob
  static const Curve bob = Curves.easeInOut;

  // ══════════════════════════════════════════════
  // SCALE VALUES
  // ══════════════════════════════════════════════

  /// Button press scale — gives tactile feel
  static const double buttonPressScale = 0.94;

  /// Correct answer celebration scale
  static const double correctScale = 1.18;

  /// Pip celebrating scale
  static const double pipCelebrateScale = 1.22;

  /// Node hover scale on trail map
  static const double nodeHoverScale = 1.12;

  // ══════════════════════════════════════════════
  // OFFSETS — for slide animations
  // ══════════════════════════════════════════════

  /// Pip idle bob vertical offset (px)
  static const double pipBobOffset = 6.0;

  /// Character reaction vertical bounce
  static const double characterBounce = 12.0;
}
