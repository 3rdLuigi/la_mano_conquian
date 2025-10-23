import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;

class GameOverWidget extends StatelessWidget {
  final game.GameStatus status;
  final VoidCallback onNewGame; // Function to call when "New Game" is pressed

  const GameOverWidget({
    super.key,
    required this.status,
    required this.onNewGame,
  });

  // Helper to get the correct message
  String _getMessage() {
    switch (status) {
      case game.GameStatus.player1Wins:
        return 'Player 1 Wins!';
      case game.GameStatus.player2Wins:
        return 'Player 2 Wins!';
      case game.GameStatus.draw:
        return 'It\'s a Draw!';
      case game.GameStatus.playing:
      default:
        return ''; // Should not happen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // Cover the whole screen with a semi-transparent black
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getMessage(),
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: onNewGame,
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                textStyle: const TextStyle(fontSize: 24),
              ),
              child: const Text('New Game'),
            ),
          ],
        ),
      ),
    );
  }
}