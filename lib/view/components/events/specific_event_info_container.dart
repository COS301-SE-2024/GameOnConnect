import 'package:flutter/material.dart';

class SpecificEventInfoContainer extends StatefulWidget{
  final String startInfo;
  final String endInfo;
  const SpecificEventInfoContainer({super.key, required this.startInfo, required this.endInfo});

  @override
  State<SpecificEventInfoContainer> createState() => _InfoContainer();
}

class _InfoContainer extends State<SpecificEventInfoContainer>{
  late String startInfo;
  late String endInfo;

  @override
  void initState() {
    super.initState();
    startInfo = widget.startInfo;
    endInfo = widget.endInfo;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column( children:[Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
          12, 0, 12, 0),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                startInfo,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light?Colors.black:Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(
              endInfo,
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .secondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),

      ),
    ),
      Divider(
        indent: 12,
        endIndent: 12,
        color: Theme.of(context).colorScheme.primaryContainer,
      )
    ]
    );
  }
}