import 'package:flutter/material.dart';

class RequestContainer extends StatefulWidget {
  final String Requester;
  final VoidCallback accept;
  final VoidCallback reject;

  const RequestContainer({super.key, 
    required this.Requester,
    required this.accept, 
    required this.reject,
 });    

  @override
  State<RequestContainer> createState() => _RequestContainerState();
  
  }


class _RequestContainerState extends State<RequestContainer> {

  @override
 Widget build(BuildContext context) {
    return Container(
  padding: EdgeInsets.fromLTRB(12, 12, 12, 12), // Adjust spacing as needed
  child: Center(
    child: Column(
      children: [
        Text(
          '${widget.Requester} wants to connect',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            //fontSize: 12,
            letterSpacing: 0,
            color: Color(0xFFBEBEBE),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [
              ElevatedButton.icon(
                onPressed: () => widget.accept,
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
              SizedBox(width: 8,),
              ElevatedButton.icon(
                onPressed: () => widget.reject,
                label: const Text(
                  'Reject',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
        ),
      ],
    ),
  ),
);

  }

}

//WidgetStateProperty