// ignore_for_file: prefer_const_constructors
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/game_library_filter.dart';
import '../models/game.dart';
//import 'package:gameonconnect/pages/game_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';


class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  /*static final customCacheManager = CacheManager(
    Config(
      'GamePicturesCache',
      stalePeriod: Duration(days: 5),
    ),
  );*/

  final List<Game> _games = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _sortValue = '';
  List<String> selectedPlatforms = [];

  @override
  void initState() {
    super.initState();
    _loadGames(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _searchQuery.isEmpty) {
        _loadGames(_currentPage);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchEntered(String query) {
    setState(() {
      _searchQuery = query;
      if (_searchQuery.isNotEmpty) {
        _games.clear(); // Clear previous search results
        _searchGames();
      } else {
        _games.clear();
        _searchQuery = '';
        _currentPage = 1;
        _loadGames(_currentPage);
      }
    });
  }

  // void _navigateToGameDetails(Game game) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => GameDetailsPage(gameId: game.id),
  //     ),
  //   );
  // }

  Future<void> _runApiRequest(String request) async {   
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(
        'https://api.rawg.io/api/games?key=b8d81a8e79074f1eb5c9961a9ffacee6$request'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final games = (jsonData['results'] as List)
          .map((gameJson) => Game.fromJson(gameJson))
          .toList();

      setState(() {
        _games.clear();
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

  Future<void> _searchGames() async {
    _runApiRequest('&search=$_searchQuery');
  }

  Future<void> _loadGames(int page) async {
    if (_sortValue!.isNotEmpty) {
      _runApiRequest('&ordering=-$_sortValue&page_size=20&page=$page');
    } else {
      _runApiRequest('&page_size=20&page=$page');
    }
  }

  clearFilters() {
    setState(() {
      _searchQuery = '';
      _sortValue = '';
      _games.clear();
      _currentPage = 1;
      _loadGames(_currentPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            key: _scaffoldKey,
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
                    onSubmitted: _onSearchEntered,
                  ),
                ),
                FilledButton(
                    onPressed: () => clearFilters(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text('Clear filters'),
                        Icon(Icons.clear),
                      ],
                    )),
                sortFilter(context),
                TabBar.secondary(tabs: const [
                  Tab(text: 'GAMES'),
                  Tab(text: 'FRIENDS'),
                ]),
                Expanded(
                    child: TabBarView(children: [gameList(), friendList()]))
              ],
            )));
  }

  Padding sortFilter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: 0.5,
                    color: Theme.of(context).colorScheme.secondary))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Sort by'),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Name'),
                            value: 'name',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Released'),
                            value: 'released',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Added'),
                            value: 'added',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Created'),
                            value: 'created',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Updated'),
                            value: 'updated',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Rating'),
                            value: 'rating',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                        RadioListTile(
                            activeColor: Theme.of(context).colorScheme.primary,
                            title: Text('Metacritic'),
                            value: 'metacritic',
                            groupValue: _sortValue,
                            onChanged: (value) {
                              setState(() {
                                _sortValue = value;
                              });
                            }),
                      ]),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context, 'Sort');
                            setState(() {
                              _games.clear();
                            });
                            await _loadGames(1);
                          },
                          child: const Text('Sort'),
                        ),
                      ],
                    ),
                  ),
                  child: Row(
                    children: [
                      Text("Sort",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Icon(
                        Icons.sort,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => FilterPage(apiFunction: _runApiRequest)),
                    );
                  },
                  child: Row(
                    children: [
                      Text("Filter",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Icon(
                        Icons.tune,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Search",
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
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  // ignore: sized_box_for_whitespace
                  Container(
                    height: 120,
                    width: 134,
                    child: CachedNetworkImage(
                      //cacheManager: customCacheManager,
                      imageUrl: game.backgroundImage,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      fadeInDuration: Duration(milliseconds: 0),
                      fadeOutDuration: Duration(milliseconds: 0),
                      maxHeightDiskCache: 120,
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Row(children: game.getPlatformIcons(context)),
                        Text("Released: ${game.released}"),
                        Row(
                          children: [
                            Text("Genres:"),
                            SizedBox(width: 10),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: game.getStyledGenres(context),
                              ),
                            )
                          ],
                        ),
                        Text("Reviews: ${game.reviewsCount}")
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                            left: 5, top: 3, right: 5, bottom: 3),
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
                      SizedBox(
                        height: 10,
                      )
                    ],
                  )
                ],
              ),
            ),
          ]),
        );
      },
    );
  }

  Widget friendList() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Search for friends',
              suffixIcon: Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
          SizedBox(height: 20),
          // Add a list view or a grid view to display the search results
          // You can use a similar approach to the gameList() method
          // to display the search results
        ],
      ),
    );
  }
}