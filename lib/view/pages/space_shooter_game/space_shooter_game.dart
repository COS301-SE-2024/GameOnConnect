import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/model/space_shooter_game_M/space_shooter_game_model.dart';

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  Player() : super(
    size: Vector2(100, 150),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    sprite = await gameRef.loadSprite('player-sprite.png');

    position = gameRef.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    player = Player();

    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta as Vector2);
  }
}

// void main() {
//   runApp(GameWidget(game: SpaceShooterGame()));
// }



















// import 'package:flutter/material.dart';
// import 'package:flame/game.dart';
// import 'package:gameonconnect/model/space_shooter_game_M/space_shooter_game_model.dart';

// class SpaceShooterPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Space Shooter'),
//       ),
//       body: GameWidget(
//         game: SpaceShooterGame(),
//       ),
//     );
//   }
// }
