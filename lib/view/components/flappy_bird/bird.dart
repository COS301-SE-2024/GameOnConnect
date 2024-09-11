import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/widgets.dart';
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

      // Set sprites map
      sprites = {
        MovingBird.middle: birdMidFlap,
        MovingBird.up: birdUpFlap,
        MovingBird.down: birdDownFlap,
      };

      // Position the bird
      position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

      // Set the initial bird state
      current = MovingBird.middle;
       add(RectangleHitbox()); // add box around it 

    } catch (e) {
      print('Error loading sprites: $e');
    }
  }

  @override
  void update(double d) {
    super.update(d);
    position.y += velocity * d;

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
  }

  @override
 void onCollisionStart(
  Set<Vector2> intersectionArea,
  PositionComponent other,
 ){
    super.onCollisionStart(intersectionArea, other);
    gameIsOver();
 }

 void gameIsOver(){
  game.collision=true;
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

