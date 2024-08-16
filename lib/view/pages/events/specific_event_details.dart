//ignore_for_file:  prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/events/specific_event_info_container.dart';
import 'package:gameonconnect/view/components/events/specific_events_buttons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../model/events_M/events_model.dart';
import '../../components/events/specific_event_name_subscribe.dart';

class ViewEventDetailsWidget extends StatefulWidget {
  final Event e;
  const ViewEventDetailsWidget({
    super.key,
    required this.e,
  });
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
    return FutureBuilder(
        future: EventsService().getEventImage(e.eventID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            String timezone = e.startDate.timeZoneName;
            imageUrl = snapshot.data!;
            isCreator = EventsService().isCreator(e);
            return GestureDetector(
                child: Scaffold(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    body: Column(mainAxisSize: MainAxisSize.max, children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Stack(children: [
                                //event image:
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 13, 0, 0),
                                  child: CachedNetworkImage(
                                    height: 213,
                                    width: double.infinity,
                                    imageUrl: imageUrl,
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(0),
                                              topRight: Radius.circular(0),
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15)),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover)),
                                    ),
                                    placeholder: (context, url) => Center(
                                      child: LoadingAnimationWidget
                                          .halfTriangleDot(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 36,
                                      ),
                                    ), // Loading indicator for banner
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                //back button:
                                Align(
                                  alignment:
                                      const AlignmentDirectional(-0.9, -1),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 21, 0, 0),
                                    child: CircleAvatar(
                                      radius: 20,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.surface,
                                      child: IconButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                            Icons.keyboard_backspace),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              SpecificEventNameSubscribe(
                                  e: e, isCreator: isCreator,),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 0),
                                  child: Text(
                                    isCreator ? "You" : e.creatorName,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 12, 19),
                                    child: Text(
                                      DateFormat('EEE, y/MM/d, kk:mm')
                                              .format(e.startDate) +
                                          ' ' +
                                          timezone,
                                      // "Saturday, 9 July 2024, 10 AM SAST",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black
                                            : Colors.white,
                                      ),
                                    )),
                              ),
                              Divider(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                indent: 12,
                                endIndent: 12,
                              ),
                              e.description == ""
                                  ? const SizedBox()
                                  : Align(
                                      alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(12, 19, 12, 19),
                                        child: Text(
                                          e.description,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                              SpecificEventInfoContainer(
                                  startInfo: "Event type",
                                  endInfo: e.eventType),
                              SpecificEventInfoContainer(
                                startInfo: "Participants",
                                endInfo: EventsService()
                                    .getAmountJoined(e)
                                    .toString(),
                              ),
                              SpecificEventInfoContainer(
                                startInfo: "Starting at",
                                endInfo: DateFormat('EEE, y/MM/d, kk:mm')
                                        .format(e.startDate) +
                                    ' \n' +
                                    timezone,
                              ),
                              SpecificEventInfoContainer(
                                startInfo: "Ending at",
                                endInfo: DateFormat('EEE, y/MM/d, kk:mm')
                                        .format(e.endDate) +
                                    ' \n' +
                                    timezone,
                              ),
                              SpecificEventInfoContainer(
                                  startInfo: "Visibility",
                                  endInfo: e.privacy ? "Private": "Public"),
                              const SizedBox(
                                height: 36,
                              ),
                              SpecificEventsButtons(
                                  e: e,
                                  isCreator: isCreator,
                                  imageUrl: imageUrl)
                            ],
                          ),
                        ),
                      )
                    ])));
          }
        });
  }
}
