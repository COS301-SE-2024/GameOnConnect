import 'package:flutter/material.dart';

import '../../../model/events_M/events_model.dart';
import '../../../services/events_S/event_service.dart';

class SpecificEventNameSubscribe extends StatefulWidget {
  final Event e;
  final bool isCreator;
  const SpecificEventNameSubscribe(
      {super.key, required this.e, required this.isCreator});

  @override
  State<SpecificEventNameSubscribe> createState() =>
      _SpecificEventNameSubscribe();
}

class _SpecificEventNameSubscribe extends State<SpecificEventNameSubscribe> {
  late Event e;
  late bool isCreator;
  late bool selected;
  void getUpdatedEvent(String id) async {
    Event updated = (await EventsService().getEvent(id))!;
    setState(() {
      e = updated;
    });
  }

  @override
  void initState() {
    super.initState();
    e = widget.e;
    isCreator = widget.isCreator;
    selected = EventsService().isSubscribed(widget.e);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: const Alignment(-1, -1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              child: Align(
                alignment: const Alignment(-1, 0),
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 19, 12, 0),
                  child: Text(
                    e.name,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 20,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                  child: !isCreator
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              selected = !selected;
                            });
                            if (selected) {
                              EventsService().unsubscribeToEvent(e);
                            } else {
                              EventsService().subscribeToEvent(e);
                            }
                            getUpdatedEvent(e.eventID);
                          },
                          icon: selected
                              ? Icon(
                                  Icons.notifications,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Theme.of(context).colorScheme.primary,
                                  size: 24,
                                )
                              : Icon(Icons.notification_add_outlined,
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.black
                                      : Theme.of(context).colorScheme.primary))
                      : const SizedBox(),
                ),
              ],
            ),
          ],
        ));
  }
}
