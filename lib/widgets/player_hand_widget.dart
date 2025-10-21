import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;

import 'card_widget.dart';

class PlayerHandWidget extends StatelessWidget {
  final List<game.Card> hand;

  const PlayerHandWidget({super.key, required this.hand});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: hand
          .map((card) => CardWidget(card: card))
          .toList(),
    );
  }
}