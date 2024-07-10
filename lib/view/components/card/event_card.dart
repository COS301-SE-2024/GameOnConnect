import 'package:flutter/material.dart';



class EventCardWidget extends StatefulWidget {
  const EventCardWidget({super.key});

  @override
  State<EventCardWidget> createState() => _EventCardWidgetState();
}

class _EventCardWidgetState extends State<EventCardWidget> {

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
                        'Clash Royale',
                        style:TextStyle(
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
                            '01/07/2024      |     07:30',
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
                'Tournament',
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
    );
  }
}
