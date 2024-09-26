import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class Floor extends PositionComponent with HasGameRef<FlappyBird> {
  Floor();
  final double speed = 200;
  final double floorHeight = 110;

  @override
  Future<void> onLoad() async {
    // Create a blue container with a black top border
    final blueContainer = RectangleComponent(
      position: Vector2(0, gameRef.size.y - floorHeight),
      size: Vector2(gameRef.size.x, floorHeight),
      paint: Paint()..color = Color(0xFF8FCAF0),
    );

    // Add a black top border
    final topBorder = RectangleComponent(
      position: Vector2(0, gameRef.size.y - floorHeight),
      size: Vector2(gameRef.size.x, 2), // Adjust the height of the border
      paint: Paint()..color = Colors.lightBlue.shade900,
    );

    add(blueContainer);
    add(topBorder);

    add(
      // Box around object
      RectangleHitbox(
        position: Vector2(0, gameRef.size.y - floorHeight),
        size: Vector2(gameRef.size.x, floorHeight),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update logic if needed
  }
}


