import 'dart:async';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/GameyCon/actors/player.dart';
import 'package:gameonconnect/GameyCon/levels/levels.dart';

class GameyCon extends FlameGame with HasKeyboardHandlerComponents {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 97, 11, 155);

  late final CameraComponent cam;
  late JoystickComponent joystick;
  late Player player = Player(character: 'Ninja Frog');
  bool isJoystickOn = true;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();

    world = Level(
      player: player,
      levelName: 'Level-1',
    );

    cam = CameraComponent(
      world: world,
      viewport: FixedResolutionViewport(resolution: Vector2(365, 640)),
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([cam, world]);
    if (isJoystickOn) {
      addJoyStick();
    }
    
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (isJoystickOn) {
      updateJoystick();
    }
    super.update(dt);
  }

  void addJoyStick() {
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Knob.png'),
        ),
      ),
      background: SpriteComponent(
        sprite: Sprite(
          images.fromCache('HUD/Joystick.png'),
        ),
      ),
      margin: const EdgeInsets.only(left: 32, bottom: 32),
    );

    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
        player.playerDirection = PlayerDirection.left;
        break;
      case JoystickDirection.right:
      case JoystickDirection.upRight:
      case JoystickDirection.downRight:
        player.playerDirection = PlayerDirection.right;
        break;
      default:
      player.playerDirection = PlayerDirection.none;
        break;
    }
  }
}
