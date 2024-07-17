import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentuser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentuser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCurrentuser ? Theme.of(context).colorScheme.primary : Color.fromARGB(255, 107, 188, 255),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 25),
      child: Text(message),
    );
  }
}
