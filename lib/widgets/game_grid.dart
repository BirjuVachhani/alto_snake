import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameGrid extends StatelessWidget {
  final List<Position> snakeBody;
  final Position food;
  final int gridWidth;
  final int gridHeight;

  const GameGrid({
    super.key,
    required this.snakeBody,
    required this.food,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: CustomPaint(
          painter: GameGridPainter(
            snakeBody: snakeBody,
            food: food,
            gridWidth: gridWidth,
            gridHeight: gridHeight,
          ),
        ),
      ),
    );
  }
}

class GameGridPainter extends CustomPainter {
  final List<Position> snakeBody;
  final Position food;
  final int gridWidth;
  final int gridHeight;

  GameGridPainter({
    required this.snakeBody,
    required this.food,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / gridWidth;
    final cellHeight = size.height / gridHeight;

    // Draw snake with improved colors and contrast
    final snakePaint = Paint()
      ..color = const Color(0xFF1B5E20) // Darker green
      ..style = PaintingStyle.fill;

    final snakeHeadPaint = Paint()
      ..color = const Color(0xFF2E7D32) // Slightly lighter green for head
      ..style = PaintingStyle.fill;

    for (int i = 0; i < snakeBody.length; i++) {
      final segment = snakeBody[i];
      final rect = Rect.fromLTWH(
        segment.x * cellWidth,
        segment.y * cellHeight,
        cellWidth,
        cellHeight,
      );

      final paint = i == 0 ? snakeHeadPaint : snakePaint;
      final radius = i == 0 ? 8.0 : 6.0;
      
      // Draw shadow first
      final shadowPaint = Paint()
        ..color = Colors.black.withValues(alpha: 0.4)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          rect.deflate(1).translate(2, 2),
          Radius.circular(radius),
        ),
        shadowPaint,
      );

      // Draw main segment
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect.deflate(1), Radius.circular(radius)),
        paint,
      );

      // Add highlight for 3D effect
      if (i == 0) {
        final highlightPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            rect.deflate(3).translate(-1, -1),
            Radius.circular(radius - 2),
          ),
          highlightPaint,
        );
      }
    }

    // Draw food with improved appearance
    final foodRect = Rect.fromLTWH(
      food.x * cellWidth,
      food.y * cellHeight,
      cellWidth,
      cellHeight,
    );

    // Food shadow
    final foodShadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        foodRect.deflate(2).translate(2, 2),
        const Radius.circular(10),
      ),
      foodShadowPaint,
    );

    // Food main color
    final foodPaint = Paint()
      ..color = const Color(0xFFD32F2F) // Darker red
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(foodRect.deflate(2), const Radius.circular(10)),
      foodPaint,
    );

    // Food highlight
    final foodHighlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.fill;
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        foodRect.deflate(5).translate(-1, -1),
        const Radius.circular(8),
      ),
      foodHighlightPaint,
    );

    // Food glow effect
    final glowPaint = Paint()
      ..color = const Color(0xFFFF5722).withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(foodRect.deflate(0), const Radius.circular(12)),
      glowPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
