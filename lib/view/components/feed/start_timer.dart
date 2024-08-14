import 'dart:async';
import 'package:flutter_emoji_feedback/gen/assets.gen.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/feed_S/timer_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';

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
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Text(
            _timerService.isRunning() ? 'Done playing?' : "Start playing",
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
                  _timerService.isRunning()
                      ? Row(
                          children: [
                            const Icon(
                              Icons.radio_button_checked,
                              color: Colors.red,
                            ),
                            const SizedBox(width: 10),
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
                              return const CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Text('No data found');
                            } else {
                              return DropdownButton<String>(
                                isDense: true,
                                underline: const SizedBox(),
                                hint: const Text('What are you playing?'),
                                items: snapshot.data!.map((GameDetails game) {
                                  return DropdownMenuItem<String>(
                                    value: game.id.toString(),
                                    child: Text(game.name),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  _timerService.setGame(newValue);
                                },
                              );
                            }
                          }),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                        backgroundColor: _timerService.isRunning()
                            ? Colors.red
                            : Theme.of(context).colorScheme.primary),
                    icon: _timerService.isRunning()
                        ? const Icon(Icons.stop, color: Colors.white)
                        : const Icon(Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        if (_timerService.isRunning()) {
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
