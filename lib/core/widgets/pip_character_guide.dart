import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_typography.dart';

/// Pip's expressive emotional states.
enum PipState {
  idle,        // Neutral — gentle idle bob
  speaking,    // Pip is talking — mouth open, active bob
  listening,   // Pip is listening to child — leaning forward
  thinking,    // Processing — looking up, slower bob
  hinting,     // Alias for thinking — waiting for child input
  happy,       // Positive — big smile, faster bob
  excited,     // Very positive — fast bounce
  celebrating, // Correct answer — big jump + scale
  encouraging, // After wrong answer — gentle nod
  surprised,   // Unexpected event
  sleepy,      // End of session / tired
}

extension PipStateEmoji on PipState {
  String get emoji {
    switch (this) {
      case PipState.idle:        return '🦜';
      case PipState.speaking:    return '🦜';
      case PipState.listening:   return '🦜';
      case PipState.thinking:    return '🤔';
      case PipState.hinting:     return '🦜💭';
      case PipState.happy:       return '😊';
      case PipState.excited:     return '🎉';
      case PipState.celebrating: return '🎊';
      case PipState.encouraging: return '💪';
      case PipState.surprised:   return '😮';
      case PipState.sleepy:      return '😴';
    }
  }

  Color get bubbleColor {
    switch (this) {
      case PipState.celebrating:
      case PipState.excited:
        return AppColors.sunYellow;
      case PipState.encouraging:
        return AppColors.mintLight;
      case PipState.thinking:
      case PipState.hinting:
        return AppColors.lavenderLight;
      case PipState.sleepy:
        return AppColors.earthLight;
      default:
        return Colors.white;
    }
  }
}

/// Pip the Parrot — the animated companion character.
///
/// Features:
/// - Continuous idle bob animation (every screen Pip appears)
/// - State-based scale/rotation reactions
/// - Optional speech bubble with text
/// - Tap to interact
///
/// Design principle: Pip should feel ALIVE, not decorative.
class PipCharacterGuide extends StatefulWidget {
  final PipState state;
  final String? speechBubbleText;
  final double characterSize;
  final VoidCallback? onTap;
  final bool showSpeechBubble;

  const PipCharacterGuide({
    super.key,
    this.state = PipState.idle,
    this.speechBubbleText,
    this.characterSize = 96,
    this.onTap,
    this.showSpeechBubble = true,
  });

  @override
  State<PipCharacterGuide> createState() => _PipCharacterGuideState();
}

