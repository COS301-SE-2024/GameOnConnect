import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/model/events_M/events_model.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/home/event_invite.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class EventInvitesList extends StatefulWidget {
  const EventInvitesList({super.key});

  @override
  State<EventInvitesList> createState() => _EventInvitesListState();
}

class _EventInvitesListState extends State<EventInvitesList> {
  final EventsService _eventsService = EventsService();
  List<Event> _invitedEvents = [];
  bool _isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    fetchInvitedEvents();
  }

  Future<void> fetchInvitedEvents() async {
    List<Map<String, dynamic>> invitedEvents =
        await _eventsService.getInvitedEvents();

    setState(() {
      _invitedEvents =
          invitedEvents.map((e) => Event.fromMap(e, e['id'])).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackButtonAppBar(
                title: 'Event Invites',
                onBackButtonPressed: () {
                  Navigator.pop(context);
                },
                iconkey: const Key('Back_button_key'),
                textkey: const Key('event_invites__text')),
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            )
          : _invitedEvents.isEmpty
              ? Container(
                  height: 100,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("No new event \ninvites :(",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                        SvgPicture.asset(
                          'assets/icons/sad_icon.svg',
                          height: 75,
                          fit: BoxFit.contain,
                        )
                      ]))
              : ListView.builder(
                  itemCount: _invitedEvents.length,
                  itemBuilder: (context, index) {
                    return EventInvitation(
                        inviterId: _invitedEvents[index].creatorID,
                        event: _invitedEvents[index]);
                  },
                ),
    );
  }
}