import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import '../../../model/events_M/events_model.dart';

class ViewEventDetailsWidget extends StatefulWidget {
  final Event e;
  const ViewEventDetailsWidget({super.key,required this.e});
  @override
  State<ViewEventDetailsWidget> createState() => _ViewEventDetailsWidgetState();
}

class _ViewEventDetailsWidgetState extends State<ViewEventDetailsWidget> {
  late final Event e;
  @override
  void initState() {
    super.initState();
    e = widget.e;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      Image.asset(
                        'assets/default_images/default_image.jpg',
                        width: double.infinity,
                        height: 340,
                        fit: BoxFit.cover,
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.85, -1.24),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            child: IconButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.close_outlined),
                              color: Theme.of(context).colorScheme.secondary,
                            ),

                          ),
                        ),
                      ),
                    ]),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Text(
                        e.name,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 24,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
                      child: Text(
                        e.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Theme.of(context).colorScheme.surface,
                              offset: const Offset(
                                0.0,
                                1,
                              ),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Type of event:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              e.eventType,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 1, 24, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Theme.of(context).colorScheme.surface,
                              offset: const Offset(
                                0.0,
                                1,
                              ),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Starting at:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              '${e.startDate.day}/${e.startDate.month}/${e.startDate.year}   |  ${e.startDate.hour}:${e.startDate.minute}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 1, 24, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Theme.of(context).colorScheme.surface,
                              offset: const Offset(
                                0.0,
                                1,
                              ),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Ending at:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              '${e.endDate.day}/${e.endDate.month}/${e.startDate.year}   |  ${e.endDate.hour}:${e.endDate.minute}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(24, 1, 24, 0),
                      child: Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 0,
                              color: Theme.of(context).colorScheme.surface,
                              offset: const Offset(
                                0.0,
                                1,
                              ),
                            )
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '# Joined:',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Text(
                              Events().getAmountJoined(e).toString(),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                letterSpacing: 0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            color: Theme.of(context).colorScheme.surface,
                            offset: const Offset(
                              0.0,
                              2,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Flexible(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 4),
                              child: MaterialButton(
                                onPressed: (){
                                  Events().subscribeToEvent(e);
                                },
                                child:Text(
                                'Subscribe',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  color: Theme.of(context).colorScheme.surface,
                                  fontSize: 18,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                ),
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
          ],
        ),
      ),
    );
  }
}
