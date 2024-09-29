import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class GameOverScreen extends StatelessWidget {

  const GameOverScreen({super.key, required this.game});
    final FlappyBird game;
  static const String id ='gameOver';

  @override
  Widget build(BuildContext context) => Material(
  color: Colors.black38,
  child: Stack(
    children: [
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Score : ${game.bird.totalScore}',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontFamily: 'ThaleahFat',
              ),
            ),
            const SizedBox(height: 17),
            Stack(
              children: <Widget>[
                // Border text
                Text(
                  'Game Over',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'ThaleahFat',
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Colors.white,
                  ),
                ),
                // Solid text
                const Text(
                  'Game Over',
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.orange,
                    fontFamily: 'ThaleahFat',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: restart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Text(
                  'Restart',
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 10,
        left: 10,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back, 
            color: Colors.black38
            ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ],
  ),
);

  void restart() {
    game.bird.resetBirdPosition();
    game.bird.resetTotalScore();
    game.overlays.remove('gameOver');
    game.resumeEngine();
  }
}
