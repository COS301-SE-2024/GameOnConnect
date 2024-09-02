import 'package:flutter/material.dart';

class RequestButton extends StatefulWidget {


  const RequestButton({
    super.key, 
    required this.onPressed,
    required this.count,
  });

  final VoidCallback onPressed;
  final int count;
    @override
  State<RequestButton> createState() => _RequestButtonState();
  
  }


class _RequestButtonState extends State<RequestButton> {

  void _navigateToRequests(){
   widget.onPressed();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
  onTap: _navigateToRequests,
  child: Stack(
    children: <Widget>[
      Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        child:Container(
        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            'Requests',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      ),
      
      if (widget.count > 0) // Add this condition
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              '${widget.count}', // Replace with your dynamic number
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
               // fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
    ],
  ),
);

    /*GestureDetector(
                onTap: _navigateToRequests,
                //child: Expanded(
      child:Container(
      padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
      //alignment: Alignment.centerRight,
      //height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
         child: Text(
                    'Requests',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .primary, // Customize the text color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
      ),
    ),
    //)
              );*/
    
    
  }
}
