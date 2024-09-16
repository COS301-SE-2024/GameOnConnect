// import 'package:flame/components.dart';
// import 'package:flame/events.dart';
// import 'package:flame/game.dart';
// import 'package:flame/input.dart';
// import 'package:flutter/material.dart';

// class Player extends PositionComponent { 
//   static final _paint = Paint()..color = Colors.white;
  
//   @override
//   void render(Canvas canvas) {
//     canvas.drawRect(size.toRect(), _paint);
//   }

//   void move(Vector2 delta) {
//     position.add(delta);
//   }
// }

// class SpaceShooterGame extends FlameGame with PanDetector {
//   late Player player;

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     player = Player()
//       ..position = size / 2
//       ..width = 50
//       ..height = 100
//       ..anchor = Anchor.center;

//     add(player);
//   }

//   @override
//   void onPanUpdate(DragUpdateInfo info) {
//     player.move(info.delta as Vector2);       //check this later
//   }
// }

// class Bullet extends SpriteAnimationComponent
//     with HasGameReference<SpaceShooterGame> {
//   Bullet({
//     super.position,
//   }) : super(
//           size: Vector2(25, 50),
//           anchor: Anchor.center,
//         );

//   @override
//   Future<void> onLoad() async {
//     await super.onLoad();

//     animation = await game.loadSpriteAnimation(
//       'bullet.png',
//       SpriteAnimationData.sequenced(
//         amount: 4,
//         stepTime: .2,
//         textureSize: Vector2(8, 16),
//       ),
//     );
//   }

//   @override
//   void update(double dt) {
//     super.update(dt);

//     position.y += dt * -500;

//     if (position.y < -height) {
//       removeFromParent();
//     }
//   }
// }