import 'card.dart';
import 'meld.dart';

class Player {
  final String id;
  final List<Card> hand = [];
  final List<Meld> melds = [];

  Player({required this.id});

  @override
  String toString() {
    return 'Player($id) Hand: ${hand.toString()} Melds: ${melds.toString()}';
  }
}