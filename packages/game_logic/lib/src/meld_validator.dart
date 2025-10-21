import 'models/card.dart';

class MeldValidator {
  /// Checks if a list of cards can form a valid meld (Set or Sequence).
  static bool isValidMeld(List<Card> cards) {
    if (cards.length < 3) return false;

    return _isSet(cards) || _isSequence(cards);
  }

  /// Checks if all cards have the same rank (e.g., three 4s).
  static bool _isSet(List<Card> cards) {
    final firstRank = cards[0].rank;
    return cards.every((card) => card.rank == firstRank);
  }

  /// Checks if all cards are the same suit and in sequence.
  static bool _isSequence(List<Card> cards) {
    final firstSuit = cards[0].suit;
    // 1. Check if all cards have the same suit.
    if (!cards.every((card) => card.suit == firstSuit)) {
      return false;
    }

    // 2. Get the master list of all ranks in order.
    const allRanks = Rank.values; // [ace, two, ..., seven, jack, knight, king]

    // 3. Sort the input cards based on their rank's position in the master list.
    final sortedCards = List<Card>.from(cards)
      ..sort((a, b) => a.rank.index.compareTo(b.rank.index));

    // 4. Check if they are sequential.
    for (int i = 0; i < sortedCards.length - 1; i++) {
      final currentRankIndex = sortedCards[i].rank.index;
      final nextRankIndex = sortedCards[i + 1].rank.index;

      // Check if the next card's rank is NOT one step above the current one.
      // This correctly handles 7 (index 6) and Jack (index 7).
      if (nextRankIndex != currentRankIndex + 1) {
        return false;
      }
    }

    // 5. If we get here, it's a valid sequence.
    return true;
  }
}