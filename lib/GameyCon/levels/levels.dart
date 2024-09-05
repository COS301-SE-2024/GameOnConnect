import 'dart:async';


import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    
    level = await TiledComponent.load('Level-1.tmx', Vector2.all(16.0));
    add(level);

     // Add a simple rectangle for debugging
    final paint = BasicPalette.white.paint();
    final rectangle = RectangleComponent(
      position: Vector2(100, 100),
      size: Vector2(200, 200),
      paint: paint,
    );
    add(rectangle);

    return super.onLoad();
  }
}