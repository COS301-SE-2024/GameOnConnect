import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/view/pages/space_shooter_game/space_shooter_game.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final BadgeService _badgeService = BadgeService();
  
  @override
  void initState() {
    super.initState();
    _badgeService.unlockExplorerComponent("play_spaceshooter");
  }

  @override
  Widget build(BuildContext context) {
    return GameWidget<SpaceShooterGame>(
      game: SpaceShooterGame(),
      overlayBuilderMap: {
        'quitButton': (BuildContext context, SpaceShooterGame game) {
          return Positioned(
            top: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.grey, size: 30),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
          );
        },
        'gameOver': (BuildContext context, SpaceShooterGame game) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                  child: Text(
                    'Game Over',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                      fontFamily: 'ThaleahFat',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); 
                  },
                  child: const Text('Quit Game'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    game.overlays.remove('gameOver'); 
                    game.reset(); 
                  },
                  child: const Text('Restart Game'),
                ),
                const SizedBox(height: 20),
              ],
            )
          );
        },
        'scoreOverlay': (BuildContext context, SpaceShooterGame game) {
          return const Align(
            alignment: Alignment.topLeft,
            child: ScoreOverlay(isGameOver: false),
          );
        },
        'startOverlay': (BuildContext context, SpaceShooterGame game) {
          return Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/stars_2.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center, 
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                      child: Column(
                        children: [
                          Text(
                            'Welcome to',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'ThaleahFat',
                            ),
                          ),
                          Text(
                            'Space Shooter!',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.none,
                              fontFamily: 'ThaleahFat',
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        game.overlays.remove('startOverlay'); 
                        game.startGame(); 
                      },
                      child: const Text('Start Game'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      },
      initialActiveOverlays: const ['startOverlay', 'quitButton'],
    );
  }
}

class ScoreOverlay extends StatelessWidget {
  final bool isGameOver;

  const ScoreOverlay({super.key, required this.isGameOver});

  @override
  Widget build(BuildContext context) {
    final game = context.findAncestorWidgetOfExactType<GameWidget<SpaceShooterGame>>()?.game;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return StreamBuilder<int>(
      stream: Stream.periodic(const Duration(milliseconds: 100))
          .asyncMap((_) => game?.score ?? 0),
      builder: (context, snapshot) {
        return Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                'Score: ${snapshot.data ?? 0}',
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                  fontFamily: 'ThaleahFat',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
