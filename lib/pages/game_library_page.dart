// ignore_for_file: prefer_const_constructors
//import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  //lee
  final List<String> _friends = ["Alice", "Bob", "Charlie", "David"];// static friends for now 
  List<String> users = [];
  final List<String> _filteredFriends = [];
   TabController? _tabController; // manages state of tabs
  TextEditingController _searchController = TextEditingController(); // controls text input for search bar 

  @override
  void initState() {
    super.initState();
    _loadGames(_currentPage);
    _loadUsers();
    //lee
    //_tabController = TabController(length: 2, vsync: this); //Initializes the TabController with two tabs.
    ///

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _loadGames(_currentPage);
      }
    });

    //lee
     _searchController.addListener(_onSearchChanged);// listener to the search controller to handle search input changes.
  }


  @override
  //Cleans up the controllers when the widget is removed from the tree to avoid memory leaks
  void dispose() {
    _scrollController.dispose();
    //lee
     _tabController?.dispose();
    _searchController.dispose();
    ///
    super.dispose();
  }

//lee
//---? is it not a future function?
// filters the list of games/friends based on current tab and search query
  void _onSearchChanged() {
  final query = _searchController.text.toLowerCase();// convert search query to lower case
  if (_tabController?.index == 0) // active tab is games
  {
    // Search in games(franco)
    
  } 
  else  //active tab is friends
  { 
    // Search in friends
    setState(() {
      _filteredFriends.clear();// clear list 
      _filteredFriends.addAll(
        _friends.where((friend) => friend.toLowerCase().contains(query)),
      );
    });
  }
}

Future<List<String>> searchFriends(String query) async {
  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('profile_data')
      .where('username', isGreaterThanOrEqualTo: query)
      .where('username', isLessThanOrEqualTo: query + '\uf8ff')
      .get();

  List<String> friends = snapshot.docs.map((doc) => doc['username'] as String).toList();
  return friends;
}

Future<void> _loadUsers() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('profile_data').get();
    List<String> userList = snapshot.docs.map((doc) => doc['username'] as String).toList();
    setState(() {
      users = userList;
    });
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
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
                TabBar.secondary(tabs: const [
                  Tab(text: 'GAMES'),
                  Tab(text: 'FRIENDS'),
                ]),
                Expanded(
                    child: TabBarView(children: [gameList(), friendList()]))
              ],
            )));
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            overflow: TextOverflow.ellipsis,),
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
                        Text("Reviews: ${game.reviewsCount}")
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
                      SizedBox(height: 10,)
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
    return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(users[index]),
                );
              },
            );
  }
}
