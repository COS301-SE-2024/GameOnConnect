import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/model/events_M/events_model.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart';

class EventInvitation extends StatelessWidget {
  final String inviter;
  final Event event;
  final EventsService _eventsService = EventsService();

  EventInvitation({super.key, required this.inviter, required this.event});

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
              event.name,
              style: const TextStyle(
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
                  _eventsService.joinEvent(event);
                }, 
                child: const Text('Accept')),
              FilledButton(
                onPressed: () {
                  _eventsService.declineEventInvitation(event);
                }, 
                child: const Text('Decline')),
              FilledButton(
                onPressed: () {
                  _eventsService.declineEventInvitation(event);
                  _eventsService.subscribeToEvent(event);
                }, 
                child: const Text('Stay notified')),
            ],
          )
        ],
      ),
    );
  }
}