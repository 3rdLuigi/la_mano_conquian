import 'package:game_logic/game_logic.dart';
import 'package:test/test.dart';

void main() {
  group('MeldValidator', () {
    test('Valid set of 3', () {
      final meld = [
        Card(Suit.oros, Rank.four),
        Card(Suit.copas, Rank.four),
        Card(Suit.espadas, Rank.four),
      ];
      expect(MeldValidator.isValidMeld(meld), isTrue);
    });

    test('Valid sequence of 3', () {
      final meld = [
        Card(Suit.bastos, Rank.four),
        Card(Suit.bastos, Rank.five),
        Card(Suit.bastos, Rank.six),
      ];
      expect(MeldValidator.isValidMeld(meld), isTrue);
    });

    test('Valid sequence over 7-Jack', () {
      final meld = [
        Card(Suit.copas, Rank.six),
        Card(Suit.copas, Rank.seven),
        Card(Suit.copas, Rank.jack),
      ];
      expect(MeldValidator.isValidMeld(meld), isTrue);
    });

    test('Invalid: Too few cards', () {
      final meld = [
        Card(Suit.oros, Rank.ace),
        Card(Suit.oros, Rank.two),
      ];
      expect(MeldValidator.isValidMeld(meld), isFalse);
    });

    test('Invalid sequence: Mixed suits', () {
      final meld = [
        Card(Suit.oros, Rank.four),
        Card(Suit.copas, Rank.five),
        Card(Suit.espadas, Rank.six),
      ];
      expect(MeldValidator.isValidMeld(meld), isFalse);
    });

    test('Invalid sequence: Gap in ranks', () {
      final meld = [
        Card(Suit.bastos, Rank.four),
        Card(Suit.bastos, Rank.five),
        Card(Suit.bastos, Rank.seven),
      ];
      expect(MeldValidator.isValidMeld(meld), isFalse);
    });

    test('Invalid sequence: Wrap-around Ace', () {
      final meld = [
        Card(Suit.oros, Rank.king),
        Card(Suit.oros, Rank.ace),
        Card(Suit.oros, Rank.two),
      ];
      expect(MeldValidator.isValidMeld(meld), isFalse);
    });
  });
}