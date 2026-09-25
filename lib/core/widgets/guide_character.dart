import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_radius.dart';

/// Cheerful Guide Character ("Pip the Falcon") providing voice prompts,
/// gentle instructions, and positive encouragement.
class GuideCharacterBanner extends StatelessWidget {
  final String message;
  final String characterName;
  final VoidCallback? onSpeakTap;
  final IconData moodIcon;
  final Color backgroundColor;

  const GuideCharacterBanner({
    super.key,
    required this.message,
    this.characterName = 'Pip the Falcon',
    this.onSpeakTap,
    this.moodIcon = Icons.flutter_dash_rounded,
    this.backgroundColor = AppColors.primaryLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Guide Character Avatar
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(
              moodIcon,
              color: AppColors.primaryDark,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          // Speech Bubble Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      characterName,
                      style: AppTypography.badgeText.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (onSpeakTap != null)
                      GestureDetector(
                        onTap: onSpeakTap,
                        child: const Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
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
