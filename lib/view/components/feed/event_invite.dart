import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class EventInvitation extends StatelessWidget {
  final String inviter;
  final String eventName;

  const EventInvitation({super.key, required this.inviter, required this.eventName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$inviter invited you to join',
              style: const TextStyle(
                fontWeight: FontWeight.bold
              )
            ),
            Text(
              eventName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green
              )
            )
          ],
        ),
        children: <Widget> [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                onPressed: () {
      
                }, 
                child: const Text('Accept')),
              FilledButton(
                onPressed: () {
      
                }, 
                child: const Text('Decline')),
              FilledButton(
                onPressed: () {
      
                }, 
                child: const Text('Stay notified')),
            ],
          )
        ],
      ),
    );
  }
}