import 'dart:async';
import 'package:flutter/material.dart';

class FlappyBird extends StatefulWidget {
  const FlappyBird({super.key});

  @override
  State<FlappyBird> createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {
  static double yAxis = 0;
  double startPosition = yAxis;
  double height = 0;
  double time = 0;
  bool started = false;
  double velocity = 3.5; // jump strength
  double gravity = -4.9; // gravity

  void start() {
    started = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      height = gravity * time * time + velocity * time;

      setState(() {
        yAxis = startPosition - height;
      });

      if (isDead()) {
        timer.cancel();
        started = false;
        dialog();
      }

      time += 0.05; // Increment time
    });
  }

  bool isDead() {
    // Bird is dead if it goes above or below the screen
    if (yAxis < -1 || yAxis > 1) {
      return true;
    }
    return false;
  }

  void jump() {
    setState(() {
      time = 0;
      startPosition = yAxis;
    });
  }

  void reset() {
    Navigator.pop(context);
    setState(() {
      yAxis = 0;
      started = false;
      time = 0;
      startPosition = yAxis;
    });
  }

  void dialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'GAME OVER',
            ),
          ),
          actions: [
            GestureDetector(
              onTap: reset,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.white,
                  child: Text(
                    'PLAY AGAIN',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.brown),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: started ? jump : start,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://github.com/HeyFlutter-Public/flappy_bird_game/blob/main/assets/images/background.png?raw=true'),
                fit: BoxFit.cover,
              ),
            ),
                //color: Colors.blue,
                child: AnimatedContainer(
                  alignment: Alignment(0, yAxis),
                  duration: Duration(milliseconds: 0),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.yellow,
                     /*decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/your_image.png'), // or NetworkImage('https://toppng.com/public/uploads/preview/flappy-bird-sprite-11549936843rfq2kg39db.png')
                fit: BoxFit.cover,
              ),
            ),*/
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.brown,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
