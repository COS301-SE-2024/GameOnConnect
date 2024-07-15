import 'dart:convert';
import 'dart:io';
import '../../model/game_library_M/game_details_model.dart';
import 'package:http/http.dart' as http;

class GameService {
  final String apiKey = 'b8d81a8e79074f1eb5c9961a9ffacee6';

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

  Future<List<Screenshot>> fetchGameScreenshots(int gameId) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.rawg.io/api/games/$gameId/screenshots?key=$apiKey'));
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










// import 'dart:convert';
// import 'dart:io';
// import '../../model/game_library_M/game_details_model.dart';
// import 'package:http/http.dart' as http;

// class GameService{
// Future<GameDetails> fetchGameDetails( gameID) async {
//   try {
//     final response = await http.get(Uri.parse(
//         'https://api.rawg.io/api/games/$gameID?key=b8d81a8e79074f1eb5c9961a9ffacee6'));
//     if (response.statusCode == 200) {
//       final jsonResponse = jsonDecode(response.body);
//       print('Full JSON response: $jsonResponse'); // Debugging statement
//       return GameDetails.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Failed to load game details');
//     }
//   } on SocketException {
//     throw Exception('No Internet connection');
//   }
// }
// }
