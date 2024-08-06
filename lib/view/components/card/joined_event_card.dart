
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/events/specific_event_details.dart';
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
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else  {
            imageUrl = snapshot.data!;
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewEventDetailsWidget(e: e)));
              },
              child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SizedBox(

                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(blurRadius: 2,
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      offset: const Offset(
                        0,
                        5,
                      ),)]
                    ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CachedNetworkImage(
                                  height: 84,
                                  width: double.infinity,
                                  imageUrl: imageUrl,
                                  placeholder: (context, url) => const Center(
                                      child:
                                          CircularProgressIndicator()), // Loading indicator for banner
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                                Text(
                                  'Upcoming: ${widget.e?.name}',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                    child: Text(
                                      '${widget.e?.startDate.day}/${widget.e?.startDate.month}/${widget.e?.startDate.year}\n${widget.e?.startDate.hour}:${widget.e?.startDate.minute}',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 14,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                  ),
              ),
            );
          }
        });
  }
}
