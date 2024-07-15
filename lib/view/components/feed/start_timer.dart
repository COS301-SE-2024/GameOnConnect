import 'dart:async';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GameTimer createState() => _GameTimer();
}

class _GameTimer extends State<GameTimer> {
  final MyGamesService _currentlyPlaying = MyGamesService();
  Future<List<String>>? _userGames;
  String? _selectedItem;
  static final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _userGames = _currentlyPlaying.getMyGames();
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  void _startStopWatch() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
      });
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer?.cancel();
  }

  String _formatElapsedTime() {
    final int hours = _stopwatch.elapsed.inHours;
    final int minutes = (_stopwatch.elapsed.inMinutes % 60);
    final int seconds = (_stopwatch.elapsed.inSeconds % 60);
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 241, 241, 241),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _stopwatch.isRunning ? 
                  Row(
                    children: [
                      const Icon(Icons.radio_button_checked, color: Colors.red,),
                      const SizedBox(width: 10),
                      Text(
                        _formatElapsedTime(),
                        style: const TextStyle(color: Colors.red),
                      )
                    ],
                  ) 
                  : 
                  FutureBuilder<List<String>>(
                    future: _userGames, 
                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No data found');
                      } else {
                        return 
                        DropdownButton<String>(
                          underline: const SizedBox(),
                          value: _selectedItem,
                          hint: const Text('What are you playing?'),
                          items: snapshot.data!.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedItem = newValue;
                            });
                          },
                        );
                      }
                    }
                  ),
                  FilledButton.icon(
                    icon: _stopwatch.isRunning
                        ? const Icon(Icons.stop)
                        : const Icon(Icons.play_arrow),
                    style: FilledButton.styleFrom(
                      backgroundColor: _stopwatch.isRunning
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      padding: const EdgeInsets.only(
                          left: 25, top: 15, right: 25, bottom: 15),
                    ),
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
                                        inactiveElementBlendColor: Theme.of(context).colorScheme.surface,
                                        onChanged: (value) {
                                          //add value to db
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('Don''t ask me now'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
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
                    label: Text(_stopwatch.isRunning ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
