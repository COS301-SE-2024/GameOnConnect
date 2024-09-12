import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/GameyCon/gameycon_game.dart';
import 'package:gameonconnect/GameyCon/components/score.dart'; 

class GameyConPage extends StatefulWidget {
  const GameyConPage({super.key});

  @override
  State<GameyConPage> createState() => _GameyConPageState();
}

class _GameyConPageState extends State<GameyConPage> {
  late GameyCon game;

  @override
  void initState() {
    super.initState();
    game = GameyCon();
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
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScoreManager().resetScore(); 
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: Text(
                        'Leave',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
                'ScoreOverlay': (context, game) {
                  return Positioned(
                    top: 18,
                    right: 20,
                    child: ValueListenableBuilder<int>(
                      valueListenable: ScoreManager().scoreNotifier,
                      builder: (context, score, child) {
                        return Text(
                          'Score: $score',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 22,
                          ),
                        );
                      },
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
