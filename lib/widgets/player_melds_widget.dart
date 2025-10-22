import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;
import 'card_widget.dart';

class PlayerMeldsWidget extends StatelessWidget {
  final List<game.Meld> melds;

  const PlayerMeldsWidget({super.key, required this.melds});

  @override
  Widget build(BuildContext context) {
    if (melds.isEmpty) {
      return const Center(
        child: Text(
          'No melds on table.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    // A Column to list all the melds
    return Column(
      children: melds.map((meld) {
        // Each meld is a Row of cards
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: meld.cards
                .map((card) => CardWidget(card: card))
                .toList(),
          ),
        );
      }).toList(),
    );
  }
}