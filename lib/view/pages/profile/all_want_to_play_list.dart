import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/profile/game_card.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AllWantToPlayList extends StatefulWidget {
  const AllWantToPlayList({
    super.key,
    required this.gameIds,
    required this.heading,
  });
  final List<String> gameIds;
  final String heading;

  @override
  State<AllWantToPlayList> createState() => _AllWantToPlayListState();
}

class _AllWantToPlayListState extends State<AllWantToPlayList> {
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
            ListView.separated(
              physics:
                  const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
              shrinkWrap: true, // Make ListView take only the space it needs
              itemCount: widget.gameIds.length,
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
          ],
        ),
      ),
    );
  }
}
