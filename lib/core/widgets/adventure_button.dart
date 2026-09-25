import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

/// Premium child-facing CTA button.
/// Replaces [AppButton] for all child-facing screens.
///
/// Features:
/// - Scale-down press animation (tactile feel)
/// - Cartoon drop shadow
/// - Age-adaptive minimum height
/// - Vibration feedback on tap
class AdventureButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final String? leadingEmoji;
  final IconData? icon;
  final bool isLoading;
  final int childAge;

  const AdventureButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = AppColors.sunYellow,
    this.foregroundColor,
    this.height,
    this.width,
    this.leadingEmoji,
    this.icon,
    this.isLoading = false,
    this.childAge = 6,
  });

  @override
  State<AdventureButton> createState() => _AdventureButtonState();
}

class _AdventureButtonState extends State<AdventureButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.tapResponse,
      reverseDuration: AppMotion.stateChange,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: AppMotion.buttonPressScale)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
      HapticFeedback.lightImpact();
    }
  }

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  double get _height {
    if (widget.height != null) return widget.height!;
    if (widget.childAge <= 4) return 76;
    if (widget.childAge <= 6) return 68;
    if (widget.childAge <= 8) return 60;
    return 56;
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final isEnabled = widget.onPressed != null && !widget.isLoading;
    final fgColor = widget.foregroundColor ??
        (widget.backgroundColor.computeLuminance() > 0.4
            ? AppColors.textPrimary
            : Colors.white);

    Widget buttonContent = Container(
      height: _height,
      width: widget.width,
      constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
      decoration: BoxDecoration(
        color: isEnabled
            ? widget.backgroundColor
            : AppColors.lockGrey,
            borderRadius: BorderRadius.circular(999),
            boxShadow: isEnabled
                ? [
                    // Cartoon drop shadow — thick, offset downward
                    BoxShadow(
                      color: Color.lerp(
                              widget.backgroundColor, Colors.black, 0.35) ??
                          Colors.black38,
                      offset: const Offset(0, 5),
                      blurRadius: 0,
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: widget.backgroundColor.withAlpha(80),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                        color: fgColor, strokeWidth: 2.5),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leadingEmoji != null) ...[
                        Text(widget.leadingEmoji!,
                            style: const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                      ],
                      if (widget.icon != null) ...[
                        Icon(widget.icon, color: fgColor, size: 24),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        widget.text,
                        style:
                            AppTypography.buttonForAge(widget.childAge).copyWith(
                          color: fgColor,
                        ),
                      ),
                    ],
                  ),
          ),
        );

    final interactive = GestureDetector(
      onTapDown: disableAnimations ? null : _onTapDown,
      onTapUp: disableAnimations ? null : _onTapUp,
      onTapCancel: disableAnimations ? null : _onTapCancel,
      onTap: isEnabled ? widget.onPressed : null,
      child: disableAnimations
          ? buttonContent
          : ScaleTransition(
              scale: _scaleAnim,
              child: buttonContent,
            ),
    );

    return Semantics(
      button: true,
      label: widget.text,
      enabled: isEnabled,
      child: interactive,
    );
  }
}
