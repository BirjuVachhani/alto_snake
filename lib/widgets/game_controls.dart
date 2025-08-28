import 'package:flutter/material.dart';
import '../models/game_state.dart';

class GameControls extends StatelessWidget {
  final Function(Direction) onDirectionChange;
  final VoidCallback onPause;
  final VoidCallback onRestart;
  final GameState gameState;

  const GameControls({
    super.key,
    required this.onDirectionChange,
    required this.onPause,
    required this.onRestart,
    required this.gameState,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Directional pad
        SizedBox(
          width: 130,
          height: 130,
          child: Stack(
            children: [
              // Up
              Positioned(
                top: 0,
                left: 40,
                child: _buildControlButton(
                  icon: Icons.keyboard_arrow_up,
                  onPressed: () => onDirectionChange(Direction.up),
                ),
              ),
              // Down
              Positioned(
                bottom: 0,
                left: 40,
                child: _buildControlButton(
                  icon: Icons.keyboard_arrow_down,
                  onPressed: () => onDirectionChange(Direction.down),
                ),
              ),
              // Left
              Positioned(
                top: 40,
                left: 0,
                child: _buildControlButton(
                  icon: Icons.keyboard_arrow_left,
                  onPressed: () => onDirectionChange(Direction.left),
                ),
              ),
              // Right
              Positioned(
                top: 40,
                right: 0,
                child: _buildControlButton(
                  icon: Icons.keyboard_arrow_right,
                  onPressed: () => onDirectionChange(Direction.right),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        // Action buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionButton(
              icon: gameState == GameState.playing ? Icons.pause : Icons.play_arrow,
              label: gameState == GameState.playing ? 'Pause' : 'Play',
              onPressed: onPause,
            ),
            _buildActionButton(
              icon: Icons.refresh,
              label: 'Restart',
              onPressed: onRestart,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(icon, color: Colors.white, size: 20),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
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
      ],
    );
  }
}
