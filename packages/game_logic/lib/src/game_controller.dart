import 'models/card.dart';
import 'models/deck.dart';
import 'models/game_state.dart';
import 'models/player.dart';

class GameController {
  GameState? _gameState;
  GameState? get state => _gameState;

  void startNewGame() {
    // 1. Create players
    final player1 = Player(id: 'player_1');
    final player2 = Player(id: 'player_2');
    final players = [player1, player2];

    // 2. Create and shuffle the deck
    final deck = Deck();
    deck.shuffle();

    // 3. Deal 10 cards to each player
    for (int i = 0; i < 10; i++) {
      player1.hand.add(deck.cards.removeLast());
      player2.hand.add(deck.cards.removeLast());
    }

    // 4. Create the discard pile by flipping one card from the deck
    final discardPile = <Card>[];
    discardPile.add(deck.cards.removeLast());

    // 5. Set the initial GameState
    _gameState = GameState(
      players: players,
      deck: deck,
      discardPile: discardPile,
      currentPlayerIndex: 0, // Player 1 starts
    );
    
    print("--- NEW GAME STARTED ---");
    print("Player 1 Hand: ${player1.hand}");
    print("Player 2 Hand: ${player2.hand}");
    print("Discard Pile Top: ${discardPile.last}");
    print("Cards left in deck: ${deck.cards.length}");
  }
}