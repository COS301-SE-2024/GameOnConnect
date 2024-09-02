import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/card/game_list_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';

class ChooseGame extends StatefulWidget {
  final int chosenGame;
  const ChooseGame({super.key, required this.chosenGame});

  @override
  State<ChooseGame> createState() => _ChooseGame();
}

class _ChooseGame extends State<ChooseGame> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late int chosenGame ;
  late List<String> gameNames = [];
  late List<String> gameImages = [];
  late List<GameDetails>? games;
  late int gameID;
  bool _isMounted = false;
  String gameName = "";

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    chosenGame = widget.chosenGame;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getGames() async {
    gameNames = [];
    gameImages = [];
    if (games != null) {
      for (var i in games!) {
        gameNames.add(i.name);
        gameImages.add(i.backgroundImage);
      }
    }
  }

  int getGameID(String gameName) {
    int id = -1;
    for (var i in games!) {
      if (i.name == gameName) {
        id = i.id;
      }
    }
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<GameDetails>>(
        future: EventsService().getMyGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            games = snapshot.data;
            getGames();
            return Scaffold(
                appBar: BackButtonAppBar(
                  title: 'Select a game',
                  onBackButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                  iconkey: const Key('Back_button_key'),
                  textkey: const Key('select_a_game_text'),
                ),
                key: scaffoldKey,
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: SafeArea(
                    top: true,
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                      const SizedBox(height: 18),
                      Flexible(
                          child: ListView.separated(
                        itemCount: gameNames.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          String i = gameNames[index];

                          return GameCard(
                            key: Key(i),
                            name: i,
                            gameID: getGameID(i),
                            chosen: chosenGame,
                            image: gameImages[index],
                            onSelected: (gameID,name) {
                              if (_isMounted) {
                                setState(() {
                                  chosenGame = gameID;
                                  gameName = name;
                                });
                              }
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            height: 18,
                          );
                        },
                      )),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            15, 12, 15, 12),
                        child: MaterialButton(
                            key: const Key('save_game_button'),
                            onPressed: () {
                              Navigator.pop(context, ({"chosen":chosenGame,"name":gameName}));
                            },
                            height: 35,
                            color: Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Save Game",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(24, 24, 24, 1.0),
                                    ),
                                    key: Key('save_game_text'),
                                  ),
                                ])),
                      )
                    ])));
          }
        });
  }
}
