import 'package:flame/components.dart';
import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/GameyCon/components/score.dart';

class ScoreComponent extends TextComponent {
  ScoreComponent()
      : super(
          text: 'Score: 0',
          textRenderer: TextPaint(
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        );

  @override 
  void update(double dt) { //updates the score
    super.update(dt);
    text = 'Score: ${ScoreManager().score}';
  }

}