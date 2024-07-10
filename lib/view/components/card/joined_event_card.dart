import 'package:flutter/material.dart';


class UpcomingEventCardWidget extends StatefulWidget {
  const UpcomingEventCardWidget({super.key});

  @override
  State<UpcomingEventCardWidget> createState() =>
      _UpcomingEventCardWidgetState();
}

class _UpcomingEventCardWidgetState extends State<UpcomingEventCardWidget> {

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                        'Upcoming: Clash of Clans',
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
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                          child: Text(
                            '01/07/2024\n07:30',
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
    );
  }
}
