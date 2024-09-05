import 'dart:async';
import 'dart:ui';

import 'package:flame/game.dart';
import 'package:gameonconnect/GameyCon/levels/levels.dart';

class GameyCon extends FlameGame {
  @override
  Color backgroundColor() => const Color.fromARGB(255, 97, 11, 155);

  @override
  final world = Level();

  @override
  FutureOr<void> onLoad() {
    
    addAll([world]);
    return super.onLoad();
  }
}
