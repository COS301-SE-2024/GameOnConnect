import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/widgets.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/view/components/flappy_bird/seed.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

enum MovingBird { middle, up, down }

class Bird extends SpriteGroupComponent<MovingBird> with HasGameRef<FlappyBird>,CollisionCallbacks {
  Bird() : super(size: Vector2(50, 40));
  final double velocity =210;
  int totalScore =0;
  @override
  Future<void> onLoad() async {
    try {
      final birdMidFlap = await gameRef.loadSprite('bird_midflap.png');
      final birdUpFlap = await gameRef.loadSprite('bird_upflap.png');
      final birdDownFlap = await gameRef.loadSprite('bird_downflap.png');

      sprites = {
        MovingBird.middle: birdMidFlap,
        MovingBird.up: birdUpFlap,
        MovingBird.down: birdDownFlap,
      };

      position = Vector2(50, gameRef.size.y / 2 - size.y / 2);


      current = MovingBird.middle;
       add(RectangleHitbox()); // add box around it 

    } catch (e) {
      //print('Error loading sprites: $e');
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += velocity * dt;

  }

  void flyUp(){
    add( 
      MoveByEffect(
        Vector2(0, -100), 
        EffectController(
          duration: 0.2,
          curve: Curves.decelerate,
        ),
        onComplete: () => current =MovingBird.down,
        ));
    current = MovingBird.up;
    //add flying sound
  }

  @override
 void onCollisionStart(
  Set<Vector2> intersectionPoints,
  PositionComponent other,
 ){ 
    super.onCollisionStart(intersectionPoints, other);
    if (other is Seed) {
      totalScore += 2; 
      FlameAudio.play('point.wav');
    }
    else{
      gameIsOver();
    }
  }

 void gameIsOver(){
  FlameAudio.play('collision.wav');
  game.collision=true;

  if(totalScore>= 15)
  {
    BadgeService().unlockAchieverBadge();
  }

  gameRef.overlays.add('gameOver');
  gameRef.pauseEngine();
 }

 void resetBirdPosition(){
  position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
 }

 void resetTotalScore(){
  totalScore=0;
 }

}

