enum GameState {
  playing,
  paused,
  gameOver,
}

enum Direction {
  up,
  down,
  left,
  right,
}

class Position {
  final int x;
  final int y;

  const Position(this.x, this.y);

  Position operator +(Position other) {
    return Position(x + other.x, y + other.y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Position && other.x == x && other.y == y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
