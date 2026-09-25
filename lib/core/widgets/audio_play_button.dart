import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_english_adventure/core/services/audio_service.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';

/// Reusable child-friendly audio playback button with animated wave indicator and tap debouncing.
class AudioPlayButton extends ConsumerStatefulWidget {
  final String textToSpeak;
  final String? label;
  final double size;
  final AudioPriority priority;
  final VoidCallback? onPlayStart;
  final VoidCallback? onPlayComplete;

  const AudioPlayButton({
    super.key,
    required this.textToSpeak,
    this.label,
    this.size = 56.0,
    this.priority = AudioPriority.learningInstruction,
    this.onPlayStart,
    this.onPlayComplete,
  });

  @override
  ConsumerState<AudioPlayButton> createState() => _AudioPlayButtonState();
}

class _AudioPlayButtonState extends ConsumerState<AudioPlayButton> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  bool _isPlaying = false;
  DateTime? _lastTapTime;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    final now = DateTime.now();
    if (_lastTapTime != null && now.difference(_lastTapTime!).inMilliseconds < 450) {
      return; // Debounce rapid taps
    }
    _lastTapTime = now;

    final audio = ref.read(audioServiceProvider);

    if (_isPlaying) {
      await audio.stop();
      if (mounted) {
        setState(() => _isPlaying = false);
        _animController.stop();
        _animController.reset();
      }
      return;
    }

    setState(() => _isPlaying = true);
    _animController.repeat(reverse: true);
    widget.onPlayStart?.call();

    await audio.playSentence(widget.textToSpeak, priority: widget.priority);

    if (mounted) {
      setState(() => _isPlaying = false);
      _animController.stop();
      _animController.reset();
      widget.onPlayComplete?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _isPlaying ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          width: widget.label != null ? null : widget.size,
          height: widget.size,
          padding: widget.label != null ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8) : null,
          decoration: BoxDecoration(
            color: _isPlaying ? AppColors.secondary : AppColors.primary,
            borderRadius: BorderRadius.circular(widget.size / 2),
            boxShadow: [
              BoxShadow(
                color: (_isPlaying ? AppColors.secondary : AppColors.primary).withAlpha(120),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                color: Colors.white,
                size: widget.size * 0.55,
              ),
              if (widget.label != null) ...[
                const SizedBox(width: 8),
                Text(
                  _isPlaying ? 'Playing...' : widget.label!,
                  style: AppTypography.titleLarge.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
