import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

/// Game choice tile — replaces AppCard in all game/quiz contexts.
///
/// Visual language:
/// - Emoji/content large and centered (80px+ illustrated area)
/// - No plain white box — uses world-tinted backgrounds
/// - Animated feedback: correct = green pulse + star; wrong = gentle shake
/// - Minimum 72dp touch target
class ChoiceObject extends StatefulWidget {
  final String emoji;
  final String? label;
  final bool? isCorrect;      // null = unselected, true = correct, false = wrong
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;
  final Color? baseColor;
  final double emojiSize;
  final double? height;

  const ChoiceObject({
    super.key,
    required this.emoji,
    this.label,
    this.isCorrect,
    this.isSelected = false,
    this.isDisabled = false,
    this.onTap,
    this.baseColor,
    this.emojiSize = 56,
    this.height,
  });

  @override
  State<ChoiceObject> createState() => _ChoiceObjectState();
}

class _ChoiceObjectState extends State<ChoiceObject>
    with TickerProviderStateMixin {
  late AnimationController _pressController;
  late AnimationController _feedbackController;
  late Animation<double> _scaleAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _glowAnim;

  @override
  void initState() {
    super.initState();

    _pressController = AnimationController(
      vsync: this,
      duration: AppMotion.tapResponse,
      reverseDuration: AppMotion.stateChange,
    );

    _feedbackController = AnimationController(
      vsync: this,
      duration: AppMotion.characterReaction,
    );

    _scaleAnim = Tween<double>(begin: 1.0, end: AppMotion.buttonPressScale)
        .animate(CurvedAnimation(parent: _pressController, curve: Curves.easeOut));

    // Shake: oscillates ±6px for wrong answer
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 6), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6, end: -4), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -4, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _feedbackController, curve: Curves.easeInOut));

    // Scale pop for correct
    _glowAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.18), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _feedbackController, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(ChoiceObject oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCorrect != oldWidget.isCorrect && widget.isSelected) {
      _feedbackController.reset();
      _feedbackController.forward();
      if (widget.isCorrect == true) {
        HapticFeedback.mediumImpact();
      } else if (widget.isCorrect == false) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  @override
  void dispose() {
    _pressController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  Color get _backgroundColor {
    if (!widget.isSelected) {
      return widget.baseColor?.withAlpha(30) ?? const Color(0xFFF5ECD7);
    }
    if (widget.isCorrect == true) return AppColors.correctGreen.withAlpha(40);
    if (widget.isCorrect == false) return AppColors.tryAgainOrange.withAlpha(40);
    return widget.baseColor?.withAlpha(60) ?? AppColors.sunLight;
  }

  Color get _borderColor {
    if (!widget.isSelected) {
      return widget.baseColor?.withAlpha(100) ?? AppColors.earthLight;
    }
    if (widget.isCorrect == true) return AppColors.correctGreen;
    if (widget.isCorrect == false) return AppColors.tryAgainOrange;
    return widget.baseColor ?? AppColors.sunYellow;
  }

  double get _borderWidth {
    return widget.isSelected ? 3.0 : 2.0;
  }

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.onTap != null && !widget.isDisabled &&
        !(widget.isSelected && widget.isCorrect == true);

    Widget content = AnimatedBuilder(
      animation: _feedbackController,
      builder: (context, child) {
        double translateX = 0;
        double scale = 1.0;

        if (widget.isCorrect == false && widget.isSelected) {
          translateX = _shakeAnim.value;
        } else if (widget.isCorrect == true && widget.isSelected) {
          scale = _glowAnim.value;
        }

        return Transform.translate(
          offset: Offset(translateX, 0),
          child: Transform.scale(
            scale: scale,
            child: child,
          ),
        );
      },
      child: AnimatedContainer(
        duration: AppMotion.stateChange,
        height: widget.height ?? 100,
        decoration: BoxDecoration(
          color: _backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _borderColor, width: _borderWidth),
          boxShadow: [
            BoxShadow(
              color: _borderColor.withAlpha(widget.isSelected ? 60 : 30),
              blurRadius: widget.isSelected ? 12 : 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(widget.emoji, style: TextStyle(fontSize: widget.emojiSize)),
                    // Star overlay on correct
                    if (widget.isCorrect == true && widget.isSelected)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: AnimatedBuilder(
                          animation: _feedbackController,
                          builder: (c, _) => Opacity(
                            opacity: _feedbackController.value,
                            child: const Text('⭐', style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                  ],
                ),
                if (widget.label != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      widget.label!,
                      style: AppTypography.labelLarge.copyWith(
                        color: widget.isSelected && widget.isCorrect == true
                            ? AppColors.meadowDark
                            : AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final interactive = GestureDetector(
      onTapDown: isClickable && !disableAnimations
          ? (_) => _pressController.forward()
          : null,
      onTapUp: isClickable
          ? (_) {
              if (!disableAnimations) _pressController.reverse();
              widget.onTap?.call();
            }
          : null,
      onTapCancel: isClickable && !disableAnimations ? () => _pressController.reverse() : null,
      child: disableAnimations
          ? content
          : ScaleTransition(
              scale: _scaleAnim,
              child: content,
            ),
    );

    final semanticStatus = widget.isSelected
        ? (widget.isCorrect == true
            ? ', correct'
            : (widget.isCorrect == false ? ', try again' : ', selected'))
        : '';
    final semanticLabel = '${widget.label ?? widget.emoji}$semanticStatus';

    return RepaintBoundary(
      child: Semantics(
        button: true,
        label: semanticLabel,
        selected: widget.isSelected,
        enabled: isClickable,
        child: interactive,
      ),
    );
  }
}
