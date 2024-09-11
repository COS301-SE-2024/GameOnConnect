import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/parallax.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class Floor extends ParallaxComponent<FlappyBird>with HasGameRef<FlappyBird>{
  Floor();
  final double speed = 200;
  final double floorHeight = 110;

  @override
  Future<void> onLoad() async{
    final floor = await Flame.images.load('ground.png');
     parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(
          floor, fill: LayerFill.none),
      ),
    ]);

    add(
      //box arround object
      RectangleHitbox(
        position: Vector2(0, gameRef.size.y- floorHeight),
        size: Vector2(gameRef.size.x, floorHeight),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = speed;
  }
}

