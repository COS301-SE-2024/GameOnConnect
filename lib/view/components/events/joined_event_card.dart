import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/view/pages/events/specific_event_details.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../model/events_M/events_model.dart';
import '../../../services/events_S/event_service.dart';

class UpcomingEventCardWidget extends StatefulWidget {
  final Event? e;

  const UpcomingEventCardWidget({
    super.key,
    required this.e,
  });

  @override
  State<UpcomingEventCardWidget> createState() =>
      _UpcomingEventCardWidgetState();
}

class _UpcomingEventCardWidgetState extends State<UpcomingEventCardWidget> {
  late Event e;
  late String imageUrl;
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
    e = widget.e!;
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
                size: 36.pixelScale(context),
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            imageUrl = snapshot.data!;
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewEventDetailsWidget(e: e)));
              },
              child: Padding(
                padding:  EdgeInsetsDirectional.fromSTEB(0, 0, 12.pixelScale(context), 0),
                child: Container(
                  width: 147.pixelScale(context),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(12.pixelScale(context)),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2,
                          color: Theme.of(context).colorScheme.surface,
                          offset: const Offset(
                            0,
                            1,
                          ),
                        )
                      ]),
                  child: Padding(
                    padding:  EdgeInsetsDirectional.fromSTEB(
                        11.61.pixelScale(context), 11.61.pixelScale(context), 11.61.pixelScale(context), 11.61.pixelScale(context)),
                    child: Flex(direction: Axis.horizontal,children: [Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:  EdgeInsets.fromLTRB(2.pixelScale(context), 0, 2.pixelScale(context), 6.pixelScale(context)),
                            child: CachedNetworkImage(
                              height: 83.65.pixelScale(context),
                              width: double.infinity,
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(12.pixelScale(context)),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) => Center(
                                  child: LoadingAnimationWidget.halfTriangleDot(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 36.pixelScale(context),
                                  ),
                                ), // Loading indicator for banner
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Text(
                            widget.e!.name,
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 16.pixelScale(context),
                              letterSpacing: 0,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Text(DateFormat('EEE, MM/d/y @\nkk:mm').format(e.startDate),
                              style:  TextStyle(
                                color: Colors.grey,
                                fontSize: 14.pixelScale(context),
                                letterSpacing: 0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            size: 24.pixelScale(context),
                            e.eventType == "Gaming Session"
                                ? CupertinoIcons.game_controller
                                : Icons.emoji_events_outlined,
                            color: Theme.of(context).brightness ==
                                    Brightness.light
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
