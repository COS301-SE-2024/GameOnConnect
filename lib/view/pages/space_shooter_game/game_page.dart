import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/view/pages/space_shooter_game/space_shooter_game.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget<SpaceShooterGame>(
      game: SpaceShooterGame(),
      overlayBuilderMap: {
        'quitButton': (BuildContext context, SpaceShooterGame game) {
          return Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pop(context); // This will exit the game and return to the previous screen
              },
            ),
          );
        },
        'gameOver': (BuildContext context, SpaceShooterGame game) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Text(
                    'Game Over',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the home page
                  },
                  child: const Text('Go to Home'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('gameOver'); // Remove the game over overlay
                    game.reset(); // Restart the game by resetting its state
                  },
                  child: const Text('Restart Game'),
                ),
                const SizedBox(height: 20),
                // const ScoreOverlay(isGameOver: true),
              ],
            )
          );
        },
        'scoreOverlay': (BuildContext context, SpaceShooterGame game) {
          // Show score during the game
          return const Positioned(
            top: 20, // Initial position at the top when the game is not over
            left: 20,
            child: ScoreOverlay(isGameOver: false),
          );
        },
      },
      initialActiveOverlays: const ['quitButton', 'scoreOverlay'], // Display the quit button when the game starts
    );
  }
}

class ScoreOverlay extends StatelessWidget {
  final bool isGameOver;

  const ScoreOverlay({super.key, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    final game = context.findAncestorWidgetOfExactType<GameWidget<SpaceShooterGame>>()?.game;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(milliseconds: 100))
          .asyncMap((_) => game?.score ?? 0),
      builder: (context, snapshot) {
        return Center(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 3), // Border color
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Score: ${snapshot.data ?? 0}',
              style: TextStyle(
                color: primaryColor,  // Text color
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        );
      },
    );
  }
}
