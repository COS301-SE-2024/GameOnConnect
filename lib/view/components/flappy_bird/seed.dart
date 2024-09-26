import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:gameonconnect/view/components/flappy_bird/bird.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class Seed extends SpriteComponent with HasGameRef<FlappyBird>,
 CollisionCallbacks {
  final double seedSize = 100; 
  final double fallSpeed = 100; 
  
  Seed() : super(size: Vector2(50, 50)); 

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite('pixelbean.png'); 
    position = Vector2(
      _randomXPosition(),
      0, // Start at the top of the screen
    );
    add(RectangleHitbox()); 
  }

  
  double _randomXPosition() {
    return gameRef.size.x * Random().nextDouble();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move down the screen
    position.y += fallSpeed * dt;

    // Remove if it goes off the screen
    if (position.y > gameRef.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Bird) {
      removeFromParent(); 
    }
  }
}
