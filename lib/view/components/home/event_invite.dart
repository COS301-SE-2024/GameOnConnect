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
      widget.inviterName = inviterName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isWidgetVisible) {
      return Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          child: Expanded(
              child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                  title: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.calendar_month_rounded,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${widget.inviterName} invited you to join',
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.event.name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Description',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(widget.event.description,
                                  style: const TextStyle(fontSize: 12))
                            ],
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: const Alignment(-1, 0),
                            child:Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Date and time',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(widget.event.startDate.toIso8601String(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary))
                            ],
                          ),
                          ),
                          const SizedBox(height: 15),
                          FittedBox(child:Align( 
                              alignment: Alignment(0, 0),
                              child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                //accept
                                onTap: () {
                                  _eventsService
                                      .declineEventInvitation(widget.event);
                                  _eventsService.joinEvent(widget.event);
                                  setState(() {
                                    _isWidgetVisible = false;
                                  });
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Text('Yes',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface))),
                              ),
                              InkWell(
                                  //decline
                                  onTap: () {
                                    _eventsService
                                        .declineEventInvitation(widget.event);
                                    setState(() {
                                      _isWidgetVisible = false;
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: Text('No',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface)))),
                              InkWell(
                                  //stay notified
                                  onTap: () {
                                    _eventsService
                                        .declineEventInvitation(widget.event);
                                    _eventsService.subscribeToEvent(widget.event);
                                    setState(() {
                                      _isWidgetVisible = false;
                                    });
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                        borderRadius: BorderRadius.circular(7),
                                      ),
                                      child: const Text('Maybe',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          )))),
                            ],
                          )
                          ),
                          ),
                        ],
                      ),
                      ),
                  ]),
            ),
          )));
    } else {
      return const SizedBox(height: 0);
    }
  }
}
