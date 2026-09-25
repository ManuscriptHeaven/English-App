import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';

/// Cheerful card container with thick borders and playful rounded corners.
class AppCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double borderWidth;

  const AppCard({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.surface,
    this.borderColor,
    this.padding = const EdgeInsets.all(16.0),
    this.onTap,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.roundedLg,
        border: Border.all(
          color: borderColor ?? AppColors.cardBorder,
          width: borderWidth,
        ),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.roundedLg,
          child: content,
        ),
      );
    }

    return content;
  }
}
