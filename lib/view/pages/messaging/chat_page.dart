import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String ProfileName;
  const ChatPage({
    super.key,
    required this.ProfileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(ProfileName),
      ),
    );
  }
}
