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
  bool _isWidgetVisible = true;

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
    if (_isWidgetVisible) {
      return Padding(
        padding: const EdgeInsets.all(15),
        child: Expanded(
          child: Container(
            padding: const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 5),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 243, 243, 243),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.calendar_month_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.inviterName} invited you to join',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.event.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
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
                      InkWell(
                        //accept
                        onTap: () {
                          _eventsService.declineEventInvitation(widget.event);
                          _eventsService.joinEvent(widget.event);
                          setState(() {
                            _isWidgetVisible = false;
                          });
                        },
                        child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            width: 85,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: const Text('Accept',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ))),
                      ),
                      InkWell(
                          //decline
                          onTap: () {
                            _eventsService.declineEventInvitation(widget.event);
                            setState(() {
                              _isWidgetVisible = false;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 85,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Text('Decline',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  )))),
                      InkWell(
                          //stay notified
                          onTap: () {
                            _eventsService.declineEventInvitation(widget.event);
                            _eventsService.subscribeToEvent(widget.event);
                            setState(() {
                              _isWidgetVisible = false;
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: 30,
                              width: 85,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).colorScheme.primary),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: const Text('Stay notified',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  )))),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox(height: 0);
    }
  }
}
