import 'card.dart';

enum MeldType { set, sequence }

class Meld {
  final List<Card> cards;
  final MeldType type;

  Meld({required this.cards, required this.type});

  @override
  String toString() {
    return '$type: ${cards.toString()}';
  }
}