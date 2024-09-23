// ignore_for_file: prefer_const_constructors
//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';
import 'package:gameonconnect/model/game_library_M/game_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import '../../components/game_library/game_library_filter.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:gameonconnect/view/pages/connections/connections_search_page.dart';
import 'package:gameonconnect/view/components/search/search_field.dart';

class GameLibrary extends StatefulWidget {
  const GameLibrary({super.key});

  @override
  State<GameLibrary> createState() => _GameLibraryState();
}

class _GameLibraryState extends State<GameLibrary> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<Game> _games = [];
  int _currentPage = 1;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _sortValue = '';
  List<String> selectedPlatforms = [];
  List<String> _activeFilters = [];
  String _filterString = '';

  @override
  void initState() {
    super.initState();
    _loadGames();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _searchQuery.isEmpty) {
        _loadGames();
      }
    });
  }

  Future<void> _filterGames(
      String filterString, List<String> activeFilters) async {
    if (_isLoading) return;

    setState(() {
      _activeFilters = activeFilters;
      _filterString = filterString;
      _games.clear();
      _currentPage = 1;
    });

    await _loadGames();
  }

  Future<void> _loadGames() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final games = await GameService.fetchGames(_currentPage,
          sortValue: _sortValue, searchQuery: _searchQuery, filterString: _filterString);

      setState(() {
        _games.addAll(games);
        _currentPage++;
      });
    } catch (e) {
      //Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToGameDetails(Game game) async {
    // ignore_for_file: use_build_context_synchronously
    bool result = await InternetConnection().hasInternetAccess;
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: game.id),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unable to fetch data, check internet connection"),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _onSearchEntered(String query) {
    setState(() {
      _searchQuery = query;
      _games.clear();
      _currentPage = 1;
      _loadGames();
    });
  }

  clearFilters() {
    setState(() {
      _activeFilters = [];
      _filterString = '';
      _searchQuery = '';
      _sortValue = '';
      _games.clear();
      _currentPage = 1;
      _loadGames();
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
                TabBar(tabs: const [
                  Tab(text: 'Games'),
                  Tab(text: 'Connections'),
                ]),
                Expanded(
                    child: TabBarView(children: [games(), FriendSearch()])),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _activeFilters.isNotEmpty
                ? Row(
                    children: [
                      Text(
                        "Active Filters (${_activeFilters.length}):",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: SizedBox(
                          height: 25,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: _activeFilters.map((filter) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(6, 1, 6, 1),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(filter),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => StatefulBuilder(
                          builder: (context, setState) => AlertDialog(
                            title: const Text('Sort by'),
                            content: SingleChildScrollView(child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Name'),
                                      value: 'name',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Released'),
                                      value: 'released',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Added'),
                                      value: 'added',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Created'),
                                      value: 'created',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Updated'),
                                      value: 'updated',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Rating'),
                                      value: 'rating',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                  RadioListTile(
                                      activeColor:
                                          Theme.of(context).colorScheme.primary,
                                      title: Text('Metacritic'),
                                      value: 'metacritic',
                                      groupValue: _sortValue,
                                      onChanged: (value) {
                                        setState(() {
                                          _sortValue = value;
                                        });
                                      }),
                                ]),
    ),

                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context, 'Sort');
                                  setState(() {
                                    _games.clear();
                                  });
                                  await _loadGames();
                                },
                                child: const Text('Sort'),
                              ),
                            ],
                          ),
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
                          MaterialPageRoute(
                              builder: (context) => FilterPage(
                                  filterFunction: _filterGames,
                                  clearFiltersFunction: clearFilters)),
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
          ],
        ),
      ),
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Search",
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    );
  }

  Widget games() {
    return Column(children: [
      Padding(
          padding: const EdgeInsets.all(12),
          child: SearchField(
            key: const Key('searchTextField'),
            controller: _searchController,
            onSearch: (query) {
              _onSearchEntered(query);
            },
          )),
      sortFilter(context),
      Expanded(
        child: gameList(),
      )
    ]);
  }

  ListView gameList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _games.length + 1,
      itemBuilder: (context, index) {
        if (index == _games.length) {
          return _isLoading
              ? Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: Theme.of(context).colorScheme.primary,
                    size: 36,
                  ),
                )
              : SizedBox.shrink();
        }
        final game = _games[index];
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            SizedBox(
              height: 120,
              child: InkWell(
                onTap: () => {_navigateToGameDetails(game)},
                child: Row(
                  children: [
                    // ignore: sized_box_for_whitespace
                    Container(
                      height: 120,
                      width: 134,
                      child: CachedNetworkImage(
                        //cacheManager: GameCacheManager(),
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
                          child: LoadingAnimationWidget.halfTriangleDot(
                            color: Theme.of(context).colorScheme.primary,
                            size: 36,
                          ),
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
                          Row(
                              children: game.getPlatformIcons(context,
                                  Theme.of(context).colorScheme.primary)),
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
