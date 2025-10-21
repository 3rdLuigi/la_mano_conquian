import 'card.dart';
import 'deck.dart';
import 'player.dart';

enum GameStatus { playing, gameOver }

class GameState {
  final List<Player> players;
  final Deck deck;
  final List<Card> discardPile;
  final int currentPlayerIndex;
  final GameStatus status;

  GameState({
    required this.players,
    required this.deck,
    required this.discardPile,
    required this.currentPlayerIndex,
    this.status = GameStatus.playing,
  });
}