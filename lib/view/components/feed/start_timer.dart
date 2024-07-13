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
    return ExpansionTile(
      title: Text('Start playing'),
      children: <Widget>[
        DropdownButton<String>(
          value: _selectedItem,
          hint: Text('What are you playing?'),
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
        FilledButton(
          onPressed: () {
            setState(() {
              if (_isTiming) {
                _endTime = DateTime.now();
              } else {
                _startTime = DateTime.now();
              }
              _isTiming = !_isTiming;
            });
          },
          child: Text(_isTiming ? 'Stop' : 'Start'),
        ),
      ],
    );
  }
}
