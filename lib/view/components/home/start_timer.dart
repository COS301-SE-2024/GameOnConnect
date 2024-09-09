import 'dart:async';
import 'package:flutter_emoji_feedback/gen/assets.gen.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/feed_S/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameTimer createState() => _GameTimer();
}

class _GameTimer extends State<GameTimer> {
  final ProfileService _profileService = ProfileService();
  final TimerService _timerService = TimerService();
  Future<List<GameDetails>>? _userGames;
  Timer? _timer;
  String _mood = "No mood";
  String? _selectedGameName;

  @override
  void initState() {
    super.initState();
    _userGames = _timerService.fetchUserGames();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _startStopWatch() {
    _timerService.resetTimer();
    _timerService.startTimer(() {
      setState(() {});
    });
  }

  void _stopStopwatch() {
    _timerService.stopTimer();
    _profileService.setCurrentlyPlaying("");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.028),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            _timerService.isRunning() ? 'Done playing?' : "Start playing",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: const Icon(Icons.videogame_asset),
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.028),
              child: Row(
                children: [
                  _timerService.isRunning()
                      ? Row(
                          children: [
                            Icon(
                              Icons.radio_button_checked,
                              color: Colors.red,
                              size: MediaQuery.of(context).size.width * 0.067,
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.01),
                            ValueListenableBuilder<String>(
                              valueListenable: _timerService.elapsedTime,
                              builder: (context, value, child) {
                                return Text(
                                  value,
                                  style: const TextStyle(color: Colors.red),
                                );
                              },
                            ),
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
                                hint: Text(
                                  _selectedGameName ?? 'What are you playing?',
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.05),
                                ),
                                items: snapshot.data!.map((GameDetails game) {
                                  return DropdownMenuItem<String>(
                                    value: game.id.toString(),
                                    child: Text(game.name,
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                        )),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    final selectedGame = snapshot.data!
                                        .firstWhere((game) =>
                                            game.id.toString() == newValue);
                                    _selectedGameName = selectedGame.name;
                                    _timerService.setGame(newValue);
                                  });
                                },
                              );
                            }
                          }),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: _timerService.isRunning()
                            ? Colors.red
                            : !_timerService.isGameSelected()
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                    icon: _timerService.isRunning()
                        ? Icon(
                            Icons.stop,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.067,
                          )
                        : Icon(Icons.play_arrow,
                            color: Colors.white,
                            size: MediaQuery.of(context).size.width * 0.067),
                    onPressed: !_timerService.isGameSelected()
                        ? null
                        : () {
                            setState(() {
                              if (_timerService.isRunning()) {
                                _stopStopwatch();
                                //show emoji feedback
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    int? selectedRating = 1;
                                    return AlertDialog(
                                      title: Text(
                                          'How was your experience playing this game?',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.03,
                                              fontWeight: FontWeight.bold)),
                                      content: StatefulBuilder(builder:
                                          (context,
                                              StateSetter setDialogState) {
                                        return SizedBox(
                                          width: double.maxFinite,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              EmojiFeedback(
                                                rating: selectedRating,
                                                enableFeedback: true,
                                                emojiPreset: const [
                                                  EmojiModel(
                                                    src: Assets.classicTerrible,
                                                    label: 'Scared',
                                                    package:
                                                        'flutter_emoji_feedback',
                                                  ),
                                                  EmojiModel(
                                                    src: Assets.classicBad,
                                                    label: 'Disgusted',
                                                    package:
                                                        'flutter_emoji_feedback',
                                                  ),
                                                  EmojiModel(
                                                    src: Assets.flatTerrible,
                                                    label: 'Angry',
                                                    package:
                                                        'flutter_emoji_feedback',
                                                  ),
                                                  EmojiModel(
                                                    src: Assets.flatBad,
                                                    label: 'Sad',
                                                    package:
                                                        'flutter_emoji_feedback',
                                                  ),
                                                  EmojiModel(
                                                    src: Assets.flatVeryGood,
                                                    label: 'Happy',
                                                    package:
                                                        'flutter_emoji_feedback',
                                                  )
                                                ],
                                                inactiveElementBlendColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .surface,
                                                onChanged: (value) {
                                                  setDialogState(() {
                                                    selectedRating = value;
                                                    switch (value) {
                                                      case 1:
                                                        _mood = "Scared";
                                                        break;
                                                      case 2:
                                                        _mood = "Disgusted";
                                                        break;
                                                      case 3:
                                                        _mood = "Angry";
                                                        break;
                                                      case 4:
                                                        _mood = "Sad";
                                                        break;
                                                      case 5:
                                                        _mood = "Happy";
                                                        break;
                                                      default:
                                                        _mood = "No mood";
                                                    }
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            _timerService.addSession(_mood);
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
