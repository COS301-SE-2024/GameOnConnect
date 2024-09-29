import 'package:flutter/material.dart';
import 'package:flame/game.dart';
// import 'package:gameonconnect/view/components/GameyCon/components/leavebutton.dart';
import 'package:gameonconnect/view/components/GameyCon/gameycon_game.dart';
import 'package:gameonconnect/view/components/GameyCon/components/score.dart'; 

class GameyConPage extends StatefulWidget {
  final String selectedCharacter;

  const GameyConPage({required this.selectedCharacter, super.key});

  @override
  State<GameyConPage> createState() => _GameyConPageState();
}

class _GameyConPageState extends State<GameyConPage> {
  late GameyCon game;

  @override
  void initState() {
    super.initState();
    game = GameyCon(selectedCharacter: widget.selectedCharacter);
  }

  @override
  void dispose() {
    game.onRemove();
    ScoreManager().resetScore(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GameWidget(
              game: game,
              overlayBuilderMap: {
                'LeaveButton': (context, game) {
                  return Positioned(
                    top: 10,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
                      onPressed: () {
                        Navigator.pop(context); 
                      },
                    ),//LeaveButton(),
                  );
                },
                'ScoreOverlay': (context, game) {
                  return Align(
                    alignment: Alignment.topCenter, // Align the widget to the top center
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10), // Adds padding from the top
                      child: ValueListenableBuilder<int>(
                        valueListenable: ScoreManager().scoreNotifier,
                        builder: (context, score, child) {
                          return Text(
                            'Score: $score',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 40,
                              fontFamily: 'ThaleahFat',
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              },
              initialActiveOverlays: const ['LeaveButton', 'ScoreOverlay'],
            ),
          ),
        ],
      ),
    );
  }
}
