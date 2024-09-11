import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/view/components/flappy_bird/background.dart';
import 'package:gameonconnect/view/components/flappy_bird/bird.dart';
import 'package:gameonconnect/view/components/flappy_bird/floor.dart';
import 'package:gameonconnect/view/components/flappy_bird/pipe_combination.dart';

class FlappyBird extends FlameGame with TapDetector,HasCollisionDetection{


  late Bird bird;
  Timer timeInverval= Timer(1.5 , repeat:true);
  bool collision=false;
  late TextComponent score;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Floor(),
      bird = Bird(),
    ]);

    timeInverval.onTick = () => add(PipeCombination());

  }

   @override
  void update(double d) {
    super.update(d);
    timeInverval.update(d);
    score.text = 'Score : ${bird.totalScore}';
  }

  @override
  void onTap(){
    super.onTap();
    bird.flyUp();
  }

  
}

 