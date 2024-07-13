import 'package:flutter/material.dart';

class GameTimer extends StatefulWidget {
  const GameTimer({super.key});

  @override
  _GameTimer createState() => _GameTimer();
}

class _GameTimer extends State<GameTimer> {
  final List<String> _dropdownItems = ['Game 1', 'Game 2', 'Game 3'];
  String? _selectedItem;
  bool _isTiming = false;

  static DateTime? _startTime;
  static DateTime? _endTime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 241, 241, 241),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            title: const Text(
              'Start playing',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(Icons.videogame_asset),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton<String>(
                    value: _selectedItem,
                    hint: const Text('What are you playing?'),
                    items: _dropdownItems.map((String value) {
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
                  ),
                  FilledButton.icon(
                    icon: _isTiming ?  const Icon(Icons.stop) : const Icon(Icons.play_arrow),
                    style: FilledButton.styleFrom(
                      backgroundColor: _isTiming ? Colors.red : Theme.of(context).primaryColor,
                      padding: const EdgeInsets.only(left: 25, top: 15, right: 25, bottom: 15),
                    ),
                    onPressed: () {
                      setState(() {
                        if (_isTiming) {
                          _endTime = DateTime.now();
                          print("Total time was: ${_endTime!.difference(_startTime!).inHours} hours ${_endTime!.difference(_startTime!).inMinutes} minutes ${_endTime!.difference(_startTime!).inSeconds} seconds");
                        } else {
                          _startTime = DateTime.now();
                        }
                        _isTiming = !_isTiming;
                      });
                    },
                    label: Text(_isTiming ? 'Stop' : 'Start'),
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
