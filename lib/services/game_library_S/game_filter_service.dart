import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gameonconnect/cache_managers/filtering_cache_manager.dart';
import 'package:gameonconnect/model/game_library_M/game_filter_model.dart';
import 'package:gameonconnect/model/game_library_M/game_filters_model.dart';

class GameFilterService {
  static get http => null;

  static Future<FilterList> createFilterList() async {
    String? apikey = dotenv.env['RAWG_API_KEY'];

    final storeFilters = await _fetchFilters('https://api.rawg.io/api/stores?key=$apikey');
    final genreFilters = await _fetchFilters('https://api.rawg.io/api/genres?key=$apikey');
    final tagFilters = await _fetchFilters('https://api.rawg.io/api/tags?key=$apikey');
    final platformFilters = await _fetchFilters('https://api.rawg.io/api/platforms?key=$apikey');

    return FilterList(
      storeFilters: storeFilters,
      genreFilters: genreFilters,
      tagFilters: tagFilters,
      platformFilters: platformFilters,
    );
  }

  static Future<List<Filter>> _fetchFilters(String url) async {
    var fileInfo = await FilteringCacheManager().getFileFromCache(url);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());

      
        return (jsonData['results'] as List)
            .map((filterJson) => Filter.fromJson(filterJson))
            .toList();
      
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        //Cache data
        await FilteringCacheManager().putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
     
          return (jsonData['results'] as List)
              .map((filterJson) => Filter.fromJson(filterJson))
              .toList();
       
      } else {
        throw Exception('Failed to load tags');
      }
    }
  }
}