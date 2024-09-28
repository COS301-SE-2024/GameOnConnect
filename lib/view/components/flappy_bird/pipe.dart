
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

enum WhichPipe { top, bottom }
class Pipe extends SpriteComponent with HasGameRef<FlappyBird>{
  Pipe({
    required this.pipePosition,
    required this.height
  });

  @override
 final double height;
 final WhichPipe pipePosition;
 final double floorHeight=110;

 @override
  Future<void> onLoad() async {
    final pipe = await Flame.images.load('rotated_icicle.png');
    final upsideDownPipe = await Flame.images.load('icicle.png');
    size = Vector2(50, height);

    if(pipePosition== WhichPipe.top){
      position.y = 0;
      sprite = Sprite(upsideDownPipe);
    }
    else if(pipePosition== WhichPipe.bottom){
      position.y = gameRef.size.y - size.y - floorHeight;
      sprite = Sprite(pipe);
    }

    add(RectangleHitbox());

   
  }
}


