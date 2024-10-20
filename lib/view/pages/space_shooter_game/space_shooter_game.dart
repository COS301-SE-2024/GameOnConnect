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
  int score = 0;
  double timeElapsed = 0;
  double difficultyLevel = 1;
  bool enemiesShoot = false;

  @override
  Future<void> onLoad() async {
    overlays.add('startOverlay');
    // await initializeGame();

    // overlays.add('quitButton');

    // overlays.add('scoreOverlay');
  }

  void startGame() {
    reset(); // Reset game state
    overlays.remove('startOverlay'); // Remove the start button overlay
    overlays.add('scoreOverlay'); // Add score overlay
    overlays.add('quitButton'); // Add quit button overlay
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
    isGameOver = true; 
    overlays.remove('scoreOverlay');
    overlays.remove('quitButton');
    overlays.add('gameOver'); 
  }

  void reset() {
    removeAll(children);
    score = 0;
    isGameOver = false;
    initializeGame();
    overlays.remove('gameOver'); 
    overlays.add('scoreOverlay'); 
    overlays.add('quitButton');
  }

  void incrementScore() {
    score++;
    overlays
      ..remove('scoreOverlay')
      ..add('scoreOverlay');
  }

  @override
void update(double dt) {
  super.update(dt);

  // Track time elapsed
  if (!isGameOver) {
    timeElapsed += dt;

    // Increase difficulty after every 30 seconds
    if (timeElapsed > 30 * difficultyLevel) {
      difficultyLevel++;
      increaseDifficulty();
    }

    // After 1 minute, enemies will start shooting
    if (timeElapsed > 60 && !enemiesShoot) {
      enemiesShoot = true;
    }
  }
}

void increaseDifficulty() {
  // Increase the speed of enemies
  children.whereType<Enemy>().forEach((enemy) {
    enemy.increaseSpeed(difficultyLevel);
  });
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

  double speed = 250;
  double shootTimer = 0;

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

    // Enemy shooting logic
    if (game.enemiesShoot) {
      shootTimer += dt;
      if (shootTimer > 2) {
        shoot();
        shootTimer = 0;
      }
    }
  }

  void increaseSpeed(double difficultyLevel) {
    speed = 250 * difficultyLevel;
  }

  void shoot() {
    game.add(EnemyBullet(position: position + Vector2(0, height / 2)));
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
      game.incrementScore();
      game.add(EnemyExplosion(position: position));
    }
  }
}

class EnemyBullet extends SpriteAnimationComponent
    with HasGameReference<SpaceShooterGame>, CollisionCallbacks {
  EnemyBullet({
    super.position,
  }) : super(
        size: Vector2(15, 30),
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

    add(RectangleHitbox.relative(
      Vector2(0.5, 0.5),
      parentSize: size,
      collisionType: CollisionType.passive,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);

    position.y += dt * 300; // Move bullet down

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

    if (other is Player) {
      other.removeFromParent();
      game.triggerGameOver(); // End game when player is hit by an enemy bullet
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
