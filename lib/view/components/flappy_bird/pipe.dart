
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

enum whichPipe { top, bottom }
class Pipe extends SpriteComponent with HasGameRef<FlappyBird>{
  Pipe({
    required this.pipePosition,
    required this.height
  });

  @override
 final double height;
 final whichPipe pipePosition;
 final double floorHeight=110;

 Future<void> onLoad() async {
    final pipe = await Flame.images.load('pipe.png');
    final upsideDownPipe = await Flame.images.load('pipe_rotated.png');
    size = Vector2(50, height);

    if(pipePosition== whichPipe.top){
      position.y = 0;
      sprite = Sprite(upsideDownPipe);
    }
    else if(pipePosition== whichPipe.bottom){
      position.y = gameRef.size.y - size.y - floorHeight;
      sprite = Sprite(pipe);
    }

    add(RectangleHitbox());

   
  }
}


