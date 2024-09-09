import 'dart:async';
import 'package:flame/components.dart';
import 'package:gameonconnect/GameyCon/gameycon_game.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<GameyCon> {
  final String fruit;
  Fruit({
    this.fruit = 'Apple',
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  final double stepTime = 0.05;

  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    // debugMode = true;
    priority = -1;

    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('Items/Fruits/$fruit.png'),
      SpriteAnimationData.sequenced(
        amount: 17,
        stepTime: stepTime,
        textureSize: Vector2.all(32),
      ),
    );
    return super.onLoad();
  }
}
