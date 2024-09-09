import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class Background extends SpriteComponent  with HasGameRef<FlappyBird>{
  Background();

  @override
  Future<void> onLoad() async {
    final background = await Flame.images.load('background.png');
    size = gameRef.size;
    sprite = Sprite(background);
  }
}

