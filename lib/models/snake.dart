import 'game_state.dart';

class Snake {
  List<Position> body;
  Direction direction;

  Snake({
    required this.body,
    this.direction = Direction.right,
  });

  Position get head => body.first;

  void move() {
    final Position directionOffset = _getDirectionOffset();
    final Position newHead = head + directionOffset;
    
    body.insert(0, newHead);
    body.removeLast();
  }

  void grow() {
    final Position directionOffset = _getDirectionOffset();
    final Position newHead = head + directionOffset;
    
    body.insert(0, newHead);
  }

  bool checkCollision(int gridWidth, int gridHeight) {
    // Check wall collision
    if (head.x < 0 || head.x >= gridWidth || head.y < 0 || head.y >= gridHeight) {
      return true;
    }

    // Check self collision
    for (int i = 1; i < body.length; i++) {
      if (body[i] == head) {
        return true;
      }
    }

    return false;
  }

  Position _getDirectionOffset() {
    switch (direction) {
      case Direction.up:
        return const Position(0, -1);
      case Direction.down:
        return const Position(0, 1);
      case Direction.left:
        return const Position(-1, 0);
      case Direction.right:
        return const Position(1, 0);
    }
  }
}
