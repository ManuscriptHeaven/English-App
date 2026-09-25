import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'reward_badge.dart';

/// Top application bar for child screens displaying active child avatar and reward balances.
class ChildHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int stars;
  final int coins;
  final int xp;
  final int streak;
  final VoidCallback? onAvatarTap;
  final VoidCallback? onBack;
  final bool showBack;

  const ChildHeaderBar({
    super.key,
    required this.title,
    this.stars = 0,
    this.coins = 0,
    this.xp = 0,
    this.streak = 0,
    this.onAvatarTap,
    this.onBack,
    this.showBack = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (showBack)
              IconButton(
                onPressed: onBack ?? () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 28, color: AppColors.textPrimary),
              )
            else if (onAvatarTap != null)
              GestureDetector(
                onTap: onAvatarTap,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.face_rounded, color: AppColors.primary, size: 28),
                ),
              ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: AppTypography.headlineMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            RewardBadge(type: BadgeType.star, count: stars),
            const SizedBox(width: 8),
            RewardBadge(type: BadgeType.coin, count: coins),
            const SizedBox(width: 8),
            RewardBadge(type: BadgeType.streak, count: streak),
          ],
        ),
      ),
    );
  }
}
