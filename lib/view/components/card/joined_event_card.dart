import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/events/specific_event_details.dart';
import '../../../model/events_M/events_model.dart';

class UpcomingEventCardWidget extends StatefulWidget {
   final Event? e;

  const UpcomingEventCardWidget({super.key , required this.e});

  @override
  State<UpcomingEventCardWidget> createState() =>
      _UpcomingEventCardWidgetState();
}

class _UpcomingEventCardWidgetState extends State<UpcomingEventCardWidget> {
  late Event e;
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
    return InkWell( onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewEventDetailsWidget(e: e)));
    },
      child:Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        width: double.infinity,
        height: 155,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: BoxShape.rectangle,
          borderRadius:  BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Upcoming: ${widget.e?.name}',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            '${widget.e?.startDate.day}/${widget.e?.startDate.month}/${widget.e?.startDate.year}\n${widget.e?.startDate.hour}:${widget.e?.startDate.minute}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color:
                              Theme.of(context).colorScheme.secondary,
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
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
