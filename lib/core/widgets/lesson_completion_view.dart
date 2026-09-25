import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../experience/child_experience_controller.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'app_button.dart';
import 'pip_character_guide.dart';

/// High-quality, joyful lesson completion view celebrating child progress
/// without overwhelming popups or slot-machine mechanics.
class LessonCompletionView extends ConsumerStatefulWidget {
  final String lessonTitle;
  final List<String> practicedItems;
  final int stars; // 1 to 3 stars (1 star is still a valid achievement)
  final int xpEarned;
  final int coinsEarned;
  final VoidCallback onContinue;
  final VoidCallback? onPracticeAgain;

  const LessonCompletionView({
    super.key,
    required this.lessonTitle,
    required this.practicedItems,
    this.stars = 3,
    this.xpEarned = 25,
    this.coinsEarned = 15,
    required this.onContinue,
    this.onPracticeAgain,
  });

  @override
  ConsumerState<LessonCompletionView> createState() => _LessonCompletionViewState();
}

class _LessonCompletionViewState extends ConsumerState<LessonCompletionView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  bool _hasContinued = false;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: AppMotion.celebration,
    );

    _scaleAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: AppMotion.spring,
    );

    _fadeAnim = CurvedAnimation(
      parent: _animCtrl,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_hasContinued) return;
    _hasContinued = true;

    // Instant cancellation of active celebration animation / sound
    ref.read(childExperienceControllerProvider).cancelActiveCelebration();
    widget.onContinue();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    final content = Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: AppRadius.roundedXl,
          border: Border.all(color: AppColors.sunYellow, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(40),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pip Mascot celebrating
            const PipCharacterGuide(
              state: PipState.celebrating,
              characterSize: 84,
              showSpeechBubble: false,
            ),
            const SizedBox(height: 12),

            // Milestone Banner
            Text(
              'Adventure Complete! 🌟',
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),

            // Lesson Title
            Text(
              widget.lessonTitle,
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Stars Row (1 to 3 stars, all positive)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                final earned = index < widget.stars;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    earned ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: earned ? AppColors.sunYellow : Colors.grey.shade300,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),

            // Practiced Concepts
            if (widget.practicedItems.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.mintLight.withAlpha(80),
                  borderRadius: AppRadius.roundedMd,
                ),
                child: Column(
                  children: [
                    Text(
                      'Today you practiced:',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.practicedItems.join(' • '),
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],

            // Encouragement message
            Text(
              'Great speaking today!',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Primary Action: Continue
            AppButton(
              text: 'Continue',
              icon: Icons.arrow_forward_rounded,
              onPressed: _handleContinue,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minWidth: double.infinity,
            ),

            // Optional Secondary: Practice Again
            if (widget.onPracticeAgain != null) ...[
              const SizedBox(height: 10),
              AppButton(
                text: 'Practice Again',
                icon: Icons.replay_rounded,
                backgroundColor: AppColors.mintLight,
                foregroundColor: AppColors.primaryDark,
                onPressed: () {
                  ref.read(childExperienceControllerProvider).cancelActiveCelebration();
                  widget.onPracticeAgain!();
                },
                minWidth: double.infinity,
              ),
            ],
          ],
        ),
      ),
    );

    if (disableAnimations) {
      return content;
    }

    return FadeTransition(
      opacity: _fadeAnim,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: content,
      ),
    );
  }
}
