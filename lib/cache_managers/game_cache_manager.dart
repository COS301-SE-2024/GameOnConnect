import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GameCacheManager extends CacheManager {
  static const key = "gameCache";

  static late GameCacheManager _instance;

  factory GameCacheManager() {
    _instance = GameCacheManager._();
    return _instance;
  }

  GameCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 2), 
      maxNrOfCacheObjects: 100, 
    ),
  );
}

class GameDetailsCacheManager extends CacheManager {
  static const key = "gameDetailsCache";

  static late GameDetailsCacheManager _instance;

  factory GameDetailsCacheManager() {
    _instance = GameDetailsCacheManager._();
    return _instance;
  }

  GameDetailsCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 2), 
      maxNrOfCacheObjects: 100, 
    ),
  );
}
