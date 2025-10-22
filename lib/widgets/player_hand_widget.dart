import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;

import 'card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final List<game.Card> hand;
  final game.Card? selectedCard;
  final Function(game.Card card)? onCardTapped;

  const PlayerHandWidget({
    super.key, 
    required this.hand,
    this.selectedCard,
    this.onCardTapped,
    });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: hand
          .map((card) => CardWidget(
            card: card,
            isSelected: card == selectedCard,
            onTap: () => onCardTapped?.call(card),
            ))
          .toList(),
    );
  }
}