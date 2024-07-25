import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentuser;
  final Timestamp time;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentuser,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = time.toDate();
    return Container(
      decoration: BoxDecoration(
        color: isCurrentuser
            ? Theme.of(context).colorScheme.primary
            : const Color.fromARGB(255, 107, 188, 255),
        borderRadius: BorderRadius.circular(17),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
        children: [
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.bold
            ),
          ),
          Text(
            DateFormat('yyyy/MM/dd – kk:mm').format(dateTime),
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
