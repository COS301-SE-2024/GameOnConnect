import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class GameOverScreen extends StatelessWidget {

  const GameOverScreen({Key? key, required this.game}) : super(key: key);
    final FlappyBird game;
  static const String id ='gameOver';

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.black38,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Score : ${game.bird.totalScore}',
                style: const TextStyle(
                  fontSize: 60,
                  color: Colors.white,
                  fontFamily: 'Game',
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/images/gameover.png'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: restart,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text(
                  'Restart',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white
                    ),
                ),
              ),
            ],
          ),
        ),
      );

  void restart() {
    game.bird.resetBirdPosition();
    game.bird.resetTotalScore();
    game.overlays.remove('gameOver');
    game.resumeEngine();
  }
}
