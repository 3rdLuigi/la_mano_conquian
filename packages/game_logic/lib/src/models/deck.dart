import 'card.dart';

class Deck {
  final List<Card> _cards = [];

  Deck() {
    // Create a standard 40-card Spanish deck
    for (var suit in Suit.values) {
      for (var rank in Rank.values) {
        _cards.add(Card(suit, rank));
      }
    }
  }

  // A public getter to see the cards without being able to modify the list
  List<Card> get cards => _cards;

  void shuffle() {
    _cards.shuffle();
  }

  @override
  String toString() {
    return _cards.toString();
  }
}