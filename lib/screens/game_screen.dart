import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:math' as math;
import '../models/game_state.dart';
import '../models/snake.dart';
import '../widgets/mountain_background.dart';
import '../widgets/snow_overlay.dart';
import '../widgets/game_grid.dart';
import '../widgets/game_controls.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  static const int gridWidth = 20;
  static const int gridHeight = 15;
  static const Duration gameSpeed = Duration(milliseconds: 200);

  late Snake snake;
  late Position food;
  GameState gameState = GameState.paused;
  Timer? gameTimer;
  int score = 0;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initializeGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _initializeGame() {
    snake = Snake(
      body: [
        const Position(gridWidth ~/ 2, gridHeight ~/ 2),
        const Position(gridWidth ~/ 2 - 1, gridHeight ~/ 2),
        const Position(gridWidth ~/ 2 - 2, gridHeight ~/ 2),
      ],
      direction: Direction.right,
    );
    _generateFood();
    score = 0;
    gameState = GameState.paused;
  }

  void _generateFood() {
    final random = math.Random();
    Position newFood;
    
    do {
      newFood = Position(
        random.nextInt(gridWidth),
        random.nextInt(gridHeight),
      );
    } while (snake.body.contains(newFood));
    
    food = newFood;
  }

  void _startGame() {
    gameTimer?.cancel();
    if (gameState == GameState.playing) {
      gameTimer = Timer.periodic(gameSpeed, (timer) {
        _updateGame();
      });
    }
  }

  void _updateGame() {
    if (gameState != GameState.playing) return;

    setState(() {
      // Check if snake eats food
      if (snake.head == food) {
        snake.grow();
        _generateFood();
        score += 10;
        HapticFeedback.lightImpact();
      } else {
        snake.move();
      }

      // Check collision
      if (snake.checkCollision(gridWidth, gridHeight)) {
        gameState = GameState.gameOver;
        gameTimer?.cancel();
        HapticFeedback.heavyImpact();
      }
    });
  }

  void _changeDirection(Direction newDirection) {
    if (gameState != GameState.playing) return;

    // Prevent reverse direction
    final opposites = {
      Direction.up: Direction.down,
      Direction.down: Direction.up,
      Direction.left: Direction.right,
      Direction.right: Direction.left,
    };

    if (opposites[snake.direction] != newDirection) {
      setState(() {
        snake.direction = newDirection;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _togglePause() {
    setState(() {
      if (gameState == GameState.playing) {
        gameState = GameState.paused;
        gameTimer?.cancel();
      } else if (gameState == GameState.paused || gameState == GameState.gameOver) {
        if (gameState == GameState.gameOver) {
          _initializeGame();
        }
        gameState = GameState.playing;
        _startGame();
      }
    });
    HapticFeedback.selectionClick();
  }

  void _restartGame() {
    gameTimer?.cancel();
    setState(() {
      _initializeGame();
    });
    HapticFeedback.mediumImpact();
  }

  bool _handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.space:
          _togglePause();
          return true;
        case LogicalKeyboardKey.enter:
          _restartGame();
          return true;
        case LogicalKeyboardKey.arrowUp:
        case LogicalKeyboardKey.keyW:
          _changeDirection(Direction.up);
          return true;
        case LogicalKeyboardKey.arrowDown:
        case LogicalKeyboardKey.keyS:
          _changeDirection(Direction.down);
          return true;
        case LogicalKeyboardKey.arrowLeft:
        case LogicalKeyboardKey.keyA:
          _changeDirection(Direction.left);
          return true;
        case LogicalKeyboardKey.arrowRight:
        case LogicalKeyboardKey.keyD:
          _changeDirection(Direction.right);
          return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        body: Stack(
          children: [
            // Background
            const MountainBackground(),
            const SnowOverlay(),
            
            // Dark overlay for better contrast
            Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
            
            // Game UI
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final availableHeight = constraints.maxHeight;
                  final headerHeight = 80.0;
                  final instructionsHeight = 50.0;
                  final controlsHeight = 180.0;
                  final spacing = 32.0;
                  final gameGridHeight = availableHeight - headerHeight - instructionsHeight - controlsHeight - spacing;
                  
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: availableHeight),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [
                            // Header with background
                            Container(
                              height: headerHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Alto\'s Snake',
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            const Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 3,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'Score: $score',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(1, 1),
                                              blurRadius: 2,
                                              color: Colors.black54,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (gameState == GameState.gameOver)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withValues(alpha: 0.9),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.white, width: 1),
                                      ),
                                      child: const Text(
                                        'Game Over',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Game Grid with fixed height
                            SizedBox(
                              height: gameGridHeight.clamp(200.0, 400.0),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: gridWidth / gridHeight,
                                  child: GameGrid(
                                    snakeBody: snake.body,
                                    food: food,
                                    gridWidth: gridWidth,
                                    gridHeight: gridHeight,
                                  ),
                                ),
                              ),
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Keyboard instructions with better contrast
                            Container(
                              height: instructionsHeight,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'SPACEBAR: Start/Pause • ENTER: Restart',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Arrow Keys or WASD: Move',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 10,
                                      shadows: const [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black87,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Controls with fixed height
                            SizedBox(
                              height: controlsHeight,
                              child: GameControls(
                                onDirectionChange: _changeDirection,
                                onPause: _togglePause,
                                onRestart: _restartGame,
                                gameState: gameState,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Game state overlays
            if (gameState == GameState.paused && score == 0)
              Container(
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'READY?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          'Press SPACEBAR to Start',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (gameState == GameState.paused)
              Container(
                color: Colors.black.withValues(alpha: 0.6),
                child: Center(
                  child: Text(
                    'PAUSED',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
