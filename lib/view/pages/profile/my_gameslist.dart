import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/profile/game_card.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:timeago/timeago.dart' as timeago;


class MyGameList extends StatefulWidget {
  const MyGameList({super.key, 
  required this. gameStats,
    required this.heading,
  }) ;
  final List<GameStats> gameStats;
  final String heading;

  @override
  State<MyGameList> createState() => _MyGameListState();
}

class _MyGameListState extends State<MyGameList> {
   void _navigateToGameDetails(int game) async {
    // ignore_for_file: use_build_context_synchronously
    bool result = await InternetConnection().hasInternetAccess;
    if(result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: game),
        ),
      );
    }else
      {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  "Unable to fetch data, check internet connection"),
              backgroundColor: Colors.red,
            ));
      }
  }

  DateTime _parseTimestampString(String timestampString) {
  try {
    return DateTime.parse(timestampString);
  } catch (e) {
    //print('Error parsing timestamp string: $e');
    return DateTime.now(); // Return current date/time as a fallback
  }
}

double millisecondsToHours(int milliseconds) {
  final hours = milliseconds / (1000 * 3600);
  return double.parse(hours.toStringAsFixed(3));
}

  @override
  Widget build(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.heading,
            style: const TextStyle(
              fontSize: 20, 
              fontWeight: FontWeight.w700),
          ),
          ),
        if (widget.gameStats.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Column(
                    children: [
                      Text('You currently don\'t have any games in ${widget.heading}. Would you like to add games?'),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const GameLibrary()));
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
            shrinkWrap: true, // Make ListView take only the space it needs
            itemCount: widget.gameStats.length,
            itemBuilder: (context, index) {
              return FutureBuilder<GameDetails>(
                future: GameService().fetchGameDetails(widget.gameStats[index].gameId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return const Center(child: Text('No data'));
                  } else {
                    final gameDetails = snapshot.data!;
                    final gameStats = widget.gameStats[index];
                    final lastPlayedDateTime = _parseTimestampString(gameStats.lastPlayedDate);
                    final formattedRelativeDate = timeago.format(lastPlayedDateTime);
                    final hours = millisecondsToHours(gameStats.timePlayedLast);
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ProfileGamesCard(
                        image: gameDetails.backgroundImage,
                        name: gameDetails.name,
                        lastPlayedDate: formattedRelativeDate,
                        timePlayed: hours,
                      ),
                    );
                  }
                },
              );
            },
          ),
      ],
    ),
  );
}

}


