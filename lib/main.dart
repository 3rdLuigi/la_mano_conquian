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

  final List<game.Card> _selectedHandCards = [];
  game.Card? _selectedDiscardCard;

  void _startNewGame() {
    setState(() {
      _gameController.startNewGame();
      _selectedHandCards.clear();
      _selectedDiscardCard = null;
    });
  }

  void _drawFromDeck() {
    setState(() {
      _gameController.drawFromDeck();
    });
  }

  void _onHandCardTapped(game.Card card) {
    setState(() {
      if (_selectedHandCards.contains(card)) {
        _selectedHandCards.remove(card);
      } else {
        _selectedHandCards.add(card);
      }
    });
  }

  void _onDiscardTapped() {
    final gameState = _gameController.state;
    if (gameState == null || gameState.discardPile.isEmpty) return;

    setState(() {
      if (_selectedDiscardCard == gameState.discardPile.last) {
        _selectedDiscardCard = null;
      } else {
        _selectedDiscardCard = gameState.discardPile.last;
      }
    });
  }

  void _discardSelectedCard() {
    if (_selectedHandCards.length != 1 || _selectedDiscardCard != null) return;
    setState(() {
      _gameController.discardCard(_selectedHandCards.first);
      _selectedHandCards.clear();
    });
  }

  void _onMeldPressed() {
    if (_gameController.state == null) return;

    // Case 1: Meld from discard
    if (_selectedDiscardCard != null && _selectedHandCards.length >= 2) {
      setState(() {
        bool success =
            _gameController.drawFromDiscardAndMeld(_selectedHandCards);
        if (success) {
          _selectedHandCards.clear();
          _selectedDiscardCard = null;
        } else {
          print("Meld failed: Not a valid meld with the discard card.");
        }
      });
    }
    // Case 2: Meld from hand
    else if (_selectedDiscardCard == null && _selectedHandCards.length >= 3) {
      setState(() {
        bool success = _gameController.meldCards(_selectedHandCards);
        if (success) {
          _selectedHandCards.clear();
          _selectedDiscardCard = null;
        } else {
          print("Meld failed: Not a valid meld.");
        }
      });
    }
  }

  // === 1. ADD NEW METHOD for discarding the drawn card ===
  void _discardDrawnCard() {
    setState(() {
      _gameController.discardDrawnCard();
      _selectedHandCards.clear(); // Clear selection just in case
    });
  }

  // === 2. ADD NEW METHOD for melding with the drawn card ===
  void _meldWithDrawnCard() {
    if (_selectedHandCards.length < 2) return;
    setState(() {
      bool success = _gameController.meldWithDrawnCard(_selectedHandCards);
      if (success) {
        _selectedHandCards.clear();
      } else {
        print("Meld failed: Not a valid meld with the drawn card.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameState = _gameController.state;
    final player1 = (gameState != null) ? gameState.players[0] : null;
    final player2 = (gameState != null) ? gameState.players[1] : null;
    final currentPlayerHand = (gameState != null)
        ? gameState.players[gameState.currentPlayerIndex].hand
        : <game.Card>[];

    final bool isGameOver =
        gameState != null && gameState.status != game.GameStatus.playing;

    // === 3. GET THE NEW DRAWN CARD STATE ===
    final game.Card? drawnCard = gameState?.drawnCard;

    // (Action visibility logic is now inside the new UI)

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
                  // === 4. NEW UI: "DRAWN CARD" MODE ===
                  // This UI shows ONLY if a card has been drawn from the deck
                  if (drawnCard != null) ...[
                    Text(
                      'Card Drawn',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: CardWidget(card: drawnCard),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You must use this card or discard it.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // --- New Action Buttons ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Meld Button
                        ElevatedButton.icon(
                          // Only enabled if 2+ hand cards are selected
                          onPressed: _selectedHandCards.length >= 2
                              ? _meldWithDrawnCard
                              : null,
                          icon: const Icon(Icons.style),
                          label: const Text('Meld with Hand'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[400],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        // Discard Button
                        ElevatedButton.icon(
                          onPressed: _discardDrawnCard,
                          icon: const Icon(Icons.vertical_align_bottom),
                          label: const Text('Discard Card'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 24),

                    // --- Show hand to allow selection ---
                    Text(
                      'Your Hand (Player ${gameState.currentPlayerIndex + 1}):',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    PlayerHandWidget(
                      hand: currentPlayerHand,
                      selectedCards: _selectedHandCards,
                      onCardTapped: _onHandCardTapped,
                    ),
                  ]

                  // === 5. OLD UI: "NORMAL TURN" MODE ===
                  // This UI shows ONLY if no card is being held
                  else ...[
                    // --- Deck and Discard Pile ---
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
                              onTap: _selectedHandCards.isEmpty &&
                                      _selectedDiscardCard == null
                                  ? _drawFromDeck
                                  : null,
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
                            if (gameState.discardPile.isNotEmpty)
                              CardWidget(
                                card: gameState.discardPile.last,
                                onTap: _onDiscardTapped,
                                isSelected: _selectedDiscardCard ==
                                    gameState.discardPile.last,
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
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.black54),
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

                    // --- Player's Hand ---
                    Text(
                      'Your Hand (Player ${gameState.currentPlayerIndex + 1}):',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),

                    // --- Old Action Buttons ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // MELD BUTTON
                        if ((_selectedHandCards.length >= 3 &&
                                _selectedDiscardCard == null) ||
                            (_selectedHandCards.length >= 2 &&
                                _selectedDiscardCard != null))
                          ElevatedButton.icon(
                            onPressed: _onMeldPressed,
                            icon: const Icon(Icons.style),
                            label: const Text('Meld'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[400],
                              foregroundColor: Colors.white,
                            ),
                          ),
                        // DISCARD BUTTON
                        if (_selectedHandCards.length == 1 &&
                            _selectedDiscardCard == null)
                          ElevatedButton.icon(
                            onPressed: _discardSelectedCard,
                            icon: const Icon(Icons.vertical_align_bottom),
                            label: Text('Discard ${_selectedHandCards.first}'),
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
                      selectedCards: _selectedHandCards,
                      onCardTapped: _onHandCardTapped,
                    ),
                  ],
                ],
              ],
            ),
          ),
          // --- Game Over Overlay (Unchanged) ---
          if (isGameOver && gameState != null)
            GameOverWidget(
              status: gameState.status,
              onNewGame: _startNewGame,
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