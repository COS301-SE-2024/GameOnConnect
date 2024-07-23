import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/model/events_M/events_model.dart';
import 'package:gameonconnect/view/components/feed/event_invite.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';

class EventInvitesList extends StatefulWidget {
  const EventInvitesList({super.key});

  @override
  State<EventInvitesList> createState() => _EventInvitesListState();
}

class _EventInvitesListState extends State<EventInvitesList> {
  final EventsService _eventsService = EventsService();
  final ProfileService _profileService = ProfileService();
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
      child: _invitedEvents.isEmpty ? const Text('No new event invites') : 
      Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _invitedEvents.length,
              itemBuilder: (context, index) {
                return EventInvitation(inviterId: _invitedEvents[index].creatorID, event: _invitedEvents[index]);
              },
            ),
          )
        ]     
      ),
    );
  }
}