class _PipCharacterGuideState extends State<PipCharacterGuide>
    with TickerProviderStateMixin {
  // Continuous idle bob
  late AnimationController _bobController;
  late Animation<double> _bobAnim;

  // State reaction (scale pop or bounce on state change)
  late AnimationController _reactionController;
  late Animation<double> _reactionScale;
  late Animation<double> _reactionRotation;

  @override
  void initState() {
    super.initState();

    // Continuous bob — every state has a subtle version
    _bobController = AnimationController(
      vsync: this,
      duration: AppMotion.pipIdleBob,
    )..repeat(reverse: true);

    _bobAnim = Tween<double>(begin: 0, end: AppMotion.pipBobOffset)
        .animate(CurvedAnimation(parent: _bobController, curve: AppMotion.bob));

    // Reaction controller — plays once on state change
    _reactionController = AnimationController(
      vsync: this,
      duration: AppMotion.characterReaction,
    );

    _reactionScale = _buildReactionScaleAnim();
    _reactionRotation = _buildReactionRotationAnim();
  }

  Animation<double> _buildReactionScaleAnim() {
    switch (widget.state) {
      case PipState.celebrating:
      case PipState.excited:
        return TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.30), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.30, end: 0.92), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.92, end: 1.08), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.00), weight: 1),
        ]).animate(CurvedAnimation(parent: _reactionController, curve: Curves.easeOut));
      case PipState.encouraging:
        return TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.08), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.00), weight: 1),
        ]).animate(CurvedAnimation(parent: _reactionController, curve: Curves.easeOut));
      default:
        return ConstantTween<double>(1.0)
            .animate(_reactionController);
    }
  }

  Animation<double> _buildReactionRotationAnim() {
    switch (widget.state) {
      case PipState.thinking:
        return TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.08), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 1),
        ]).animate(CurvedAnimation(parent: _reactionController, curve: Curves.easeInOut));
      case PipState.surprised:
        return TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.12), weight: 1),
          TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.08), weight: 1),
          TweenSequenceItem(tween: Tween(begin: 0.08, end: 0.0), weight: 1),
        ]).animate(CurvedAnimation(parent: _reactionController, curve: Curves.easeOut));
      default:
        return ConstantTween<double>(0.0)
            .animate(_reactionController);
    }
  }

  double get _bobSpeed {
    switch (widget.state) {
      case PipState.excited:
      case PipState.celebrating:
        return 0.4; // faster
      case PipState.sleepy:
        return 0.15; // slow drift
      case PipState.thinking:
        return 0.25;
      default:
        return 1.0;
    }
  }

  @override
  void didUpdateWidget(PipCharacterGuide oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state != oldWidget.state) {
      final disableAnimations = MediaQuery.of(context).disableAnimations;
      // Update bob speed
      _bobController.duration = Duration(
          milliseconds: (AppMotion.pipIdleBob.inMilliseconds / _bobSpeed).round());
      _bobController.reset();
      if (!disableAnimations) {
        _bobController.repeat(reverse: true);
      }

      // Rebuild reaction animations for new state
      _reactionScale = _buildReactionScaleAnim();
      _reactionRotation = _buildReactionRotationAnim();
      _reactionController.reset();
      if (!disableAnimations) {
        _reactionController.forward();
      }
    }
  }

  @override
  void dispose() {
    _bobController.dispose();
    _reactionController.dispose();
    super.dispose();
  }

  String get _displayEmoji {
    switch (widget.state) {
      case PipState.celebrating:
      case PipState.excited:
        return '🦜✨';
      case PipState.thinking:
        return '🦜💭';
      case PipState.listening:
        return '🦜👂';
      case PipState.sleepy:
        return '🦜💤';
      default:
        return '🦜';
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    if (disableAnimations && _bobController.isAnimating) {
      _bobController.stop();
      _bobController.value = 0.0;
    } else if (!disableAnimations && !_bobController.isAnimating) {
      _bobController.repeat(reverse: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Semantics(
      label: widget.speechBubbleText != null && widget.speechBubbleText!.isNotEmpty
          ? 'Pip the Parrot says: ${widget.speechBubbleText}'
          : 'Pip the Parrot mascot guide',
      child: RepaintBoundary(
        child: GestureDetector(
          onTap: widget.onTap,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
              // Speech bubble above Pip
              if (widget.showSpeechBubble && widget.speechBubbleText != null &&
                  widget.speechBubbleText!.isNotEmpty)
                _SpeechBubble(
                  text: widget.speechBubbleText!,
                  bubbleColor: widget.state.bubbleColor,
                  maxWidth: 260,
                ),
              if (widget.showSpeechBubble && widget.speechBubbleText != null &&
                  widget.speechBubbleText!.isNotEmpty)
                const SizedBox(height: 4),

              // Pip character with animations
              AnimatedBuilder(
                animation: Listenable.merge([_bobController, _reactionController]),
                builder: (context, child) {
                  if (disableAnimations) {
                    return child!;
                  }
                  return Transform.translate(
                    offset: Offset(0, -_bobAnim.value),
                    child: Transform.scale(
                      scale: _reactionScale.value,
                      child: Transform.rotate(
                        angle: _reactionRotation.value,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: widget.characterSize,
                  height: widget.characterSize,
                  decoration: BoxDecoration(
                    color: AppColors.sunLight.withAlpha(120),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sunYellow.withAlpha(80),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _displayEmoji,
                    style: TextStyle(fontSize: widget.characterSize * 0.58),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}

/// Pip's speech bubble — above the character.
class _SpeechBubble extends StatelessWidget {
  final String text;
  final Color bubbleColor;
  final double maxWidth;

  const _SpeechBubble({
    required this.text,
    required this.bubbleColor,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(4), // pointer toward Pip
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Text(
          text,
          style: AppTypography.instruction.copyWith(
            fontSize: 17,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
