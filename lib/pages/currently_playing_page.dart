// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class CurrentlyPlayingPage extends StatelessWidget {
  const CurrentlyPlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currently Playing'),
      ),
      body: Center(
        child: Text('Currently Playing Page'),
      ),
    );
  }
}
