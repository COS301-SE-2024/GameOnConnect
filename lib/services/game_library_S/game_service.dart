import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService {
  final String? apiKey = dotenv.env['RAWG_API_KEY'];

  Future<GameDetails> fetchGameDetails( gameId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games/$gameId?key=$apiKey'));
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

}
