import 'package:flutter/material.dart';
// Import your game logic package!
import 'package:game_logic/game_logic.dart';

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
  // Create an instance of your game controller
  final GameController _gameController = GameController();
  
  void _startNewGame() {
    setState(() {
      // Calling setState will make sure the UI rebuilds after the state changes
      _gameController.startNewGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the current game state from the controller
    final gameState = _gameController.state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Show a message if the game hasn't started yet
            if (gameState == null)
              const Text('Press the button to start a new game!'),

            // If the game has started, display some info
            if (gameState != null) ...[
              Text(
                'Top of Discard Pile:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '${gameState.discardPile.last}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Text(
                'Player 1 has ${gameState.players[0].hand.length} cards.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startNewGame,
        tooltip: 'New Game',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}