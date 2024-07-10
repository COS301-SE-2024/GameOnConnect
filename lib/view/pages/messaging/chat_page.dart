import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String profileName;
  const ChatPage({
    super.key,
    required this.profileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(profileName),
      ),
    );
  }
}
