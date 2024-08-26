import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class TagCacheManager extends CacheManager {
  static const key = "tagCache";

  static late TagCacheManager _instance;

  factory TagCacheManager() {
    _instance = TagCacheManager._();
    return _instance;
  }

  TagCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 2), 
      maxNrOfCacheObjects: 100, 
    ),
  );
}
