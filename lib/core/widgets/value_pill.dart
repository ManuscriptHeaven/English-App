import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

/// Pill tag and informative banner for displaying Islamic Values and Good Manners.
class ValuePill extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isLarge;
  final VoidCallback? onTap;

  const ValuePill({
    super.key,
    required this.title,
    this.icon = Icons.favorite_rounded,
    this.isLarge = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isLarge ? 14 : 10,
          vertical: isLarge ? 8 : 4,
        ),
        decoration: BoxDecoration(
          color: AppColors.valueMint,
          borderRadius: AppRadius.roundedPill,
          border: Border.all(color: AppColors.valueEmerald.withValues(alpha: 0.3), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.valueEmerald, size: isLarge ? 20 : 16),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                style: isLarge
                    ? AppTypography.titleLarge.copyWith(
                        color: AppColors.valueEmerald,
                        fontWeight: FontWeight.bold,
                      )
                    : AppTypography.badgeText.copyWith(
                        color: AppColors.valueEmerald,
                        fontWeight: FontWeight.w600,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rich banner that explains the value message positively and gently.
class ValueBanner extends StatelessWidget {
  final String title;
  final String description;
  final String? arabicPhrase;

  const ValueBanner({
    super.key,
    required this.title,
    required this.description,
    this.arabicPhrase,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.valueMint,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.valueEmerald.withValues(alpha: 0.4), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.valueEmerald,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineMedium.copyWith(
                        color: AppColors.valueEmerald,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (arabicPhrase != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.valueGold.withValues(alpha: 0.3),
                          borderRadius: AppRadius.roundedPill,
                        ),
                        child: Text(
                          arabicPhrase!,
                          style: AppTypography.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
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
