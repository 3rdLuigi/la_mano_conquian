// Import all the models directly
import 'models/card.dart';
import 'models/deck.dart';
import 'models/game_state.dart';
import 'models/player.dart';

class GameController {
  GameState? _gameState;
  GameState? get state => _gameState;

  void startNewGame() {
    //Create players
    final player1 = Player(id: 'player_1');
    final player2 = Player(id: 'player_2');
    final players = [player1, player2];

    //Create and shuffle the deck
    final deck = Deck();
    deck.shuffle();

    //Deal 10 cards to each player
    for (int i = 0; i < 10; i++) {
      player1.hand.add(deck.cards.removeLast());
      player2.hand.add(deck.cards.removeLast());
    }

    //Create the discard pile by flipping one card from the deck
    final discardPile = <Card>[];
    discardPile.add(deck.cards.removeLast());

    //Set the initial GameState
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

  void drawFromDeck() {
    //Make sure the game has started
    if (_gameState == null) return;

    //Get the current state
    final currentState = _gameState!;
    final deck = currentState.deck;

    //Make sure the deck isn't empty
    if (deck.cards.isEmpty) {
      print("Deck is empty!");
      return;
    }

    //Get the current player
    final player = currentState.players[currentState.currentPlayerIndex];

    //Take a card from the deck and add it to the player's hand
    final drawnCard = deck.cards.removeLast();
    player.hand.add(drawnCard);

    print("Player ${player.id} drew: $drawnCard");

    //Create a NEW GameState with the updated info (no prefix)
    _gameState = GameState(
      players: currentState.players, // This list now contains the modified player
      deck: deck, // This is the modified deck
      discardPile: currentState.discardPile,
      currentPlayerIndex: currentState.currentPlayerIndex,
      status: currentState.status,
    );
  }

  void discardCard(Card cardToDiscard) {
    if (_gameState == null) return;

    final currentState = _gameState!;
    final player = currentState.players[currentState.currentPlayerIndex];
    final discardPile = currentState.discardPile;

    //Remove the card from the player's hand.
    bool removed = player.hand.remove(cardToDiscard);

    //Safety check: Make sure the card was actually in the hand
    if (!removed) {
      print("Error: Tried to discard a card not in hand.");
      return;
    }

    //Add the card to the top of the discard pile.
    discardPile.add(cardToDiscard);

    //It's the next player's turn!
    //This simple logic works for 2 players.
    final nextPlayerIndex = (currentState.currentPlayerIndex + 1) % currentState.players.length;

    print("Player ${player.id} discarded: $cardToDiscard");
    print("--- It is now Player ${currentState.players[nextPlayerIndex].id}'s turn ---");

    //Create the new game state
    _gameState = GameState(
      players: currentState.players,
      deck: currentState.deck,
      discardPile: discardPile,
      currentPlayerIndex: nextPlayerIndex, //Update the current player
      status: currentState.status,
    );
  }
}