import 'dart:async';

import 'package:flame/components.dart';
import 'package:gameonconnect/GameyCon/gameycon_game.dart';

class BackgroundTile extends SpriteComponent with HasGameRef<GameyCon> {
  final String color;
  BackgroundTile({
    this.color = 'Gray',
    position,
  }) : super(
          position: position,
        );

  final double scrollSpeed = 0.4;

  @override
  FutureOr<void> onLoad() async {
    priority = -1;
    size = Vector2.all(64.6);
    sprite = Sprite(game.images.fromCache('Background/$color.png'));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    position.y += scrollSpeed;
    double tileSize = 64;
    int scrollheight = (game.size.y / tileSize).floor();
    if (position.y > scrollheight * tileSize  ) {
      position.y = -tileSize;
    }
    super.update(dt);
  }
}
