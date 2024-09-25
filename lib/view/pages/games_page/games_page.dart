import 'package:flame/flame.dart';
import 'package:gameonconnect/view/pages/GameyCon/loadingpage.dart';
import 'package:gameonconnect/view/pages/flappy_bird/game_screen_page.dart';
import 'package:gameonconnect/view/pages/space_shooter_game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/games_page_S/games_page_service.dart';

class GamesPageWidget extends StatefulWidget {
  const GamesPageWidget({super.key});

  @override
  State<GamesPageWidget> createState() => _GamesPageWidgetState();
}

class _GamesPageWidgetState extends State<GamesPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int unlockedBadges = 0;

  @override
  void initState() {
    super.initState();
    _loadUnlockedBadges();
  }

  Future<void> _loadUnlockedBadges() async {
    int count = await GamesPageService().getUnlockedBadgesCount();
    if (mounted) {
      setState(() {
        unlockedBadges = count;
      });
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'Mini Games',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Space Shooter Game container (requires 1 badge)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 30, 12, 12),
                child: GestureDetector(
                  onTap: () {
                    if (unlockedBadges >= 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GamePage(),
                        ),
                      );
                    } else {
                      _showInfoMessage("You need at least 1 badge unlocked to play this game.");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Space Shooter Game',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: unlockedBadges >= 1
                              ? Image.asset(
                                  'assets/images/Frigate_icon.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.lock_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 60,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Flappy Bird container (requires 4 badges)
              Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () {
                    if (unlockedBadges >= 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    } else {
                      _showInfoMessage("You need at least 4 badges unlocked to play this game.");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Flappy Bird',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: unlockedBadges >= 4
                              ? Image.asset(
                                  'assets/images/bird_downflap.png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.lock_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 60,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // GameyCon container (requires 9 badges)
              Padding(
                padding: const EdgeInsets.all(12),
                child: GestureDetector(
                  onTap: () async {
                    if (unlockedBadges >= 9) {
                      await Flame.device.fullScreen();
                      if (!context.mounted) return;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoadingGameyConPage(),
                        ),
                      );
                    } else {
                      _showInfoMessage("You need at least 9 badges unlocked to play this game.");
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'GameyCon',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: unlockedBadges >= 9
                              ? Image.asset(
                                  'assets/images/Main Characters/Mask Dude/Fall (32x32).png',
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Icon(
                                  Icons.lock_outlined,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 60,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
