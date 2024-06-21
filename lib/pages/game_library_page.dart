// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
  static final customCacheManager = CacheManager(
    Config(
      'GamePicturesCache',
      stalePeriod: Duration(days: 5),
      maxNrOfCacheObjects: 200,
    ),
  );

  final List<Game> _games = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadGames(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadGames(_currentPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGames(int page) async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?key=b8d81a8e79074f1eb5c9961a9ffacee6&page_size=20&page=$page'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final games = (jsonData['results'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();

      setState(() {
        _games.addAll(games);
        _currentPage++;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
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
        controller: _scrollController,
        itemCount: _games.length + 1,
        itemBuilder: (context, index) {
          if (index == _games.length) {
            return _isLoading
                ? Center(child: CircularProgressIndicator())
                : SizedBox.shrink();
          }
          final game = _games[index];
          return Card(
            child: ListTile(
              leading:
                  // ignore: sized_box_for_whitespace
                  Container(
                height: 80,
                width: 80,
                child: CachedNetworkImage(
                  cacheManager: customCacheManager,
                  imageUrl:
                      game.background_image, // Use game's background image URL
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  maxHeightDiskCache: 80,
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              title: Text(game.name),
              subtitle: Text(game.released),
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
  // ignore: non_constant_identifier_names
  final String background_image;

  // ignore: non_constant_identifier_names
  Game(
      {required this.id,
      required this.name,
      required this.released,
      required this.background_image});

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      name: json['name'],
      released: json['released'],
      background_image: json['background_image'],
    );
  }
}
