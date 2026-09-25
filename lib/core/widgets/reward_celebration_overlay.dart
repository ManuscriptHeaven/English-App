import 'package:flutter/material.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';

/// Quick, non-blocking celebration overlay for child achievements.
class RewardCelebrationOverlay extends StatefulWidget {
  final int stars;
  final int xp;
  final int coins;
  final String title;
  final VoidCallback onDismissed;

  const RewardCelebrationOverlay({
    super.key,
    this.stars = 3,
    this.xp = 30,
    this.coins = 15,
    this.title = 'Great Job! 🎉',
    required this.onDismissed,
  });

  @override
  State<RewardCelebrationOverlay> createState() => _RewardCelebrationOverlayState();
}

class _RewardCelebrationOverlayState extends State<RewardCelebrationOverlay> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _scaleAnim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.elasticOut),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _animController.forward();

    // Auto-dismiss after 2 seconds
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        _animController.reverse().then((_) {
          widget.onDismissed();
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Center(
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppRadius.roundedXl,
              border: Border.all(color: AppColors.secondary, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🌟🎉🦜', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                Text(
                  widget.title,
                  style: AppTypography.displayMedium.copyWith(color: AppColors.secondaryDark),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.stars > 0) ...[
                      Text('⭐ +${widget.stars} Stars',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.secondaryDark)),
                      const SizedBox(width: 12),
                    ],
                    if (widget.xp > 0) ...[
                      Text('🔥 +${widget.xp} XP',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryDark)),
                      const SizedBox(width: 12),
                    ],
                    if (widget.coins > 0)
                      Text('🪙 +${widget.coins} Coins',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.amber)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
