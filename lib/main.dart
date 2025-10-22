import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;
import 'widgets/card_widget.dart';
import 'widgets/deck_widget.dart';
import 'widgets/player_hand_widget.dart';

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

  game.Card? _selectedCard;

  void _startNewGame() {
    setState(() {
      _gameController.startNewGame();
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
      if (_selectedCard == card) {
        _selectedCard = null;
      } else {
        _selectedCard = card;
      }
    });
  }

  void _discardSelectedCard() {
    if (_selectedCard == null) return;

    setState(() {
      _gameController.discardCard(_selectedCard!);
      _selectedCard = null; // Clear selection after discarding
    });
  }

@override
  Widget build(BuildContext context) {
    final gameState = _gameController.state;
    // Get the current player based off of the index
    final player = (gameState != null)
        ? gameState.players[gameState.currentPlayerIndex]
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          if (gameState == null)
            const Center(
              child: Text('Press the button to start a new game!'),
            ),

          if (gameState != null && player != null) ...[
            // === Deck and Discard Pile ===
            // We use a Row to show them side-by-side
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
                      onTap: _drawFromDeck, // Call our new method!
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
                    CardWidget(card: gameState.discardPile.last),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),

            // === Player's Hand ===
            Text(
              'Your Hand (Player ${gameState.currentPlayerIndex + 1}):',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            if (_selectedCard != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: _discardSelectedCard,
                  icon: const Icon(Icons.vertical_align_bottom),
                  label: Text('Discard $_selectedCard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            PlayerHandWidget(hand: player.hand, selectedCard: _selectedCard, onCardTapped: _onCardTapped),
          ],
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewGame,
        tooltip: 'New Game',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}