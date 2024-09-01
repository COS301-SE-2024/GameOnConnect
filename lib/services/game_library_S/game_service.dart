import 'dart:convert';
import 'package:gameonconnect/cache_managers/game_cache_manager.dart';
import 'package:gameonconnect/model/game_library_M/game_model.dart';
import '../../../globals.dart' as global;
import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService {
  static Future<List<Game>> fetchGames(int page,
      {String? sortValue, String? searchQuery}) async {
    String request = '&page_size=20&page=$page';

    if (sortValue != null && sortValue.isNotEmpty) {
      request += '&ordering=-$sortValue';
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      request += '&search=$searchQuery';
    }

    var fileInfo = await GameCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());
      return (jsonData['results'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games?key=${global.apiKey}$request'));

      if (response.statusCode == 200) {
        //Cache data
        await GameCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        return (jsonData['results'] as List)
            .map((gameJson) => Game.fromJson(gameJson))
            .toList();
      } else {
        throw Exception('Failed to load games');
      }
    }
  }

  Future<List<Game>> filterGames(String filterString) async {
    String request = 'https://api.rawg.io/api/games?key=${global.apiKey}$filterString';

    var fileInfo = await GameCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());
      return (jsonData['results'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        //Cache data
        await GameCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        return (jsonData['results'] as List)
            .map((gameJson) => Game.fromJson(gameJson))
            .toList();
      } else {
        throw Exception('Failed to load games');
      }
    }

  }

  Future<GameDetails> fetchGameDetails(gameId) async {
    String request =
        'https://api.rawg.io/api/games/$gameId?key=${global.apiKey}';

    var fileInfo = await GameDetailsCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());
      return GameDetails.fromJson(jsonData);
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        //Cache data
        await GameDetailsCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        return GameDetails.fromJson(jsonData);
      } else {
        throw Exception('Failed to load games');
      }
    }
  }

  Future<List<Screenshot>> fetchGameScreenshots(int gameId) async {
    String request = 'https://api.rawg.io/api/games/$gameId/screenshots?key=${global.apiKey}';

    var fileInfo = await GameScreenshotCacheManager().getFileFromCache(request);

    if (fileInfo != null && fileInfo.validTill.isAfter(DateTime.now())) {
      //Load the games from cache
      final jsonData = jsonDecode(await fileInfo.file.readAsString());
      List<dynamic> screenshotJson = jsonData['results'];
      return screenshotJson.map((json) => Screenshot.fromJson(json)).toList();
    } else {
      //Load the games from API
      final response = await http.get(Uri.parse(request));

      if (response.statusCode == 200) {
        //Cache data
        await GameDetailsCacheManager().putFile(
          request,
          response.bodyBytes,
          fileExtension: 'json',
        );
        final jsonData = jsonDecode(response.body);
        List<dynamic> screenshotJson = jsonData['results'];
        return screenshotJson.map((json) => Screenshot.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load game screenshots');
      }
    }
  }
}
