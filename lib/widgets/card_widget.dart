import 'package:flutter/material.dart';
// 1. Import your game logic with a prefix 'game'
import 'package:game_logic/game_logic.dart' as game;

class CardWidget extends StatelessWidget {
  // 2. Use the prefixed 'game.Card'
  final game.Card card;
  
  const CardWidget({super.key, required this.card});

  // A helper function to get a simple string for the rank
  String _getRankString() {
    // 3. Use the prefixed 'game.Rank'
    switch (card.rank) {
      case game.Rank.ace: return 'A';
      case game.Rank.two: return '2';
      case game.Rank.three: return '3';
      case game.Rank.four: return '4';
      case game.Rank.five: return '5';
      case game.Rank.six: return '6';
      case game.Rank.seven: return '7';
      case game.Rank.jack: return 'J';
      case game.Rank.knight: return 'K';
      case game.Rank.king: return 'Q';
      default: return '?';
    }
  }
  
  // A helper function to get an emoji for the suit
  String _getSuitString() {
    // 5. Use the prefixed 'game.Suit'
    switch (card.suit) {
      case game.Suit.oros: return '🪙'; // Gold
      case game.Suit.copas: return '🍷'; // Cups
      case game.Suit.espadas: return '🗡️'; // Swords
      case game.Suit.bastos: return '🌿'; // Clubs
      default: return '?';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 90,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black54, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Center(
        child: Column(
          // 7. 'mainAxisAlignment' now lives INSIDE the Column
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _getRankString(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getSuitString(),
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}