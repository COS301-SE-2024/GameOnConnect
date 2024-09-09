import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class Floor extends ParallaxComponent<FlappyBird>{
  Floor();
  final double speed = 200;
  final double floorHeight = 100;

  @override
  Future<void> onLoad() async{
    final floor = await Flame.images.load('ground.png');
     parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(floor, fill: LayerFill.none),
      ),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = this.speed;
  }
}

/**
 * class Ground extends ParallaxComponent<FlappyBirdGame>
    with HasGameRef<FlappyBirdGame> {
  Ground();

  @override
  Future<void> onLoad() async {
    final ground = await Flame.images.load(Assets.ground);
    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(ground, fill: LayerFill.none),
      ),
    ]);
    add(
      RectangleHitbox(
        position: Vector2(0, gameRef.size.y - Config.groundHeight),
        size: Vector2(gameRef.size.x, Config.groundHeight),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.gameSpeed;
  }
}
 */