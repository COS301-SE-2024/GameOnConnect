import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/profile/game_card.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:timeago/timeago.dart' as timeago;


class MyGameList extends StatefulWidget {
  const MyGameList({super.key, 
  required this. gameStats,
    required this.heading,
    required this.currentlyPlaying,
  }) ;
  final List<GameStats> gameStats;
  final String heading;
  final String currentlyPlaying;

  @override
  State<MyGameList> createState() => _MyGameListState();
}

class _MyGameListState extends State<MyGameList> {

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
           padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Text(
            widget.heading,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (widget.gameStats.isEmpty)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Column(
                    children: [
                      Text(
                        'You currently don\'t have any games in ${widget.heading}. Would you like to add games?',
                      ),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GameLibrary(),
                              ),
                            );
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
          widget.currentlyPlaying.isNotEmpty
            ? FutureBuilder<GameDetails>(
              future: GameService().fetchGameDetails(int.tryParse(widget.currentlyPlaying)),
              builder: (context, gameSnapshot) {
                if (gameSnapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (gameSnapshot.hasError) {
                  return Text('Error: ${gameSnapshot.error}');
                } else {
                  final gameDetails = gameSnapshot.data!;
                  return  
                  /*Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child:*/
                    Column(
                      children:  [
                        ProfileGamesCard(
                      image: gameDetails.backgroundImage,
                      name: gameDetails.name,
                      lastPlayedDate: '',
                      timePlayed: -1,
                      playing: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                      child: Divider(
                        color: Color(0xFF2A2A2A),//Dark grey,
                        thickness: 0.5,
                      ),
                    ),
                                            ],
                    //);
                    
                  );
                }
              },
            )
            : const SizedBox.shrink(), 

          ListView.separated(
            physics: const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
            shrinkWrap: true, // Make ListView take only the space it needs
            itemCount: widget.gameStats.length > 4 ? 4 : widget.gameStats.length,
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
                      //padding: EdgeInsets.all(8.0),
                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                      child:
                       ProfileGamesCard(
                        image: gameDetails.backgroundImage,
                        name: gameDetails.name,
                        lastPlayedDate: formattedRelativeDate,
                        timePlayed: hours,
                        playing: false,
                      ),
                    );
                  }
                },
              );
            },
            separatorBuilder: (context, index) => const Padding(
               padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Divider(
              color: Color(0xFF2A2A2A),//Dark grey,
              thickness: 0.5,
              ),
              //height: 1,
            ),
          ),
        if (widget.gameStats.length > 4)
          Container(
            margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 102,
                padding: const EdgeInsets.fromLTRB(0, 7, 0.9, 7),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'See more',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    letterSpacing: 0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}


}

