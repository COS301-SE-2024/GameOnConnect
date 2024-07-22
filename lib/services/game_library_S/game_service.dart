import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService{
Future<GameDetails> fetchGameDetails( gameID) async {
  try {
    final String? apiKey = dotenv.env['RAWG_API_KEY'];
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games/$gameID?key=$apiKey'));
    if (response.statusCode == 200) {
      return GameDetails.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load game details');
    }
  } on SocketException {
    throw Exception('No Internet connection');
  }
}
}
