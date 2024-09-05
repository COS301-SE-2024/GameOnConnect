import 'dart:async';


import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';

class Level extends World {

  late TiledComponent level;

  @override
  FutureOr<void> onLoad() async {
    
    level = await TiledComponent.load('Level-1.tmx', Vector2.all(16.0));
    add(level);

    return super.onLoad();
  }
}