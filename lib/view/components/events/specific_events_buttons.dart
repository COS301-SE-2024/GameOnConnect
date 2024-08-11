import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../../services/events_S/event_service.dart';
import '../../pages/events/edit_event_page.dart';


class SpecificEventsButtons extends StatefulWidget{
  final Event e;
  final bool isCreator;
  final String imageUrl;
  const SpecificEventsButtons({super.key,required this.e, required this.isCreator, required this.imageUrl});

  @override
  State<SpecificEventsButtons> createState() => _SpecificEventsButtons();
}

class _SpecificEventsButtons extends State<SpecificEventsButtons>{
  late Event e;
  late bool isCreator;
  late bool isJoined;
  late String imageUrl;
  @override
  void initState() {
    super.initState();
    e = widget.e;
    isCreator = widget.isCreator;
    isJoined = EventsService().isJoined(e);
    imageUrl = widget.imageUrl;
  }

  void getUpdatedEvent(String id) async {
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
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          12, 0, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment:
        MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 32.0),
                    child: Container(
                      width: 152,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isCreator
                            ? Theme.of(context)
                            .colorScheme
                            .primary
                            : isJoined
                            ? Theme.of(context)
                            .colorScheme
                            .secondary
                            : Theme.of(context)
                            .colorScheme
                            .primary,
                        borderRadius:
                        BorderRadius.circular(50),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          if (isCreator) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditEvent(
                                            e: e,
                                            imageUrl:
                                            imageUrl)));
                          }
                          if (!isJoined) {
                            EventsService()
                                .joinEvent(e);
                            getUpdatedEvent(
                                e.eventID);
                            isJoined = true;
                          }
                        },
                        child: Text(
                          isCreator
                              ? 'Edit'
                              : isJoined
                              ? 'Joined'
                              : 'Join',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .surface,
                            fontSize: 12,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 152,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface,
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary),
                      borderRadius:
                      BorderRadius.circular(50),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        //do nothing for now
                      },
                      child: Text(
                        'Add to Calendar',
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  }