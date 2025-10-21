import 'card.dart';

class Player {
  final String id;
  final List<Card> hand = [];

  Player({required this.id});

  @override
  String toString() {
    return 'Player($id) Hand: ${hand.toString()}';
  }
}