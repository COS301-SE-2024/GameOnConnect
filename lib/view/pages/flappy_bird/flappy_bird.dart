import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/view/components/flappy_bird/background.dart';
import 'package:gameonconnect/view/components/flappy_bird/bird.dart';
import 'package:gameonconnect/view/components/flappy_bird/floor.dart';
import 'package:gameonconnect/view/components/flappy_bird/pipe_combination.dart';
import 'package:gameonconnect/view/components/flappy_bird/seed.dart';

class FlappyBird extends FlameGame with TapDetector,HasCollisionDetection{


  late Bird bird;
  Timer pipetimeInverval= Timer(1.5 , repeat:true);
  Timer seedTimer = Timer(3.0, repeat: true); // Timer to spawn seeds
  bool collision=false;
  late TextComponent score;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Floor(),
      bird = Bird(),
      score = displayScore(),
    ]);

    
    pipetimeInverval.onTick = () => add(PipeCombination());
    seedTimer.onTick = () => add(Seed()); // Add seeds periodically
  }

   @override
  void update(double dt) {
    super.update(dt);
    pipetimeInverval.update(dt);
    seedTimer.update(dt); // Update the seed timer
    score.text = 'Score : ${bird.totalScore}';
  }

  @override
  void onTap(){
    super.onTap();
    bird.flyUp();
  }

  TextComponent displayScore(){
    return TextComponent(
      text:'Score : 0',
      position: Vector2(size.x/2, size.y/2* 0.1),
      anchor: Anchor.center,
       textRenderer: TextPaint(
          style: const TextStyle(
              fontSize: 40, 
              fontFamily: 'ThaleahFat', 
              //fontWeight: FontWeight.bold),
              color: Colors.white,
        ),
        )
    );
  }
}

 