import 'dart:async';
import 'package:flutter_emoji_feedback/gen/assets.gen.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/services/stats_S/session_stats_service.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameTimer createState() => _GameTimer();
}

class _GameTimer extends State<GameTimer> {
  final MyGamesService _currentlyPlaying = MyGamesService();
  final GameService _gameService = GameService();
  final ProfileService _profileService = ProfileService();
  Future<List<GameDetails>>? _userGames;
  String? _selectedItem;
  static final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  final SessionStatsService _sessionStatsService = SessionStatsService();
  String _mood = "No mood";
  DateTime _startTime = DateTime.timestamp();

  @override
  void initState() {
    super.initState();
    _fetchUserGames();
  }

  Future<void> _fetchUserGames() async {
    try {
      List<String> myGameIds = await _currentlyPlaying.getMyGames();

      Future<List<GameDetails>> gameDetailsFutures = Future.wait(
        myGameIds.map((id) => _gameService.fetchGameDetails(id)),
      );

      List<GameDetails> gameDetails = await gameDetailsFutures;

      setState(() {
        _userGames = Future.value(gameDetails);
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _startStopWatch() {
    _startTime = DateTime.timestamp();
    _stopwatch.reset();
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
    _profileService.setCurrentlyPlaying(_selectedItem!);
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
    _profileService.setCurrentlyPlaying("");
  }

  String _formatElapsedTime() {
    final int hours = _stopwatch.elapsed.inHours;
    final int minutes = (_stopwatch.elapsed.inMinutes % 60);
    final int seconds = (_stopwatch.elapsed.inSeconds % 60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            _stopwatch.isRunning ? 'Done playing?' : "Start playing",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.videogame_asset),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _stopwatch.isRunning
                      ? Row(
                          children: [
                            const Icon(
                              Icons.radio_button_checked,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              _formatElapsedTime(),
                              style: const TextStyle(color: Colors.red),
                            )
                          ],
                        )
                      : FutureBuilder<List<GameDetails>>(
                          future: _userGames,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<GameDetails>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return LoadingAnimationWidget.halfTriangleDot(
                                color: Theme.of(context).colorScheme.primary,
                                size: 36,
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No data found');
                            } else {
                              return DropdownButton<String>(
                                isDense: true,
                                underline: const SizedBox(),
                                value: _selectedItem,
                                hint: const Text('What are you playing?'),
                                items: snapshot.data!.map((GameDetails game) {
                                  return DropdownMenuItem<String>(
                                    value: game.id.toString(),
                                    child: Text(game.name),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedItem = newValue;
                                  });
                                },
                              );
                            }
                          }),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: _stopwatch.isRunning
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                    icon: _stopwatch.isRunning
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        if (_stopwatch.isRunning) {
                          _stopStopwatch();
                          //show emoji feedback
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    'How was your experience playing this game?'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      EmojiFeedback(
                                        emojiPreset: const [
                                          EmojiModel(
                                            src: Assets.classicTerrible,
                                            label: 'Scared',
                                            package: 'flutter_emoji_feedback',
                                          ),
                                          EmojiModel(
                                            src: Assets.classicBad,
                                            label: 'Disgusted',
                                            package: 'flutter_emoji_feedback',
                                          ),
                                          EmojiModel(
                                            src: Assets.flatTerrible,
                                            label: 'Angry',
                                            package: 'flutter_emoji_feedback',
                                          ),
                                          EmojiModel(
                                            src: Assets.flatBad,
                                            label: 'Sad',
                                            package: 'flutter_emoji_feedback',
                                          ),
                                          EmojiModel(
                                            src: Assets.flatVeryGood,
                                            label: 'Happy',
                                            package: 'flutter_emoji_feedback',
                                          )
                                        ],
                                        inactiveElementBlendColor:
                                            Theme.of(context)
                                                .colorScheme
                                                .surface,
                                        onChanged: (value) {
                                          setState(() {
                                            switch (value) {
                                              case 1:
                                                _mood = "Scared";
                                              case 2:
                                                _mood = "Disgusted";
                                              case 3:
                                                _mood = "Angry";
                                              case 4:
                                                _mood = "Sad";
                                              case 5:
                                                _mood = "Happy";
                                              default:
                                                _mood = "No mood";
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Okay'),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      //add data to the database
                                      if (_userGames != null &&
                                          _selectedItem != null) {
                                        List<GameDetails> games =
                                            await _userGames!;
                                        GameDetails? selectedGame =
                                            games.firstWhere((game) =>
                                                game.id.toString() ==
                                                _selectedItem);
                                        List genres = selectedGame.genres;
                                        _sessionStatsService.addSession(
                                            _stopwatch.elapsedMilliseconds,
                                            _selectedItem!,
                                            _mood,
                                            genres,
                                            _startTime);
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          _startStopWatch();
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
