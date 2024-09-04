import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/model/space_shooter_game_M/space_shooter_game_model.dart';

class Player extends SpriteAnimationComponent with HasGameReference<SpaceShooterGame> {
  Player() : super(
    size: Vector2(100, 150),
    anchor: Anchor.center,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'player.png',
      SpriteAnimationData.sequenced(
        amount: 4,
        stepTime: .2,
        textureSize: Vector2(32, 48),
      ),
    );

    position = game.size / 2;
  }

  void move(Vector2 delta) {
    position.add(delta);
  }
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_0.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_2.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    player = Player();
    add(player);
  }


  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
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
