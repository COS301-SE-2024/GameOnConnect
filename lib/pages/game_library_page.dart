// ignore_for_file: prefer_const_constructors
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/game.dart';

class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
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
        appBar: appBar(context),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 15, right: 15),
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100)),
                ),
              ),
            ),
            Expanded(child: gameList()),
          ],
        ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Game Library",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
      actions: [
        Icon(
          Icons.account_circle_outlined,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        )
      ],
    );
  }

  ListView gameList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _games.length + 1,
      itemBuilder: (context, index) {
        if (index == _games.length) {
          return _isLoading
              ? Center(child: CircularProgressIndicator())
              : SizedBox.shrink();
        }
        final game = _games[index];
        print(game.platforms);
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    game.background_image,
                    width: 134,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(game.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          )),
                      Row(children: game.getPlatformIcons(context)),
                      Text("Released: ${game.released}"),
                      Row(
                        children: [
                          Text("Genres:"),
                          SizedBox(width: 10),
                          Row(
                            children: game.getStyledGenres(context),
                          )
                        ],
                      ),
                      Text("Publisher")
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(left: 5, top: 3, right: 5, bottom: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      child: Text("${game.score}",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12)),
                    ),
                    Icon(Icons.chevron_right,
                        color: Theme.of(context).colorScheme.secondary),
                    Icon(Icons.chevron_right, color: Colors.white),
                  ],
                )
              ],
            ),
          ]),
        );
      },
    );
  }
}
