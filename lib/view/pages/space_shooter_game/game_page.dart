import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/view/pages/space_shooter_game/space_shooter_game.dart';

class GamePage extends StatelessWidget {
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
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Game Over',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      // decorationColor: Theme.of(context).colorScheme.secondary,
                      // decorationThickness: 2.0,
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Navigate back to the home page
                  },
                  child: Text('Go to Home'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('gameOver'); // Remove the game over overlay
                    game.reset(); // Restart the game by resetting its state
                  },
                  child: const Text('Restart Game'),
                ),
              ],
            )
          );
        },
      },
      initialActiveOverlays: const ['quitButton'], // Display the quit button when the game starts
    );
  }
}
