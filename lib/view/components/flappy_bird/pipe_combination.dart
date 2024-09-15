import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:gameonconnect/view/components/flappy_bird/pipe.dart';
import 'package:gameonconnect/view/pages/flappy_bird/flappy_bird.dart';

class PipeCombination extends PositionComponent with HasGameRef<FlappyBird> {
  
  final double floorHeight = 110;
  final double speed = 200;
  final _random = Random();

  PipeCombination();

  @override
  Future<void> onLoad() async {
    position.x = gameRef.size.x;

    final skyHeight = gameRef.size.y - floorHeight;
    final pathHeight = 100 + _random.nextDouble() * (skyHeight / 4);
    final centerYaxis = pathHeight + _random.nextDouble() * (skyHeight - pathHeight);

    // Add top pipe
    add(Pipe(pipePosition: WhichPipe.top, height: centerYaxis - pathHeight / 2));

    // Calculate the bottom pipe height
    final bottomPipeHeight = skyHeight - (centerYaxis + pathHeight / 2);

    // Ensure the bottom pipe does not overlap the ground
    if (bottomPipeHeight > 0 && bottomPipeHeight < skyHeight - floorHeight) {
      add(Pipe(pipePosition: WhichPipe.bottom, height: bottomPipeHeight));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x -= speed * dt;

    if (position.x < -10) {
      removeFromParent();
      gameRef.bird.totalScore += 1; // Increment score when the bird passes a pipe
      FlameAudio.play('point.wav');
    }

    if (gameRef.collision) {
      removeFromParent(); // Remove pipes from the screen on collision
      gameRef.collision = false;
    }
  }
}

  