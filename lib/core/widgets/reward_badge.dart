import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

enum BadgeType { star, coin, xp, streak }

/// Reusable counter badge for gamified rewards (Stars, Coins, XP, Streak).
class RewardBadge extends StatelessWidget {
  final BadgeType type;
  final int count;
  final VoidCallback? onTap;

  const RewardBadge({
    super.key,
    required this.type,
    required this.count,
    this.onTap,
  });

  IconData get _icon {
    switch (type) {
      case BadgeType.star:
        return Icons.star_rounded;
      case BadgeType.coin:
        return Icons.monetization_on_rounded;
      case BadgeType.xp:
        return Icons.bolt_rounded;
      case BadgeType.streak:
        return Icons.local_fire_department_rounded;
    }
  }

  Color get _color {
    switch (type) {
      case BadgeType.star:
        return AppColors.starGold;
      case BadgeType.coin:
        return AppColors.coinOrange;
      case BadgeType.xp:
        return AppColors.xpPurple;
      case BadgeType.streak:
        return AppColors.streakFire;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.roundedPill,
          border: Border.all(color: _color.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: _color.withValues(alpha: 0.15),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, color: _color, size: 20),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: AppTypography.badgeText.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
