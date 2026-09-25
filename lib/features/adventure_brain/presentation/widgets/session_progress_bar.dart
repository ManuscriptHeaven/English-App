import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/adaptive/learning_session.dart';
import '../../domain/adaptive/session_activity.dart';

/// Playful, child-friendly progress indicator showing session steps
/// with paw prints and stars rather than clinical percentages.
class SessionProgressBar extends StatelessWidget {
  final LearningSession session;

  const SessionProgressBar({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final activities = session.activities;
    if (activities.isEmpty) return const SizedBox.shrink();

    final currentIdx = session.currentActivityIndex.clamp(0, activities.length - 1);
    final completedCount = session.completedCount;
    final totalCount = session.totalCount;
    final isDone = session.isCompleted || completedCount == totalCount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(235),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.sunYellow,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.sunYellow.withAlpha(50),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step icons (Paws / Stars)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(activities.length, (index) {
              final act = activities[index];
              final isStepCompleted = act.isCompleted;
              final isCurrent = index == currentIdx && !isDone;

              String icon;
              if (act.activityType == SessionActivityType.celebration || index == activities.length - 1) {
                icon = isStepCompleted ? '⭐' : '🌟';
              } else {
                icon = '🐾';
              }

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isStepCompleted
                        ? AppColors.sunYellow.withAlpha(70)
                        : (isCurrent
                            ? AppColors.coralWarm.withAlpha(40)
                            : Colors.grey.withAlpha(25)),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isStepCompleted
                          ? AppColors.sunYellow
                          : (isCurrent ? AppColors.coralWarm : Colors.transparent),
                      width: isCurrent ? 2.5 : 1.5,
                    ),
                  ),
                  child: Opacity(
                    opacity: isStepCompleted || isCurrent ? 1.0 : 0.45,
                    child: Text(
                      icon,
                      style: TextStyle(
                        fontSize: isCurrent ? 20 : 16,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          // Child-friendly text status
          Text(
            isDone
                ? "Adventure Complete! You're amazing! ⭐"
                : "Today's Mission: Step ${currentIdx + 1} of $totalCount",
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.earthDark,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
