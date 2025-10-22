import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;

class CardWidget extends StatelessWidget {
  final game.Card card;
  final bool isSelected;
  final VoidCallback? onTap;

  const CardWidget({
    super.key, 
    required this.card,
    this.isSelected = false,
    this.onTap,
    });

  String _getRankString() {
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
  
  String _getSuitString() {
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 90,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          // Change border color if selected!
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.black54,
            width: isSelected ? 3 : 1, // Thicker border if selected
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blue.withOpacity(0.3)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Column(
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
      ),
    );
  }
}