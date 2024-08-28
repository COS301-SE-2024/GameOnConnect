import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class FilteringCacheManager extends CacheManager {
  static const key = "tagCache";

  static late FilteringCacheManager _instance;

  factory FilteringCacheManager() {
    _instance = FilteringCacheManager._();
    return _instance;
  }

  FilteringCacheManager._() : super(
    Config(
      key,
      stalePeriod: const Duration(days: 2), 
      maxNrOfCacheObjects: 100, 
    ),
  );
}
