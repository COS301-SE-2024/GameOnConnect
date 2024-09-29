import 'package:flutter/material.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';

class RequestContainer extends StatefulWidget {
  final String requester;
  final VoidCallback accept;
  final VoidCallback reject;

  const RequestContainer({
    super.key,
    required this.requester,
    required this.accept,
    required this.reject,
  });

  @override
  State<RequestContainer> createState() => _RequestContainerState();
}

class _RequestContainerState extends State<RequestContainer> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          10.pixelScale(context),
          10.pixelScale(context),
          10.pixelScale(context),
          10.pixelScale(context)),
      child: Container(
        padding: EdgeInsets.only(right: 5.pixelScale(context)),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        //child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 150.pixelScale(context),
              child: Text(
                '${widget.requester} wants to connect',
                textAlign: TextAlign.center,
                softWrap: true,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 30.pixelScale(context),
              width: 100.pixelScale(context),
              child: ElevatedButton.icon(
                onPressed: widget.accept,
                label: Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.pixelScale(context),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.pixelScale(context),
              width: 100.pixelScale(context),
              child: ElevatedButton.icon(
                onPressed: widget.reject,
                label: Text(
                  'Reject',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 14.pixelScale(context),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all<Color>(
                    Theme.of(context).colorScheme.primaryContainer,
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//WidgetStateProperty
