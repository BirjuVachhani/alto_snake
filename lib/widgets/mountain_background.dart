import 'package:flutter/material.dart';
import 'dart:math' as math;

class MountainBackground extends StatelessWidget {
  const MountainBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: MountainPainter(),
    );
  }
}

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background gradient
    final backgroundPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFFC3AED6), // Light, dusky purple
          const Color(0xFFD6CADD), // Very light purple
          const Color(0xFFEBE2F2), // Almost white purple
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Mountain layers
    _drawMountainLayer(canvas, size, 0.6, const Color(0xFF6A4C8D), 0.4);
    _drawMountainLayer(canvas, size, 0.7, const Color(0xFF8B72A8), 0.3);
    _drawMountainLayer(canvas, size, 0.8, const Color(0xFFAC99C4), 0.2);
  }

  void _drawMountainLayer(Canvas canvas, Size size, double baseHeight,
      Color color, double opacity) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    // Create mountain silhouette
    final peaks = 6;
    for (int i = 0; i <= peaks; i++) {
      final x = (size.width / peaks) * i;
      final peakHeight = size.height * (baseHeight + (math.sin(i * 0.7) * 0.1));
      final controlHeight =
          size.height * (baseHeight + (math.sin(i * 0.7 + 0.5) * 0.05));

      if (i == 0) {
        path.lineTo(x, peakHeight);
      } else {
        final prevX = (size.width / peaks) * (i - 1);
        final midX = (prevX + x) / 2;
        path.quadraticBezierTo(midX, controlHeight, x, peakHeight);
      }
    }

    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
