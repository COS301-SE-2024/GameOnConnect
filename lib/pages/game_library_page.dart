import 'package:flutter/material.dart';

class GameLibrary extends StatelessWidget {
  const GameLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextField(
          decoration: InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              title: Text('Game 1'),
              subtitle: Text('This is a description of Game 1'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Game 2'),
              subtitle: Text('This is a description of Game 2'),
            ),
          ),
          Card(
            child: ListTile(
              title: Text('Game 3'),
              subtitle: Text('This is a description of Game 3'),
            ),
          ),
        ],
      ),
    );
  }
}