// Enums are great for defining a fixed set of values
enum Suit { oros, copas, espadas, bastos } // Gold, Cups, Swords, Clubs
enum Rank { ace, two, three, four, five, six, seven, jack, knight, king }

class Card {
  final Suit suit;
  final Rank rank;

  Card(this.suit, this.rank);

  @override
  String toString() {
    // Helpful for debugging!
    return '${rank.name} of ${suit.name}';
  }
}