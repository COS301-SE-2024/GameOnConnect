import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../../model/events_M/events_model.dart';
import 'edit_event_page.dart';

class ViewEventDetailsWidget extends StatefulWidget {
  final Event e;
  const ViewEventDetailsWidget({super.key, required this.e});
  @override
  State<ViewEventDetailsWidget> createState() => _ViewEventDetailsWidgetState();
}

class _ViewEventDetailsWidgetState extends State<ViewEventDetailsWidget> {
  late Event e;
  late String imageUrl;
  late bool selected;
  late bool isJoined;
  late bool isCreator;
  @override
  void initState() {
    super.initState();
    e = widget.e;
  }

  void getImage(String id) async {
    imageUrl = await EventsService().getEventImage(e.eventID);
  }

  void getUpdatedEvent(String id) async{
    Event updated = (await EventsService().getEvent(id))!;
    setState(() {
      e = updated;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: EventsService().getEventImage(e.eventID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            imageUrl = snapshot.data!;
            selected = EventsService().isSubscribed(e);
            isJoined = EventsService().isJoined(e);
            isCreator = EventsService().isCreator(e);
            return GestureDetector(
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.surface,
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(children: [
                              Image.network(
                                imageUrl,
                                width: double.infinity,
                                height: 340,
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment:
                                    const AlignmentDirectional(0.85, -1.24),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 50, 0, 0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    child: IconButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close_outlined),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 20, 0, 0),
                                        child: Text(
                                          e.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 24,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              !selected;
                                            });
                                            if (selected) {
                                              EventsService().unsubscribeToEvent(e);
                                            } else {
                                              EventsService().subscribeToEvent(e);
                                            }
                                            getUpdatedEvent(e.eventID);
                                          },
                                          icon: selected
                                              ? const Icon(Icons.notifications)
                                              : const Icon(Icons
                                                  .notification_add_outlined)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 8, 24, 0),
                              child: Text(
                                e.description,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 16, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      offset: const Offset(
                                        0.0,
                                        1,
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Type of event:',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      e.eventType,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 1, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      offset: const Offset(
                                        0.0,
                                        1,
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Starting at:',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${e.startDate.day}/${e.startDate.month}/${e.startDate.year}   |  ${e.startDate.hour}:${e.startDate.minute}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 1, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      offset: const Offset(
                                        0.0,
                                        1,
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Ending at:',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${e.endDate.day}/${e.endDate.month}/${e.startDate.year}   |  ${e.endDate.hour}:${e.endDate.minute}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  24, 1, 24, 0),
                              child: Container(
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 0,
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      offset: const Offset(
                                        0.0,
                                        1,
                                      ),
                                    )
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '# Joined:',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 16,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      EventsService().getAmountJoined(e).toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isCreator
                                    ? Theme.of(context).colorScheme.primary
                                    : isJoined
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Theme.of(context).colorScheme.primary,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 5,
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    offset: const Offset(
                                      0.0,
                                      2,
                                    ),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(0),
                              ),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 4),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if(isCreator){
                                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  EditEvent(e: e,imageUrl: imageUrl)));
                                            }
                                            if (!isJoined) {
                                              EventsService().joinEvent(e);
                                              getUpdatedEvent(e.eventID);
                                              isJoined = true;
                                            }

                                          },
                                          child: Text(
                                            isCreator
                                                ? 'Edit event'
                                                : isJoined
                                                    ? 'Joined event!'
                                                    : 'Join event',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontSize: 18,
                                              letterSpacing: 0,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
