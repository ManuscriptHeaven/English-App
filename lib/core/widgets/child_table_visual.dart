import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A clearly recognizable, child-friendly Table visual widget.
///
/// Unmistakably displays:
/// - A flat horizontal tabletop with warm honey-wood bevel and rounded corners
/// - Four visible wooden legs with support crossbeam and clear 3D perspective silhouette
/// - When [hasBookOnTop] is true, an open colorful book visually rests directly ON the tabletop surface
///
/// A child can identify it as a table without reading the word "Table".
class ChildTableVisual extends StatelessWidget {
  /// Overall width of the visual
  final double width;

  /// Overall height of the visual
  final double height;

  /// Whether the book is placed on top of the table
  final bool hasBookOnTop;

  /// Highlight border or hover state
  final bool isHovered;

  const ChildTableVisual({
    super.key,
    this.width = 130,
    this.height = 95,
    this.hasBookOnTop = false,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _TablePainter(
          hasBookOnTop: hasBookOnTop,
          isHovered: isHovered,
        ),
      ),
    );
  }
}

class _TablePainter extends CustomPainter {
  final bool hasBookOnTop;
  final bool isHovered;

  const _TablePainter({
    required this.hasBookOnTop,
    this.isHovered = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Allocate vertical space: if book on top, top 38% is for book, bottom 62% for table
    final bookSpaceH = hasBookOnTop ? h * 0.38 : h * 0.08;
    final tableTopY = bookSpaceH;
    final tableH = h - tableTopY;

    final tabletopThickness = (tableH * 0.25).clamp(12.0, 22.0);
    final legW = (w * 0.085).clamp(7.0, 13.0);

    // ==========================================
    // 1. REAR LEGS (Darker perspective wood)
    // ==========================================
    final rearLegPaint = Paint()
      ..color = const Color(0xFF5A2C0A)
      ..style = PaintingStyle.fill;

    // Rear-left leg
    final backLeftR = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.22,
        tableTopY + tabletopThickness * 0.7,
        legW * 0.85,
        tableH * 0.88 - tabletopThickness * 0.7,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(backLeftR, rearLegPaint);

    // Rear-right leg
    final backRightR = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.78 - legW * 0.85,
        tableTopY + tabletopThickness * 0.7,
        legW * 0.85,
        tableH * 0.88 - tabletopThickness * 0.7,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(backRightR, rearLegPaint);

    // Ground shadows under rear legs
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(25)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.22 + legW * 0.42, tableTopY + tableH * 0.90),
        width: legW * 1.5,
        height: 4,
      ),
      shadowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.78 - legW * 0.42, tableTopY + tableH * 0.90),
        width: legW * 1.5,
        height: 4,
      ),
      shadowPaint,
    );

    // ==========================================
    // 2. UNDER-TABLE CROSSBEAM / SUPPORT APRON
    // ==========================================
    final apronPaint = Paint()
      ..color = const Color(0xFF7A3E14)
      ..style = PaintingStyle.fill;
    final apronR = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.14,
        tableTopY + tabletopThickness * 0.8,
        w * 0.72,
        (tableH * 0.12).clamp(6.0, 11.0),
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(apronR, apronPaint);

    // ==========================================
    // 3. FRONT LEGS (Warm sturdy wood, splayed)
    // ==========================================
    final frontLegPaint = Paint()
      ..color = isHovered ? AppColors.secondaryDark : const Color(0xFF8F4D1E)
      ..style = PaintingStyle.fill;

    // Front-left leg (angled slightly outward for classic stable picnic/dining table silhouette)
    final leftLegPath = Path()
      ..moveTo(w * 0.13, tableTopY + tabletopThickness * 0.6)
      ..lineTo(w * 0.13 + legW, tableTopY + tabletopThickness * 0.6)
      ..lineTo(w * 0.09 + legW, tableTopY + tableH)
      ..lineTo(w * 0.07, tableTopY + tableH)
      ..close();
    canvas.drawPath(leftLegPath, frontLegPaint);

    // Front-right leg
    final rightLegPath = Path()
      ..moveTo(w * 0.87 - legW, tableTopY + tabletopThickness * 0.6)
      ..lineTo(w * 0.87, tableTopY + tabletopThickness * 0.6)
      ..lineTo(w * 0.93, tableTopY + tableH)
      ..lineTo(w * 0.91 - legW, tableTopY + tableH)
      ..close();
    canvas.drawPath(rightLegPath, frontLegPaint);

    // Ground shadows under front legs
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.08 + legW * 0.5, tableTopY + tableH),
        width: legW * 1.8,
        height: 6,
      ),
      shadowPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.92 - legW * 0.5, tableTopY + tableH),
        width: legW * 1.8,
        height: 6,
      ),
      shadowPaint,
    );

    // ==========================================
    // 4. TABLETOP 3D LIP & APRON
    // ==========================================
    final lipPaint = Paint()
      ..color = const Color(0xFF7A3E14)
      ..style = PaintingStyle.fill;
    final lipR = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.03,
        tableTopY + tabletopThickness * 0.4,
        w * 0.94,
        tabletopThickness * 0.65,
      ),
      const Radius.circular(5),
    );
    canvas.drawRRect(lipR, lipPaint);

    // ==========================================
    // 5. TABLETOP SURFACE (Warm Honey Oak Plank)
    // ==========================================
    final topPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFDE9953), // Honey amber wood top face
          Color(0xFFB86C2C), // Rich warm cedar body
        ],
      ).createShader(Rect.fromLTWH(w * 0.02, tableTopY, w * 0.96, tabletopThickness * 0.85))
      ..style = PaintingStyle.fill;

    final topR = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        w * 0.02,
        tableTopY,
        w * 0.96,
        tabletopThickness * 0.85,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(topR, topPaint);

    // Wood Plank Highlight Grooves
    final groovePaint = Paint()
      ..color = const Color(0xFFFFD9A8).withAlpha(180)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(w * 0.06, tableTopY + tabletopThickness * 0.22),
      Offset(w * 0.94, tableTopY + tabletopThickness * 0.22),
      groovePaint,
    );

    // Tabletop Border
    final borderPaint = Paint()
      ..color = isHovered ? AppColors.secondary : const Color(0xFF6B330B)
      ..strokeWidth = isHovered ? 2.5 : 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawRRect(topR, borderPaint);

    // ==========================================
    // 6. BOOK RESTING DIRECTLY ON TABLETOP
    // ==========================================
    if (hasBookOnTop) {
      _paintBookOnTable(canvas, w, tableTopY, bookSpaceH);
    }
  }

  /// Paints a child-friendly open book resting directly ON the tabletop surface.
  void _paintBookOnTable(Canvas canvas, double w, double tableTopY, double bookSpaceH) {
    final centerX = w * 0.5;
    // Base of the book rests exactly on tableTopY!
    final bookBaseY = tableTopY + 1.5; // slight overlap with top wood surface
    final bookW = (w * 0.44).clamp(42.0, 68.0);
    final bookH = (bookSpaceH * 0.90).clamp(24.0, 42.0);
    final bookTopY = bookBaseY - bookH;

    // 1. Soft shadow cast by book on tabletop
    final bookShadow = Paint()
      ..color = Colors.black.withAlpha(45)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, bookBaseY),
        width: bookW * 1.05,
        height: 5,
      ),
      bookShadow,
    );

    // 2. Book Cover (Vibrant Royal Blue)
    final coverPaint = Paint()
      ..color = const Color(0xFF1565C0)
      ..style = PaintingStyle.fill;
    final coverStroke = Paint()
      ..color = const Color(0xFF0D47A1)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final leftCover = Path()
      ..moveTo(centerX, bookBaseY)
      ..lineTo(centerX - bookW * 0.5, bookBaseY - 2)
      ..lineTo(centerX - bookW * 0.48, bookTopY)
      ..lineTo(centerX, bookTopY + bookH * 0.15)
      ..close();
    canvas.drawPath(leftCover, coverPaint);
    canvas.drawPath(leftCover, coverStroke);

    final rightCover = Path()
      ..moveTo(centerX, bookBaseY)
      ..lineTo(centerX + bookW * 0.5, bookBaseY - 2)
      ..lineTo(centerX + bookW * 0.48, bookTopY)
      ..lineTo(centerX, bookTopY + bookH * 0.15)
      ..close();
    canvas.drawPath(rightCover, coverPaint);
    canvas.drawPath(rightCover, coverStroke);

    // 3. Pages (Crisp warm cream pages with gentle curve)
    final pagePaint = Paint()
      ..color = const Color(0xFFFFFDE7)
      ..style = PaintingStyle.fill;
    final pageStroke = Paint()
      ..color = const Color(0xFFD7CCC8)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final leftPage = Path()
      ..moveTo(centerX, bookBaseY - 1)
      ..lineTo(centerX - bookW * 0.46, bookBaseY - 3)
      ..lineTo(centerX - bookW * 0.44, bookTopY + 2)
      ..lineTo(centerX, bookTopY + bookH * 0.18)
      ..close();
    canvas.drawPath(leftPage, pagePaint);
    canvas.drawPath(leftPage, pageStroke);

    final rightPage = Path()
      ..moveTo(centerX, bookBaseY - 1)
      ..lineTo(centerX + bookW * 0.46, bookBaseY - 3)
      ..lineTo(centerX + bookW * 0.44, bookTopY + 2)
      ..lineTo(centerX, bookTopY + bookH * 0.18)
      ..close();
    canvas.drawPath(rightPage, pagePaint);
    canvas.drawPath(rightPage, pageStroke);

    // 4. Page Text Lines (tiny cheerful story lines)
    final linePaint = Paint()
      ..color = const Color(0xFF90A4AE)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    // Left page lines
    final lineSpacing = bookH * 0.18;
    for (int i = 0; i < 3; i++) {
      final y = bookTopY + bookH * 0.35 + i * lineSpacing;
      canvas.drawLine(
        Offset(centerX - bookW * 0.38, y),
        Offset(centerX - bookW * 0.10, y + 1),
        linePaint,
      );
    }

    // Right page lines
    for (int i = 0; i < 3; i++) {
      final y = bookTopY + bookH * 0.35 + i * lineSpacing;
      canvas.drawLine(
        Offset(centerX + bookW * 0.10, y + 1),
        Offset(centerX + bookW * 0.38, y),
        linePaint,
      );
    }

    // 5. Red Ribbon Bookmark (drapes down the center spine)
    final ribbonPaint = Paint()
      ..color = const Color(0xFFE53935)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(centerX, bookTopY + bookH * 0.18),
      Offset(centerX, bookBaseY + 4),
      ribbonPaint,
    );

    // 6. Sparkles around the book (golden stars)
    _drawSparkle(canvas, centerX - bookW * 0.40, bookTopY - 2, 4.0, const Color(0xFFFFD54F));
    _drawSparkle(canvas, centerX + bookW * 0.40, bookTopY - 2, 4.0, const Color(0xFFFFD54F));
  }

  void _drawSparkle(Canvas canvas, double x, double y, double radius, Color color) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(x, y - radius)
      ..quadraticBezierTo(x, y, x + radius, y)
      ..quadraticBezierTo(x, y, x, y + radius)
      ..quadraticBezierTo(x, y, x - radius, y)
      ..quadraticBezierTo(x, y, x, y - radius)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TablePainter oldDelegate) {
    return oldDelegate.hasBookOnTop != hasBookOnTop || oldDelegate.isHovered != isHovered;
  }
}
