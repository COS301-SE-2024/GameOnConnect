// File: lib/pages/space_shooter_page.dart

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/model/space_shooter_game_M/space_shooter_game_model.dart';

class SpaceShooterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space Shooter'),
      ),
      body: GameWidget(
        game: SpaceShooterGame(),
      ),
    );
  }
}























// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flame/components.dart';
// import 'package:flame/input.dart';
// import 'package:flame/flame.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// import 'package:flame_audio/flame_audio.dart';
// import 'package:flame/extensions.dart';
// import 'dart:math';

// class SpaceShooterGame extends FlameGame with PanDetector {
//   late SpriteComponent spaceship;
//   late SpriteComponent background;
//   final double spaceshipSpeed = 300;
//   final List<SpriteComponent> enemies = [];
//   final List<SpriteComponent> bullets = [];

//   @override
//   Future<void> onLoad() async {
//     super.onLoad();

//     // Load background
//     background = SpriteComponent()
//       ..sprite = await loadSprite('background.jpg')
//       ..size = size
//       ..position = Vector2(0, 0);

//     add(background);

//     // Load spaceship
//     spaceship = SpriteComponent()
//       ..sprite = await loadSprite('spaceship.png')
//       ..size = Vector2(64, 64)
//       ..position = size / 2;

//     add(spaceship);

//     // Load enemy sprites and sounds
//     FlameAudio.playLongAudio('background_music.mp3');
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     // Move bullets upwards
//     for (var bullet in bullets) {
//       bullet.position.y -= 300 * dt;
//       if (bullet.position.y < 0) {
//         bullet.removeFromParent();
//         bullets.remove(bullet);
//       }
//     }

//     // Move enemies downwards
//     for (var enemy in enemies) {
//       enemy.position.y += 100 * dt;
//       if (enemy.position.y > size.y) {
//         enemy.removeFromParent();
//         enemies.remove(enemy);
//       }
//     }

//     // Collision detection
//     for (var enemy in List.from(enemies)) {
//       for (var bullet in List.from(bullets)) {
//         if (bullet.toRect().overlaps(enemy.toRect())) {
//           enemy.removeFromParent();
//           enemies.remove(enemy);

//           bullet.removeFromParent();
//           bullets.remove(bullet);

//           FlameAudio.play('explosion.wav');
//         }
//       }
//     }

//     // Spawn new enemies
//     if (enemies.isEmpty) {
//       spawnEnemy();
//     }
//   }

//   @override
//   void onPanUpdate(DragUpdateInfo info) {
//     // Move the spaceship left or right
//     spaceship.position.add(info.delta.global);
//     spaceship.position.clamp(Vector2(0, 0), size - spaceship.size);
//   }

//   Future<void> onTap() async {
//     // Shoot a bullet
//     final bullet = SpriteComponent()
//       ..sprite = Sprite(await Flame.images.load('bullet.png'))
//       ..size = Vector2(16, 32)
//       ..position = spaceship.position + Vector2(spaceship.size.x / 2 - 8, 0);

//     add(bullet);
//     bullets.add(bullet);

//     FlameAudio.play('gun-shot.mp3');
//   }

//   Future<void> spawnEnemy() async {
//     final enemy = SpriteComponent()
//       ..sprite = Sprite(await Flame.images.load('enemy.png'))
//       ..size = Vector2(64, 64)
//       ..position = Vector2(Random().nextDouble() * (size.x - 64), 0);

//     add(enemy);
//     enemies.add(enemy);
//   }
// }
