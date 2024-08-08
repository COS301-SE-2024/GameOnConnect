import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/create_event/specific_event_info_container.dart';
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
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 13, 0, 0),
                                child: CachedNetworkImage(
                                  height: 340,
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
                                  placeholder: (context, url) => const Center(
                                      child:
                                          CircularProgressIndicator()), // Loading indicator for banner
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Align(
                                alignment: const AlignmentDirectional(-0.9, -1),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 21, 0, 0),
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    child: IconButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                      },
                                      icon:
                                          const Icon(Icons.keyboard_backspace),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                            Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Flexible(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 0, 0, 0),
                                                child: Text(
                                                  e.name,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 20,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const Spacer(),
                                              !isCreator
                                                  ? IconButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          !selected;
                                                        });
                                                        if (selected) {
                                                          EventsService()
                                                              .unsubscribeToEvent(
                                                                  e);
                                                        } else {
                                                          EventsService()
                                                              .subscribeToEvent(
                                                                  e);
                                                        }
                                                        getUpdatedEvent(
                                                            e.eventID);
                                                      },
                                                      icon: selected
                                                          ? Icon(
                                                              Icons
                                                                  .notifications,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary,
                                                              size: 24,
                                                            )
                                                          : Icon(
                                                              Icons
                                                                  .notification_add_outlined,
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .primary))
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            12, 0, 0, 6),
                                    child: Text(
                                      //TODO : get user name to display
                                      "username",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            //TODO: fix the coloring of the text
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 6, 12, 19),
                                  child: Text(
                                    "Saturday, 9 July 2024, 10 AM SAST",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                                  )),
                            ),
                            Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              indent: 12,
                              endIndent: 12,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 19, 12, 19),
                                child: Text(
                                  e.description,
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
                            ),
                            SpecificEventInfoContainer(
                                startInfo: "Event type", endInfo: e.eventType),
                            SpecificEventInfoContainer(
                              startInfo: "Participants",
                              endInfo:
                                  EventsService().getAmountJoined(e).toString(),
                            ),
                            SpecificEventInfoContainer(
                                startInfo: "Starting at",
                                endInfo: e.startDate.toString()),
                            SpecificEventInfoContainer(
                                startInfo: "Ending at",
                                endInfo: e.endDate.toString()),
                            SpecificEventInfoContainer(
                                startInfo: "Visibility",
                                endInfo: e.privacy ? "Public" : "Private"),
                            const SizedBox(
                              height: 36,
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  12, 0, 12, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                   Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(padding: EdgeInsets.only(right: 32.0),child:
                                            Container(
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
                                                borderRadius: BorderRadius.circular(50),
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
                                                  EventsService().joinEvent(e);
                                                  getUpdatedEvent(e.eventID);
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
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            ),
                                            ),
                                Container(
                                  width: 152,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color:
                                    Theme.of(context)
                                        .colorScheme
                                        .surface,
                                    border: Border.all(color: Theme.of(context).colorScheme.primary),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                            child:
                                            MaterialButton(
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
