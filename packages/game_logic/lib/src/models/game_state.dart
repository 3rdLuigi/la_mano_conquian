import 'card.dart';
import 'deck.dart';
import 'player.dart';
import 'meld.dart';

enum GameStatus { playing, player1Wins, player2Wins, draw}

class GameState {
  final List<Player> players;
  final Deck deck;
  final List<Card> discardPile;
  final int currentPlayerIndex;
  final GameStatus status;
  final Card? drawnCard;

  GameState({
    required this.players,
    required this.deck,
    required this.discardPile,
    required this.currentPlayerIndex,
    this.status = GameStatus.playing,
    this.drawnCard,
  });
}