import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/game_list_card.dart';


class ChooseGame extends StatefulWidget {
  final List<String> myGames;
  final String chosenGame;
  final List<String> images;
  const ChooseGame({super.key, required this.myGames, required this.chosenGame, required this.images});

  @override
  State<ChooseGame> createState() => _ChooseGame();
}

class _ChooseGame extends State<ChooseGame> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> myGames=[];
  String chosenGame = "";
  List<String> images=[];


  @override
  void initState() {
    super.initState();
    myGames = widget.myGames;
    chosenGame = widget.chosenGame;
    images = widget.images;
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
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
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: myGames.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            String i = myGames[index];

                            return GameCard(
                                name: i,
                                chosen: chosenGame,
                                image: images[index],
                                onSelected: (gameName) {
                                  setState(() {
                                    chosenGame = gameName;
                                  });
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
              }