import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FlappyBird extends StatefulWidget {
  const FlappyBird({super.key});

  @override
  State<FlappyBird> createState() => _FlappyBirdState();
}

class _FlappyBirdState extends State<FlappyBird> {
  static double birdYAxis = 0;
  double initialPosition = birdYAxis;
  double height = 0;
  double time = 0;
  double gravity = -4.9;
  double velocity = 3.5;
  bool gameStarted = false;
  
  // Pipe properties
  static double pipeXOne = 1.5; // Starting position of the first pipe
  static double pipeXTwo = pipeXOne + 1.5; // Starting position of the second pipe
  double pipeWidth = 0.2; // Width of the pipes
  double pipeGap = 0.4; // Gap between the pipes
  
  // Randomize pipe heights
  Random random = Random();
  double pipeHeightOne = 0.6; // Initial height of the first pipe
  double pipeHeightTwo = 0.4; // Initial height of the second pipe

  void startGame() {
    gameStarted = true;
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      time += 0.05;
      height = gravity * time * time + velocity * time;
      setState(() {
        birdYAxis = initialPosition - height;
        pipeXOne -= 0.05;
        pipeXTwo -= 0.05;

        // Check if pipes are out of the screen, reset them
        if (pipeXOne < -1.5) {
          pipeXOne += 3;
          pipeHeightOne = random.nextDouble();
        }

        if (pipeXTwo < -1.5) {
          pipeXTwo += 3;
          pipeHeightTwo = random.nextDouble();
        }
      });

      if (birdYAxis > 1 || birdYAxis < -1 || checkCollision()) {
        timer.cancel();
        gameStarted = false;
        showGameOverDialog();
      }
    });
  }

  bool checkCollision() {
    // Check if bird collides with pipes
    if (pipeXOne < 0.25 && pipeXOne > -0.25) {
      if (birdYAxis < -1 + pipeHeightOne || birdYAxis > 1 - (pipeHeightOne + pipeGap)) {
        return true;
      }
    }

    if (pipeXTwo < 0.25 && pipeXTwo > -0.25) {
      if (birdYAxis < -1 + pipeHeightTwo || birdYAxis > 1 - (pipeHeightTwo + pipeGap)) {
        return true;
      }
    }

    return false;
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYAxis = 0;
      gameStarted = false;
      time = 0;
      initialPosition = birdYAxis;
      pipeXOne = 1.5;
      pipeXTwo = pipeXOne + 1.5;
      pipeHeightOne = 0.6;
      pipeHeightTwo = 0.4;
    });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPosition = birdYAxis;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.brown,
          title: Center(
            child: Text(
              'GAME OVER',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: resetGame,
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
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  AnimatedContainer(
                    alignment: Alignment(0, birdYAxis),
                    duration: Duration(milliseconds: 0),
                    color: Colors.blue,
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.yellow,
                    ),
                  ),
                  // First Pipe
                  AnimatedContainer(
                    alignment: Alignment(pipeXOne, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * pipeWidth,
                      height: MediaQuery.of(context).size.height * pipeHeightOne,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXOne, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * pipeWidth,
                      height: MediaQuery.of(context).size.height * (1 - pipeHeightOne - pipeGap),
                      color: Colors.green,
                    ),
                  ),
                  // Second Pipe
                  AnimatedContainer(
                    alignment: Alignment(pipeXTwo, 1.1),
                    duration: Duration(milliseconds: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * pipeWidth,
                      height: MediaQuery.of(context).size.height * pipeHeightTwo,
                      color: Colors.green,
                    ),
                  ),
                  AnimatedContainer(
                    alignment: Alignment(pipeXTwo, -1.1),
                    duration: Duration(milliseconds: 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * pipeWidth,
                      height: MediaQuery.of(context).size.height * (1 - pipeHeightTwo - pipeGap),
                      color: Colors.green,
                    ),
                  ),
                ],
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
