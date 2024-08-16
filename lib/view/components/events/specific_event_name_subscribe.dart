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
      selected = EventsService().isSubscribed(e);

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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
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
          Container(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
            child: !isCreator
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        selected = !selected;
                      });
                      if (!selected) {
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
    );
  }
}
