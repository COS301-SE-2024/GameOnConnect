import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../pages/events/specific_event_details.dart';

class EventCardWidget extends StatelessWidget {
  final Event? e;

  const EventCardWidget({
    super.key,
    required this.e
});
  @override
  Widget build(BuildContext context) {
      return InkWell( onTap: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ViewEventDetailsWidget(e: e!)));
    },child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 1),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 0, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e!.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            '${e!.startDate.day}/${e!.startDate.month}/${e!.startDate.year}      |     ${e!.startDate.hour}:${e!.startDate.minute}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Theme.of(context).colorScheme.secondary,
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
              Text(
                e!.eventType,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    )
      );
  }
}
