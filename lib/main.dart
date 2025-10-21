import 'package:flutter/material.dart';
import 'package:game_logic/game_logic.dart' as game;
import 'widgets/card_widget.dart';
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

  void _startNewGame() {
    setState(() {
      _gameController.startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current game state from the controller
    final gameState = _gameController.state;
    final player = (gameState != null) ? gameState.players[0] : null;

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
            Text(
              'Discard Pile:',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Center(
              // 4. This works because gameState.discardPile.last is a 'game.Card'
              child: CardWidget(card: gameState.discardPile.last),
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              'Your Hand (Player 1):',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // 5. This works because player.hand is a 'List<game.Card>'
            PlayerHandWidget(hand: player.hand),
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