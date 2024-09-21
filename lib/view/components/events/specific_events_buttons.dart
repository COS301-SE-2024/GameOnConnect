import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../../services/events_S/event_service.dart';
import '../../pages/events/edit_event_page.dart';

class SpecificEventsButtons extends StatefulWidget {
  final Event e;
  final bool isCreator;
  final String imageUrl;
  final void Function(Event updatedEvent) edited;

  const SpecificEventsButtons(
      {super.key,
      required this.e,
      required this.isCreator,
      required this.imageUrl,
      required this.edited});

  @override
  State<SpecificEventsButtons> createState() => _SpecificEventsButtons();
}

class _SpecificEventsButtons extends State<SpecificEventsButtons> {
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
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: isJoined
                    ? BorderSide(color: Theme.of(context).colorScheme.primary)
                    : BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              color: isCreator
                  ? Theme.of(context).colorScheme.primary
                  : isJoined
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.primary,
              height: 36,
              onPressed: () {
                if (isCreator) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditEvent(
                              e: e,
                              imageUrl: imageUrl,
                              edited: (updated) {
                                setState(() {
                                  e = updated;
                                  widget.edited(e);
                                });
                              })));
                }
                if (!isJoined) {
                  EventsService().joinEvent(e);
                  getUpdatedEvent(e.eventID);
                  isJoined = true;
                }else{
                  EventsService().leaveEvent(e);
                  getUpdatedEvent(e.eventID);
                  isJoined= false;
                }
              },
              child: Text(
                isCreator
                    ? 'Edit'
                    : isJoined
                        ? 'Leave'
                        : 'Join',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          /*Container(
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
                  ),*/
        ],
      ),
    );
  }
}
