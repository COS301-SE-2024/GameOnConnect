import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/profile/game_card.dart';
import 'package:gameonconnect/view/pages/profile/game_activity.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class AllMyGamesList extends StatefulWidget {
  const AllMyGamesList({
    super.key,
    required this.myGameStats,
    required this.heading,
    required this.currentlyPlaying,
    required this.gameActivities,
    required this.isOwnProfile,
  });
  final List<GameStats> myGameStats;
  final List<GameStats> gameActivities;
  final String heading;
  final String currentlyPlaying;
  final bool isOwnProfile;

  @override
  State<AllMyGamesList> createState() => _AllMyGamesListState();
}

class _AllMyGamesListState extends State<AllMyGamesList> {
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
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
        title: widget.heading,
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        iconkey: const Key('Back_button_key'),
        textkey: const Key('activity_text'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.currentlyPlaying.isNotEmpty
                ? FutureBuilder<GameDetails>(
                    future: GameService().fetchGameDetails(
                        int.tryParse(widget.currentlyPlaying)),
                    builder: (context, gameSnapshot) {
                      if (gameSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return LoadingAnimationWidget.halfTriangleDot(
                          color: Theme.of(context).colorScheme.primary,
                          size: 36,
                        );
                      } else if (gameSnapshot.hasError) {
                        return Text('Error: ${gameSnapshot.error}');
                      } else {
                        final gameDetails = gameSnapshot.data!;
                        return
                            /*Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                    child:*/
                            Column(
                          children: [
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
                                color: Color(0xFF2A2A2A), //Dark grey,
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
              physics:
                  const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              shrinkWrap: true, // Make ListView take only the space it needs
              itemCount: widget.myGameStats.length,
              itemBuilder: (context, index) {
                return FutureBuilder<GameDetails>(
                  future: GameService()
                      .fetchGameDetails(widget.myGameStats[index].gameId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.halfTriangleDot(
                          color: Theme.of(context).colorScheme.primary,
                          size: 36,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return const Center(child: Text('No data'));
                    } else {
                      final gameDetails = snapshot.data!;
                      final gameStat = widget.myGameStats[index];
                      final lastPlayedDateTime =
                          _parseTimestampString(gameStat.lastPlayedDate);
                      final formattedRelativeDate =
                          timeago.format(lastPlayedDateTime);
                      final hours =
                          millisecondsToHours(gameStat.timePlayedLast);
                      return Padding(
                        //padding: EdgeInsets.all(8.0),
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: InkWell(
                                onTap: () {
                                  // Your click event action here
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GameActivity(
                                          gameStatsList: widget.gameActivities,
                                          gameId: gameStat.gameId,
                                          gameName: gameDetails.name,
                                        ),
                                      ));
                                      if(widget.isOwnProfile)
                                      {
                                          BadgeService().unlockExplorerComponent('view_activity');
                                      }
                                },
                                child: ProfileGamesCard(
                                  image: gameDetails.backgroundImage,
                                  name: gameDetails.name,
                                  lastPlayedDate: formattedRelativeDate,
                                  timePlayed: hours,
                                  playing: false,
                                ),
                              )
                      );
                    }
                  },
                );
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                child: Divider(
                  color: Color(0xFF2A2A2A), //Dark grey,
                  thickness: 0.5,
                ),
                //height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
