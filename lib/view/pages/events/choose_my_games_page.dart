import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/game_list_card.dart';
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
  int chosenGame = -1;
  late List<String> gameNames = [];
  late List<String> gameImages = [];
  late List<GameDetails>? games;
  late int gameID;

  @override
  void initState() {
    super.initState();
    chosenGame = widget.chosenGame;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getGames() async {
    gameNames = [];
    gameImages = [];
    if(games != null) {
      for (var i in games!) {
        gameNames.add(i.name);
        gameImages.add(i.backgroundImage);
      }
    }
  }

  int getGameID(String gameName)  {
    int id=-1;
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
    if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null ) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
    } else {
    games = snapshot.data;
    getGames();
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child:Column(mainAxisSize: MainAxisSize.max, children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Theme.of(context).colorScheme.secondary,
                            offset: const Offset(
                              0,
                              1,
                            ),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 0, 12),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon:
                                      const Icon(Icons.keyboard_backspace)),
                                  Text(
                                    'Select a game to play',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: gameNames.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            String i = gameNames[index];

                            return GameCard(
                                name: i,
                                gameID: getGameID(i),
                                chosen: chosenGame,
                                image: gameImages[index],
                                onSelected: (gameName) {
                                  setState(() {
                                    chosenGame = gameName;
                                  });
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const SizedBox();
                            },
                          )),
                      Padding(
                        padding:const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                        child: MaterialButton(onPressed: () {Navigator.pop(context,chosenGame);},
                            color: Theme.of(context).colorScheme.primary,
                            child: const Row(children: [
                              Text("Save my game choice"),
                            ])),
                      )
                    ]
                    )
                )
            );
          }
        });

  }
}