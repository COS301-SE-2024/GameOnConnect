import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
  List<Game> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?key=b8d81a8e79074f1eb5c9961a9ffacee6&page_size=50'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final games =
          jsonData['results'].map<Game>((gameJson) => Game.fromJson(gameJson)).toList();
      setState(() {
        _games = games;
      });
    } else {
      throw Exception('Failed to load games');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return Card(
            child: ListTile(
              title: Text(game.name),
              subtitle: Text(game.released as String),
            ),
          );
        },
      ),
    );
  }
}

class Game {
  final int id;
  final String name;
  final String released;

  Game({required this.id, required this.name, required this.released});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
    );
  }
}
