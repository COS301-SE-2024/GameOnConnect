import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {

  const ActionButton({
    super.key,
    required this.type,
    required this.onPressed,
    required this.icon,
  });

  final String type; // Either 'stats' or 'connect'
  final VoidCallback onPressed;
  final IconData icon;

  @override
  State<ActionButton> createState() => _ActionButtonState();
  
  }


class _ActionButtonState extends State<ActionButton> {

  bool isPending = false;


  void _handleTap() {
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
  final bool isStats = widget.type == 'stats';
  
  return GestureDetector(
    onTap: _handleTap,
    child: Container(
      height: 40,
      decoration: BoxDecoration(
        color: isStats
            ? Colors.transparent
            : Theme.of(context).colorScheme.primary,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: isStats ? Theme.of(context).colorScheme.primary : Colors.black ,
            ),
            const SizedBox(width: 8), // Space between icon and text
            Text(
              (isStats ? 'View Stats' : widget.type) ,
              style:  TextStyle(
                fontWeight: FontWeight.w700,
                color: isStats ? Theme.of(context).colorScheme.primary : Colors.black ,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}
