import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

class SpaceShooterGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Player player;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    await initializeGame();

    // final parallax = await loadParallaxComponent(
    //   [
    //     ParallaxImageData('stars_2.png'),
    //     ParallaxImageData('stars_1.png'),
    //     ParallaxImageData('stars_0.png'),
    //   ],
    //   baseVelocity: Vector2(0, -5),
    //   repeat: ImageRepeat.repeat,
    //   velocityMultiplierDelta: Vector2(0, 5),
    // );
    // add(parallax);

    // player = Player();
    // add(player);

    // add(
    //   SpawnComponent(
    //     factory: (index) {
    //       return Enemy();
    //     },
    //     period: 1,
    //     area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
    //   ),
    // );

    overlays.add('quitButton');
  }

  Future<void> initializeGame() async {
    // Load parallax background
    final parallax = await loadParallaxComponent(
      [
        ParallaxImageData('stars_2.png'),
        ParallaxImageData('stars_1.png'),
        ParallaxImageData('stars_0.png'),
      ],
      baseVelocity: Vector2(0, -5),
      repeat: ImageRepeat.repeat,
      velocityMultiplierDelta: Vector2(0, 5),
    );
    add(parallax);

    // Add player to the game
    player = Player();
    add(player);

    // Spawn enemies
    add(
      SpawnComponent(
        factory: (index) {
          return Enemy();
        },
        period: 1,
        area: Rectangle.fromLTWH(0, 0, size.x, -Enemy.enemySize),
      ),
    );
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.global);
  }

  @override
  void onPanStart(DragStartInfo info) {
    player.startShooting();
  }

  @override
  void onPanEnd(DragEndInfo info) {
    player.stopShooting();
  }

  void triggerGameOver() {
    isGameOver = true; // Set the game as over
    overlays.add('gameOver'); // Show the game over overlay
  }

  void reset() {
    // Clear all current components (e.g., enemies, bullets)
    removeAll(children);

    // Reinitialize the game
    initializeGame();
  }
}

class Player extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Player()
      : super(
          size: Vector2(110, 120),     //size: Vector2(120, 130), frigate
          anchor: Anchor.center,
        );

  late final SpawnComponent _bulletSpawner;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // animation = await game.loadSpriteAnimation(
    //   'Battlecruiser.png',
    //   SpriteAnimationData.sequenced(
    //     amount: 30,
    //     stepTime: .2,
    //     textureSize: Vector2(128, 128),
    //   ),
    // );

    animation = await game.loadSpriteAnimation(
      'Frigate.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: .2,
        textureSize: Vector2(64, 64),
      ),
    );

    position = game.size / 2;

    _bulletSpawner = SpawnComponent(
      period: .2,
      selfPositioning: true,
      factory: (index) {
        return Bullet(
          position: position +
              Vector2(
                0,
                -height / 2,
              ),
        );
        
      },
      autoStart: false,
    );

    game.add(_bulletSpawner);

    add(RectangleHitbox.relative(
      Vector2(0.3, 0.3), 
      parentSize: size,
    ));
  }

  void move(Vector2 delta) {
    position.add(delta);
  }

  void startShooting() {
    _bulletSpawner.timer.start();
  }

  void stopShooting() {
    _bulletSpawner.timer.stop();
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Enemy) {
      removeFromParent();
      other.removeFromParent();
      game.add(PlayerExplosion(position: position));

      game.overlays.add('gameOver');
    }
  }
}

class Bullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  Bullet({
    super.position,
  }) : super(
          size: Vector2(25, 50),
          anchor: Anchor.center,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'bullet.png',
      SpriteAnimationData.sequenced(
        amount: 2,
        stepTime: .2,
        textureSize: Vector2(8, 8),
      ),
    );

    // add(
    //   RectangleHitbox(
    //     collisionType: CollisionType.passive,
    //   ),
    // );
    add(RectangleHitbox.relative(
      Vector2(0.5, 0.5), 
      parentSize: size,
      collisionType: CollisionType.passive,
    ));

  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * -500;

    if (position.y < -height) {
      removeFromParent();
    }
  }
}

class Enemy extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  Enemy({
    super.position,
  }) : super(
          size: Vector2.all(enemySize),
          anchor: Anchor.center,
        );

  static const enemySize = 100.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'Scout.png',
      SpriteAnimationData.sequenced(
        amount: 6,
        stepTime: .2,
        textureSize: Vector2.all(64),
      ),
    );

    add(RectangleHitbox.relative(
      Vector2(0.5, 0.5), 
      parentSize: size,
    ));

  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 250;

    if (position.y > game.size.y) {
      removeFromParent();
    }
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Bullet) {
      removeFromParent();
      other.removeFromParent();
      game.add(EnemyExplosion(position: position));
    }
  }
}

class EnemyExplosion extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  EnemyExplosion({
    super.position,
  }) : super(
          size: Vector2.all(100),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'Scout_Destruction.png',
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: .1,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
  }
}

class PlayerExplosion extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame> {
  PlayerExplosion({
    super.position,
  }) : super(
          size: Vector2(120, 130),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'Frigate_Destruction.png',
      SpriteAnimationData.sequenced(
        amount: 9,
        stepTime: .2,
        textureSize: Vector2.all(64),
        loop: false,
      ),
    );
  }
}
