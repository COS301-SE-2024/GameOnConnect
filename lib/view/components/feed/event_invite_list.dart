import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/model/events_M/events_model.dart';
import 'package:gameonconnect/view/components/feed/event_invite.dart';

class EventInvitesList extends StatefulWidget {
  const EventInvitesList({super.key});

  @override
  State<EventInvitesList> createState() => _EventInvitesListState();
}

class _EventInvitesListState extends State<EventInvitesList> {
  final EventsService _eventsService = EventsService();
  List<Event> _invitedEvents = [];

  @override
  void initState() {
    super.initState();
    fetchInvitedEvents();
  }

  Future<void> fetchInvitedEvents() async {
    List<Map<String, dynamic>> invitedEvents = await _eventsService.getInvitedEvents();

    setState(() {
      _invitedEvents = invitedEvents.map((e) => Event.fromMap(e, e['id'])).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: _invitedEvents.isEmpty ? Center(child: CircularProgressIndicator()) : 
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _invitedEvents.length,
              itemBuilder: (context, index) {
                return EventInvitation(inviter: _invitedEvents[index].creatorID, event: _invitedEvents[index]);
              },
            ),
          )
        ]     
      ),
    );
  }
}