import 'package:flutter/material.dart';
import 'dart:math' as math;

class SnowOverlay extends StatefulWidget {
  const SnowOverlay({super.key});

  @override
  State<SnowOverlay> createState() => _SnowOverlayState();
}

class _SnowOverlayState extends State<SnowOverlay>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Snowflake> _snowflakes = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();

    // Initialize snowflakes
    for (int i = 0; i < 50; i++) {
      _snowflakes.add(Snowflake());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: SnowPainter(_snowflakes, _controller.value),
        );
      },
    );
  }
}

class Snowflake {
  late double x;
  late double y;
  late double size;
  late double speed;
  late double drift;

  Snowflake() {
    reset();
  }

  void reset() {
    x = math.Random().nextDouble();
    y = -0.1;
    size = math.Random().nextDouble() * 3 + 1;
    speed = math.Random().nextDouble() * 0.02 + 0.01;
    drift = (math.Random().nextDouble() - 0.5) * 0.002;
  }

  void update() {
    y += speed;
    x += drift;
    
    if (y > 1.1) {
      reset();
    }
    if (x < -0.1 || x > 1.1) {
      x = math.Random().nextDouble();
    }
  }
}

class SnowPainter extends CustomPainter {
  final List<Snowflake> snowflakes;
  final double animationValue;

  SnowPainter(this.snowflakes, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    for (final snowflake in snowflakes) {
      snowflake.update();
      
      final dx = snowflake.x * size.width;
      final dy = snowflake.y * size.height;
      
      canvas.drawCircle(
        Offset(dx, dy),
        snowflake.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
