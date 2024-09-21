import 'package:flutter/material.dart';

class InviteUpdates extends StatefulWidget {
  const InviteUpdates({super.key});

  @override
  State<InviteUpdates> createState() => _InviteUpdatesState();
}

class _InviteUpdatesState extends State<InviteUpdates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite updates'),  
      ),
      body: Center(
        child: Text('Hello, World!'),  
      ),
    );
  }
}