import 'dart:convert';
import 'dart:io';
import 'package:gameonconnect/model/game_library_M/game_model.dart';

import '../../../globals.dart' as global;

import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService {
  static Future<List<Game>> fetchGames(int page, {String? sortValue, String? searchQuery}) async {
    String request = '&page_size=20&page=$page';
    
    if (sortValue != null && sortValue.isNotEmpty) {
      request += '&ordering=-$sortValue';
    }

    if (searchQuery != null && searchQuery.isNotEmpty) {
      request += '&search=$searchQuery';
    }

    final response = await http.get(Uri.parse('https://api.rawg.io/api/games?key=${global.apiKey}$request'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData['results'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();
    } else {
      throw Exception('Failed to load games');
    }
  }

  Future<GameDetails> fetchGameDetails( gameId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games/$gameId?key=${global.apiKey}'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return GameDetails.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load game details');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

  Future<List<Screenshot>> fetchGameScreenshots(int gameId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games/$gameId/screenshots?key=${global.apiKey}'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        List<dynamic> screenshotJson = jsonResponse['results'];
        return screenshotJson.map((json) => Screenshot.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load game screenshots');
      }
    } on SocketException {
      throw Exception('No Internet connection');
    }
  }

}

