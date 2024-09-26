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
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              game.overlays.remove('start');
              game.resumeEngine();
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/ice-background.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/3-birds.png'),
                    const SizedBox(height: 20),
                    Image.asset('assets/images/message.png'),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back, 
                color: Colors.orange),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
