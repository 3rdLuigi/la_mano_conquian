// Import all the models directly
import 'models/card.dart';
import 'models/deck.dart';
import 'models/game_state.dart';
import 'models/player.dart';
import 'models/meld.dart';
import 'meld_validator.dart';

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

    if (deck.cards.isEmpty) {
      print("Deck is empty! Checking for draw...");
      // For now, a simple check: if the deck is empty, it's a draw.
      _gameState = GameState(
        players: currentState.players,
        deck: currentState.deck,
        discardPile: currentState.discardPile,
        currentPlayerIndex: currentState.currentPlayerIndex,
        status: GameStatus.draw, // Set draw status
      );
      print("GAME IS A DRAW.");
      return; // Stop the function
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
  
  bool meldCards(List<Card> cardsToMeld) {
    if (_gameState == null) return false;

    //Use the validator you already built!
    if (!MeldValidator.isValidMeld(cardsToMeld)) {
      return false; // Not a valid
    }

    final currentState = _gameState!;
    final player = currentState.players[currentState.currentPlayerIndex];
    
    // Determine the meld type
    // A simple (but not 100% perfect) check:
    // If all ranks are the same, it's a set. Otherwise, it's a sequence.
    final type =
        cardsToMeld.every((card) => card.rank == cardsToMeld[0].rank)
            ? MeldType.set
            : MeldType.sequence;

    final newMeld = Meld(cards: List<Card>.from(cardsToMeld), type: type);
    
    // Move cards from hand to melds
    for (var card in newMeld.cards) {
      player.hand.remove(card);
    }
    player.melds.add(newMeld);
    
    print("Player ${player.id} melded: $newMeld");

    if(_checkForWin()) {
      return true; //Game Over
    }
    //Create new game state
    _gameState = GameState(
      players: currentState.players,
      deck: currentState.deck,
      discardPile: currentState.discardPile,
      currentPlayerIndex: currentState.currentPlayerIndex,
      status: currentState.status,
    );
    
    return true;
  }

  bool drawFromDiscardAndMeld(List<Card> selectedHandCards) {
    if (_gameState == null) return false;
    if (selectedHandCards.length < 2) return false; // Must use 2+ hand cards

    final currentState = _gameState!;
    final player = currentState.players[currentState.currentPlayerIndex];
    final discardPile = currentState.discardPile;

    if (discardPile.isEmpty) return false; // Can't draw from empty pile

    //Get the card to draw
    final cardToDraw = discardPile.last;

    //Create the potential meld
    final potentialMeldCards = List<Card>.from(selectedHandCards);
    potentialMeldCards.add(cardToDraw);

    //Use your validator to check if it's a valid meld
    if (!MeldValidator.isValidMeld(potentialMeldCards)) {
      print("Invalid meld with discard card.");
      return false; // Not a valid meld
    }

    //If Valid, actually move the cards.
    final card = discardPile.removeLast(); // Take card from discard
    
    //Create the new meld (using the same logic as meldCards)
    final type =
        potentialMeldCards.every((c) => c.rank == potentialMeldCards[0].rank)
            ? MeldType.set
            : MeldType.sequence;
    
    final newMeld = Meld(
      cards: potentialMeldCards, // This is a new list, so it's safe
      type: type,
    );

    //Move cards from hand to melds
    for (var card in selectedHandCards) {
      player.hand.remove(card);
    }
    player.melds.add(newMeld);

    print("Player ${player.id} melded from discard: $newMeld");

    if(_checkForWin()) {
      return true; //Game Over
    }

    _gameState = GameState(
      players: currentState.players,
      deck: currentState.deck,
      discardPile: discardPile,
      currentPlayerIndex: currentState.currentPlayerIndex,
      status: currentState.status,
    );

    return true;
  }

    bool _checkForWin() {
    if (_gameState == null) return false;

      final currentState = _gameState!;
      final player = currentState.players[currentState.currentPlayerIndex];

      //Calculate total melded cards
      int totalMeldedCards = 0;
      for (var meld in player.melds) {
        totalMeldedCards += meld.cards.length;
      }

      //Check for win condition (11 cards)
      if (totalMeldedCards == 11) {
        print("PLAYER ${player.id} WINS!");

        //Create new game state with the win status
        _gameState = GameState(
          players: currentState.players,
          deck: currentState.deck,
          discardPile: currentState.discardPile,
          currentPlayerIndex: currentState.currentPlayerIndex,
          // Set the correct win status!
          status: currentState.currentPlayerIndex == 0
              ? GameStatus.player1Wins
              : GameStatus.player2Wins,
        );
        return true; // The game is over
      }

      return false; // The game continues
    }
  
}