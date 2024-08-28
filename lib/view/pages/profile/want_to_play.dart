import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/profile/game_card.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/view/pages/profile/all_want_to_play_list.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class WantToPlayList extends StatefulWidget {
  const WantToPlayList({
    super.key,
    required this.gameIds,
    required this.heading,
  });
  final List<String> gameIds;
  final String heading;

  @override
  State<WantToPlayList> createState() => _WantToPlayListState();
}

class _WantToPlayListState extends State<WantToPlayList> {
  // ignore: unused_element
  void _navigateToGameDetails(int game) async {
    // ignore_for_file: use_build_context_synchronously
    bool result = await InternetConnection().hasInternetAccess;
    if (result) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: game),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Unable to fetch data, check internet connection"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          if (widget.gameIds.isEmpty)
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
            ListView.separated(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              shrinkWrap: true, // Make ListView take only the space it needs
              itemCount: widget.gameIds.length > 4 ? 4 : widget.gameIds.length,
              itemBuilder: (context, index) {
                return FutureBuilder<GameDetails>(
                  future: GameService().fetchGameDetails(widget.gameIds[index]),
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

                      return Padding(
                        //padding: EdgeInsets.all(8.0),
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: InkWell(
                          onTap: () {
                            _navigateToGameDetails(gameDetails.id);
                          },
                          child: ProfileGamesCard(
                            image: gameDetails.backgroundImage,
                            name: gameDetails.name,
                            lastPlayedDate: '',
                            timePlayed: '',
                            playing: false,
                          ),
                        ),
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
          if (widget.gameIds.length > 4)
            InkWell(
              onTap: () {
                // Your click event action here
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllWantToPlayList(
                          gameIds: widget.gameIds, heading: widget.heading)),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 102,
                    padding: const EdgeInsets.fromLTRB(0, 7, 0.9, 7),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary),
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
            ),
        ],
      ),
    );
  }
}
