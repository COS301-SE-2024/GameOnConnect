import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/model/events_M/events_model.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';

// ignore: must_be_immutable
class EventInvitation extends StatefulWidget {
  final String inviterId;
  final Event event;
  String inviterName = "";

  EventInvitation({super.key, required this.inviterId, required this.event});

  @override
  State<EventInvitation> createState() => _EventInvitationState();
}

class _EventInvitationState extends State<EventInvitation> {
  final EventsService _eventsService = EventsService();
  final ProfileService _profileService = ProfileService();

  @override
  void initState() {
    super.initState();
    _changeIdToName();
  }

  Future<void> _changeIdToName() async {
    String? inviterName =
        await _profileService.getProfileName(widget.inviterId);

    setState(() {
      widget.inviterName = inviterName!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ExpansionTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.inviterName} invited you to join',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(widget.event.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Description: ${widget.event.description}',
              ),
              Text(
                'Date: ${widget.event.startDate}',
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton(
                  onPressed: () {
                    _eventsService.joinEvent(widget.event);
                  },
                  child: const Text('Accept')),
              FilledButton(
                  onPressed: () {
                    _eventsService.declineEventInvitation(widget.event);
                  },
                  child: const Text('Decline')),
              FilledButton(
                  onPressed: () {
                    _eventsService.declineEventInvitation(widget.event);
                    _eventsService.subscribeToEvent(widget.event);
                  },
                  child: const Text('Stay notified')),
            ],
          )
        ],
      ),
    );
  }
}
