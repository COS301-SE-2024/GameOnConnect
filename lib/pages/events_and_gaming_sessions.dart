// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class EventsGamingSessions extends StatelessWidget {
  const EventsGamingSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events and Gaming Sessions'),
      ),
      body: Center(
        child: Text('Create Events or Gaming Sessions'),
      ),
    );
  }
}
