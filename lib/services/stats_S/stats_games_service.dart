import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import '../../model/game_library_M/game_details_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StatsGamesService {
  Future<List<Map<String, String>>> fetchGameImages(List<Map<String, dynamic>> gameData) async {
    List<Map<String, String>> gameImages = [];

    String? apikey = dotenv.env['RAWG_API_KEY'];

    for (Map<String, dynamic> game in gameData) {
      String gameID = game['gameID'].toString();
      String lastPlayed = (game['last_played'] as Timestamp).toDate().toString();

      try {
        final response = await http.get(Uri.parse(
            'https://api.rawg.io/api/games/$gameID?key=$apikey'));
        if (response.statusCode == 200) {
          GameDetails gameDetails =
              GameDetails.fromJson(jsonDecode(response.body));
          gameImages.add({
            'imageUrl': gameDetails.backgroundImage,
            'lastPlayed': lastPlayed,
          });
        } else {
          throw Exception('Failed to load game details');
        }
      } on SocketException {
        throw Exception('No Internet connection');
      }
    }
    return gameImages;   //returns image urls and timestamp
  }
}