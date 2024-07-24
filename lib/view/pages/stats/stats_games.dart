import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_games_service.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:logger/logger.dart'; // Add this line for logging

// final logger = Logger(); // Initialize the logger


class GamesWidget extends StatefulWidget {
  const GamesWidget({super.key, required this.gameData});
  final List<Map<String, dynamic>> gameData;

  @override
  State<GamesWidget> createState() => _GamesWidgetState();
}

class _GamesWidgetState extends State<GamesWidget> {
  late Future<List<Map<String, String>>> _gameData;

  @override
  void initState() {
    super.initState();
    _fetchGameData();
  }

  void _fetchGameData() async {
    _gameData = StatsGamesService().fetchGameImages(widget.gameData);
    // setState(() {
    //   _gameData = StatsGamesService().fetchGameImages(widget.gameData); 
    //   logger.i('Data received on GamesWidget: ${widget.gameData}');
    //   logger.i('Data received on GamesWidget: ${_gameData}');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Games',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 32,
            letterSpacing: 0,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _gameData,
        builder: (context, snapshot) {
          // logger.i('GamesWidget snapshot: hasData=${snapshot.hasData} hasError=${snapshot.hasError}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // logger.e('GamesWidget error: ${snapshot.error}');
            return const Center(child: Text('Error loading game data'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No game data available'));
          } else {
            final gameData = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: gameData.map((game) {
                    DateTime lastPlayed = DateTime.parse(game['lastPlayed']!);
                    String timeAgo = timeago.format(lastPlayed);

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              game['imageUrl']!,
                              width: 170,
                              height: 170,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 20),
                            child: Text(
                              timeAgo,
                              // game['lastPlayed']!,
                              style: TextStyle(
                                fontFamily: 'inter',
                                letterSpacing: 0,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}