import 'package:flame/components.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

enum MovingBird { middle, up, down }

class Bird extends SpriteGroupComponent<MovingBird> with HasGameRef<FlappyBird> {
  Bird() : super(size: Vector2(50, 40));

  @override
  Future<void> onLoad() async {
    try {
      final birdMidFlap = await gameRef.loadSprite('bird_midflap.png');
      final birdUpFlap = await gameRef.loadSprite('bird_upflap.png');
      final birdDownFlap = await gameRef.loadSprite('bird_downflap.png');

      // Set sprites map
      sprites = {
        MovingBird.middle: birdMidFlap,
        MovingBird.up: birdUpFlap,
        MovingBird.down: birdDownFlap,
      };

      // Position the bird
      position = Vector2(50, gameRef.size.y / 2 - size.y / 2);

      // Set the initial bird state
      current = MovingBird.middle;

    } catch (e) {
      print('Error loading sprites: $e');
    }
  }
}



/**
 * class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird();

  int score = 0;

  @override
  Future<void> onLoad() async {
    final birdMidFlap = await gameRef.loadSprite(Assets.birdMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.birdUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.birdDownFlap);

    gameRef.bird;

    size = Vector2(50, 40);
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    current = BirdMovement.middle;
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    add(CircleHitbox());
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += Config.birdVelocity * dt;
    if (position.y < 1) {
      gameOver();
    }
  }

  void fly() {
    add(
      MoveByEffect(
        Vector2(0, Config.gravity),
        EffectController(duration: 0.2, curve: Curves.decelerate),
        onComplete: () => current = BirdMovement.down,
      ),
    );
    FlameAudio.play(Assets.flying);
    current = BirdMovement.up;
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    PositionComponent other,
  ) {
    super.onCollisionStart(intersectionPoints, other);

    gameOver();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    game.isHit = true;
    gameRef.overlays.add('gameOver');
    gameRef.pauseEngine();
  }
}
 */