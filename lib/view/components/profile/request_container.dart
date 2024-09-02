import 'package:flutter/material.dart';

class RequestContainer extends StatefulWidget {
  final String requester;
  final VoidCallback accept;
  final VoidCallback reject;

  const RequestContainer({super.key, 
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
  isDarkMode=Theme.of(context).brightness == Brightness.dark;
    return Container(
  padding: const EdgeInsets.fromLTRB(12, 19, 12, 12), // Adjust spacing as needed
  //child: Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${widget.requester} wants to connect',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            
          ),
        ),
              ElevatedButton.icon(
                onPressed: widget.accept,
                label: const Text(
                  'Accept',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
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
              ElevatedButton.icon(
                onPressed: widget.reject,
                label:  Text(
                  'Reject',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                      ? Colors.white
                      : Colors.black,
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
      ],
    ),
 // ),
);

  }

}

//WidgetStateProperty