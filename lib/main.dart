import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;
import 'widgets/card_widget.dart';
import 'widgets/deck_widget.dart';
import 'widgets/player_hand_widget.dart';
import 'widgets/player_melds_widget.dart';
import 'widgets/game_over_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'La Mano: Conquian',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'La Mano: Conquian'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final game.GameController _gameController = game.GameController();

  final List<game.Card> _selectedCards = [];

  void _startNewGame() {
    setState(() {
      _gameController.startNewGame();
      _selectedCards.clear();
    });
  }

  void _drawFromDeck() {
    setState(() {
      _gameController.drawFromDeck();
    });
  }

  void _onCardTapped(game.Card card) {
    setState(() {
      // If tapping the same card, deselect it. Otherwise, select the new card.
      if (_selectedCards.contains(card)) {
        _selectedCards.remove(card);
      } else {
        _selectedCards.add(card);
      }
    });
  }

  void _discardSelectedCard() {
    if (_selectedCards.length != 1) return;

    setState(() {
      _gameController.discardCard(_selectedCards.first);
      _selectedCards.clear(); // Clear selection after discarding
    });
  }

  void _meldSelectedCards() {
    if (_selectedCards.isEmpty) return;

    setState(() {
      // We will add the logic to _gameController next
      // For now, it just prints and clears
      bool success = _gameController.meldCards(_selectedCards);
      
      if (success) {
        _selectedCards.clear();
      } else {
        // You could show an error snackbar here
        print("Meld failed: Not a valid meld.");
      }
    });
  }

  void _drawFromDiscard() {
    // Must have at least 2 cards selected to try this
    if (_selectedCards.length < 2) {
      print("You must select at least 2 hand cards to meld with discard.");
      return;
    }

    setState(() {
      bool success = _gameController.drawFromDiscardAndMeld(_selectedCards);
      
      if (success) {
        _selectedCards.clear();
      } else {
        print("Meld failed: Not a valid meld with the discard card.");
        // You could show an error snackbar here
      }
    });
  }

@override
  Widget build(BuildContext context) {
    final gameState = _gameController.state;
    // Get the current player based off of the index
    final player1 = (gameState != null) ? gameState.players[0] : null;
    final player2 = (gameState != null) ? gameState.players[1] : null;

    final currentPlayerHand = (gameState != null)
        ? gameState.players[gameState.currentPlayerIndex].hand
        : <game.Card>[];

    final bool isGameOver =
      gameState?.status != null && gameState?.status != game.GameStatus.playing;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: isGameOver,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                if (gameState == null)
                  const Center(
                    child: Text('Press the button to start a new game!'),
                  ),
                if (gameState != null && player1 != null && player2 != null) ...[
                  // --- Deck and Discard Pile ---
                  // Use a Row to show them side-by-side
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // --- The Deck ---
                      Column(
                        children: [
                          Text(
                            'Deck:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          DeckWidget(
                            cardCount: gameState.deck.cards.length,
                            onTap: _selectedCards.isEmpty ? _drawFromDeck : null, // Call our new method!
                          ),
                        ],
                      ),
                      // --- The Discard Pile ---
                      Column(
                        children: [
                          Text(
                            'Discard Pile:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          if(gameState.discardPile.isNotEmpty)
                            CardWidget(
                              card: gameState.discardPile.last,
                              onTap: _selectedCards.length >= 2 ?
                                _drawFromDiscard : null,
                              isSelected: _selectedCards.length >= 2,
                            )
                            else
                            Container(
                              width: 60,
                              height: 90,
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Empty',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  // --- Player's Melds ---
                  Text(
                    "Player 1's Melds:",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  PlayerMeldsWidget(melds: player1.melds),
                  const SizedBox(height: 16),
                  Text(
                    "Player 2's Melds:",
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  PlayerMeldsWidget(melds: player2.melds),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // === Player's Hand ===
                  Text(
                    'Your Hand (Player ${gameState.currentPlayerIndex + 1}):',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),const SizedBox(height: 8),

                  // Show Meld/Discard buttons in a Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // MELD BUTTON
                      if (_selectedCards.length >= 3)
                        ElevatedButton.icon(
                          onPressed: _meldSelectedCards,
                          icon: const Icon(Icons.style),
                          label: const Text('Meld'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      
                      // DISCARD BUTTON
                      if (_selectedCards.length == 1)
                        ElevatedButton.icon(
                          onPressed: _discardSelectedCard,
                          icon: const Icon(Icons.vertical_align_bottom),
                          label: Text('Discard ${_selectedCards.first}'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // --- PlayerHandWidget ---
                  PlayerHandWidget(
                    hand: currentPlayerHand,
                    selectedCards: _selectedCards, // Pass the list
                    onCardTapped: _onCardTapped,
                  ),
                ],
              ],
            ),
          ),
          if (isGameOver && gameState != null)
            GameOverWidget(
              status: gameState.status,
              onNewGame: _startNewGame, // Pass the restart function!
            ),
        ],
      ),
      floatingActionButton: isGameOver
        ? null
        : FloatingActionButton(
          onPressed: _startNewGame,
          tooltip: 'New Game',
          child: const Icon(Icons.play_arrow),
        ),
    );
  }
}