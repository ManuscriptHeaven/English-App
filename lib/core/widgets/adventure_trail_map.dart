import 'package:flutter/material.dart';
import 'package:kids_english_adventure/core/theme/app_colors.dart';
import 'package:kids_english_adventure/core/theme/app_radius.dart';
import 'package:kids_english_adventure/core/theme/app_typography.dart';
import 'package:kids_english_adventure/features/worlds/domain/models/lesson.dart';

/// Interactive Illustrated Adventure Trail Map connecting sequential lesson nodes.
class AdventureTrailMap extends StatelessWidget {
  final List<Lesson> lessons;
  final int currentLessonIndex;
  final void Function(Lesson lesson) onLessonTap;

  const AdventureTrailMap({
    super.key,
    required this.lessons,
    required this.currentLessonIndex,
    required this.onLessonTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final lesson = lessons[index];
        final isCompleted = index < currentLessonIndex;
        final isCurrent = index == currentLessonIndex;
        final isLocked = index > currentLessonIndex && !lesson.isUnlocked;

        // Winding trail offset pattern: Left -> Center -> Right -> Center -> Left
        final alignment = (index % 3 == 0)
            ? Alignment.centerLeft
            : (index % 3 == 1)
                ? Alignment.center
                : Alignment.centerRight;

        return Column(
          children: [
            Align(
              alignment: alignment,
              child: _TrailNodeWidget(
                lesson: lesson,
                stepNumber: index + 1,
                isCompleted: isCompleted,
                isCurrent: isCurrent,
                isLocked: isLocked,
                onTap: () => onLessonTap(lesson),
              ),
            ),
            if (index < lessons.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: CustomPaint(
                  size: const Size(40, 28),
                  painter: _TrailConnectorPainter(
                    isCompleted: isCompleted,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TrailNodeWidget extends StatefulWidget {
  final Lesson lesson;
  final int stepNumber;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLocked;
  final VoidCallback onTap;

  const _TrailNodeWidget({
    required this.lesson,
    required this.stepNumber,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLocked,
    required this.onTap,
  });

  @override
  State<_TrailNodeWidget> createState() => _TrailNodeWidgetState();
}

class _TrailNodeWidgetState extends State<_TrailNodeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
    );
    _pulseScale = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isCurrent) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant _TrailNodeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCurrent && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isCurrent && _pulseController.isAnimating) {
      _pulseController.stop();
      _pulseController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color nodeColor;
    Widget nodeBadge;

    if (widget.isCompleted) {
      nodeColor = AppColors.correctGreen;
      nodeBadge = const Text('⭐', style: TextStyle(fontSize: 32));
    } else if (widget.isCurrent) {
      nodeColor = AppColors.secondary;
      nodeBadge = const Text('✨', style: TextStyle(fontSize: 32));
    } else {
      nodeColor = Colors.grey.shade400;
      nodeBadge = const Icon(Icons.lock_rounded, color: Colors.white, size: 28);
    }

    return ScaleTransition(
      scale: widget.isCurrent ? _pulseScale : const AlwaysStoppedAnimation(1.0),
      child: GestureDetector(
        onTap: widget.isLocked ? null : widget.onTap,
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppRadius.roundedLg,
            border: Border.all(
              color: nodeColor,
              width: widget.isCurrent ? 3 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: nodeColor.withAlpha(widget.isCurrent ? 120 : 50),
                blurRadius: widget.isCurrent ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: nodeColor.withAlpha(40),
                child: nodeBadge,
              ),
              const SizedBox(height: 6),
              Text(
                'Step ${widget.stepNumber}',
                style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.bold, color: nodeColor),
              ),
              const SizedBox(height: 2),
              Text(
                widget.lesson.title.replaceAll(RegExp(r'Step \d+: '), ''),
                style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrailConnectorPainter extends CustomPainter {
  final bool isCompleted;
  _TrailConnectorPainter({required this.isCompleted});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isCompleted ? AppColors.correctGreen : AppColors.cardBorder
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
