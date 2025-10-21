import 'package:game_logic/game_logic.dart';
import 'package:test/test.dart';

void main() {
  group('Deck', () {
    test('A new deck should have 40 cards', () {
      final deck = Deck();
      expect(deck.cards.length, 40);
    });

    test('Shuffling should change the order of cards', () {
      final deck1 = Deck();
      final deck2 = Deck();
      
      // Convert card list to string to compare them
      final initialOrder = deck1.cards.toString();

      deck2.shuffle();
      final shuffledOrder = deck2.cards.toString();

      // It's technically possible for a shuffle to result in the same order,
      // but it's extremely unlikely with 40 cards. This test is good enough.
      expect(initialOrder, isNot(equals(shuffledOrder)));
    });
  });
}