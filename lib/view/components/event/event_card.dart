import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../pages/events/specific_event_details.dart';
import '../../../services/events_S/event_service.dart';

class EventCardWidget extends StatefulWidget {
  final Event e;

  @override
  State<EventCardWidget> createState() => EventCard();

  const EventCardWidget({super.key, required this.e});
}

class EventCard extends State<EventCardWidget> {
  late Event e;
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    e = widget.e;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getEvent() async {
    Event? updated = await EventsService().getEvent(e.eventID);
    setState(() {
      e = updated!;
    });
  }

  Future<void> getImage(Event e) async {
    imageUrl = await EventsService().getEventImage(e.eventID);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImage(e),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewEventDetailsWidget(e: e)));
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
                  child: Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 90,
                            child: CachedNetworkImage(
                              height: 100,
                              width: double.infinity,
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child:
                                      CircularProgressIndicator()), // Loading indicator for banner
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 0, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color:Theme.of(context).brightness == Brightness.light
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  Expanded(
                                    child:  Text(
                                        '${e.startDate.year}/${e.startDate.month}/${e.startDate.day} at ${e.startDate.hour}:${e.startDate.minute}',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).brightness == Brightness.light
                                              ? Colors.black
                                              : Colors.white,
                                          fontSize: 14,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  Icon(e.eventType == "Gaming Session"
                                      ? CupertinoIcons.game_controller
                                      : Icons.emoji_events_outlined,
                                  color: Theme.of(context).brightness == Brightness.light
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context).colorScheme.primary,),
                                ],
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }
        });
  }
}
