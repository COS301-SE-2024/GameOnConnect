import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';
import 'package:gameonconnect/view/pages/flappy_bird/game_over_screen.dart';
import 'package:gameonconnect/view/pages/flappy_bird/start_game_screen.dart';

class GameScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final game = FlappyBird();
    return Scaffold(
      body: GameWidget(
        game: game,
        initialActiveOverlays: const [StartScreen.id],
        overlayBuilderMap: {
          'start' : (context,_)=> StartScreen(
            game: game,
          ),
          'gameOver' : (context,_)=> GameOverScreen(
            game: game,
          ),
        },

      ),
    );
  }
}