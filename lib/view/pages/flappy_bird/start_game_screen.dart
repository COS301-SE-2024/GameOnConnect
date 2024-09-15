import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class StartScreen extends StatelessWidget {
  
  const StartScreen({
    super.key,
    required this.game,
  });

  final FlappyBird game;
  static const String id = 'start';

  @override
  Widget build(BuildContext context) {
    game.pauseEngine();

    return Scaffold(
      body:GestureDetector(
        onTap: () {
          game.overlays.remove('start');
          game.resumeEngine();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/menu.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Image.asset('assets/images/message.png'),
        ),
      ),
    );
  }
}
