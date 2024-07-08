import 'dart:convert';
import 'dart:io';
import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService{
Future<GameDetails> fetchGameDetails( gameID) async {
  try {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games/$gameID?key=b8d81a8e79074f1eb5c9961a9ffacee6'));
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