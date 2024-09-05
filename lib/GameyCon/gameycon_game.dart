import 'dart:async';
import 'dart:ui';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/GameyCon/actors/player.dart';
import 'package:gameonconnect/GameyCon/levels/levels.dart';

class GameyCon extends FlameGame with HasKeyboardHandlerComponents{
  @override
  Color backgroundColor() => const Color.fromARGB(255, 97, 11, 155);

  @override
  final world = Level(
    player: Player(character: 'Ninja Frog'),
    levelName: 'Level-1',
  );

  @override
  late final CameraComponent camera;

  GameyCon() {
    camera = CameraComponent(
      world: world,
      viewport: FixedResolutionViewport(resolution: Vector2(365, 640)),
    );
    camera.viewfinder.anchor = Anchor.topLeft;
  }

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages(); //load all images into the cache
    addAll([camera, world]); //add the camera and the world to the game
    await world.onLoad(); //load the world first
    return super.onLoad();
  }
}
