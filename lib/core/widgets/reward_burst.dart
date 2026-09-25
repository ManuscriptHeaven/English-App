import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

/// Full-screen celebration overlay — bursts stars/coins when the child succeeds.
/// Use instead of `showDialog` completion dialogs for a more immersive feel.
///
/// Usage:
/// ```dart
/// RewardBurst.show(context, title: 'Amazing! 🌟', xp: 20, coins: 10, stars: 3);
/// ```
class RewardBurst extends StatefulWidget {
  final String title;
  final String subtitle;
  final int xp;
  final int coins;
  final int stars;
  final VoidCallback? onDismiss;

  const RewardBurst({
    super.key,
    required this.title,
    this.subtitle = '',
    this.xp = 0,
    this.coins = 0,
    this.stars = 0,
    this.onDismiss,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    String subtitle = '',
    int xp = 0,
    int coins = 0,
    int stars = 0,
    VoidCallback? onDismiss,
  }) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withAlpha(100),
      barrierDismissible: false,
      builder: (_) => RewardBurst(
        title: title,
        subtitle: subtitle,
        xp: xp,
        coins: coins,
        stars: stars,
        onDismiss: onDismiss ?? () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<RewardBurst> createState() => _RewardBurstState();
}

class _RewardBurstState extends State<RewardBurst>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: AppMotion.celebration);
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: AppMotion.spring);
    _fadeAnim = CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut));

    // Generate confetti particles
    _particles.addAll(_generateParticles());
    _ctrl.forward();
  }

  List<_Particle> _generateParticles() {
    const emojis = ['⭐', '🌟', '✨', '🎉', '🪙', '💛', '🌈', '🎊'];
    return List.generate(18, (i) {
      final angle = (i / 18) * 3.14159 * 2;
      final radius = 80.0 + (i % 4) * 40;
      return _Particle(
        emoji: emojis[i % emojis.length],
        dx: radius * (0.5 - (i % 3) * 0.5),
        dy: -radius * 0.8,
        delay: (i % 5) * 0.08,
        size: 16.0 + (i % 3) * 6,
        angle: angle,
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Confetti particles isolated from semantics and repaints
            if (!disableAnimations)
              ExcludeSemantics(
                excluding: true,
                child: RepaintBoundary(
                  child: Stack(
                    children: List.generate(_particles.length, (i) {
                      final p = _particles[i];
                      return AnimatedBuilder(
                        animation: _ctrl,
                        builder: (ctx2, child2) {
                          final t = (_ctrl.value - p.delay).clamp(0.0, 1.0);
                          return Positioned(
                            left: MediaQuery.of(context).size.width / 2 + p.dx * t,
                            top: MediaQuery.of(context).size.height / 2 + p.dy * t,
                            child: Opacity(
                              opacity: (1.0 - t * 0.7).clamp(0, 1),
                              child: Transform.rotate(
                                angle: p.angle * t,
                                child: Text(p.emoji,
                                    style: TextStyle(fontSize: p.size)),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ),

            // Central celebration card
            Semantics(
              liveRegion: true,
              label: '${widget.title}. ${widget.subtitle}. Rewards earned: ${widget.xp} XP, ${widget.coins} coins, ${widget.stars} stars.',
              child: ScaleTransition(
                scale: disableAnimations ? const AlwaysStoppedAnimation(1.0) : _scaleAnim,
                child: FadeTransition(
                  opacity: disableAnimations ? const AlwaysStoppedAnimation(1.0) : _fadeAnim,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sunYellow.withAlpha(80),
                        blurRadius: 32,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 72)),
                      const SizedBox(height: 12),
                      Text(
                        widget.title,
                        style: AppTypography.sceneTitle
                            .copyWith(color: AppColors.meadowDark),
                        textAlign: TextAlign.center,
                      ),
                      if (widget.subtitle.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          widget.subtitle,
                          style: AppTypography.bodyLarge
                              .copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Reward pills row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.xp > 0)
                            _RewardPill(
                                emoji: '🔥', label: '+${widget.xp} XP',
                                color: AppColors.lavender),
                          if (widget.coins > 0) ...[
                            const SizedBox(width: 8),
                            _RewardPill(
                                emoji: '🪙', label: '+${widget.coins}',
                                color: AppColors.sunLight),
                          ],
                          if (widget.stars > 0) ...[
                            const SizedBox(width: 8),
                            _RewardPill(
                                emoji: '⭐',
                                label: '+${widget.stars}',
                                color: AppColors.sunLight),
                          ],
                        ],
                      ),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: widget.onDismiss,
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.sunYellow,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.sunDark.withAlpha(120),
                                offset: const Offset(0, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text('Keep Going! 🚀',
                              style: AppTypography.buttonText.copyWith(
                                  color: AppColors.textPrimary)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _RewardPill extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;

  const _RewardPill(
      {required this.emoji, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(label,
              style: AppTypography.labelLarge
                  .copyWith(fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}

class _Particle {
  final String emoji;
  final double dx;
  final double dy;
  final double delay;
  final double size;
  final double angle;

  const _Particle({
    required this.emoji,
    required this.dx,
    required this.dy,
    required this.delay,
    required this.size,
    required this.angle,
  });
}
