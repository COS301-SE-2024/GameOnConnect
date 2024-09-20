import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gameonconnect/GameyCon/components/custom_hitbox.dart';
import 'package:gameonconnect/GameyCon/components/score.dart';
import 'package:gameonconnect/GameyCon/gameycon_game.dart';

class Fruit extends SpriteAnimationComponent
    with HasGameRef<GameyCon>, CollisionCallbacks {
  final String fruit;
  final int value; 

  Fruit({
    this.fruit = 'Apple',
    required this.value,
    super.position,
    super.size,
  });

  final double stepTime = 0.05;
  final hitbox = CustomHitbox(
    x: 10,
    y: 10,
    width: 12,
    height: 12,
  );
  bool collected = false;

  @override
  FutureOr<void> onLoad() {
    //debugMode = true;
    priority = -1;

    add(
      RectangleHitbox(
        position: Vector2(hitbox.x, hitbox.y),
        size: Vector2(hitbox.width, hitbox.height),
        collisionType: CollisionType.passive,
      ),
    );

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

  void collidedWithPlayer() async {
    if (!collected) {
      collected = true;
      if (game.playSounds) {
        FlameAudio.play('collect_fruit.wav', volume: game.soundVolume);
      }
      animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Items/Fruits/Collected.png'),
        SpriteAnimationData.sequenced(
          amount: 6,
          stepTime: stepTime,
          textureSize: Vector2.all(32),
          loop: false,
        ),
      );

      ScoreManager().increaseScore(value); //we increase the score by the value of the fruit

      await animationTicker?.completed;
      removeFromParent();
    }
  }
}
