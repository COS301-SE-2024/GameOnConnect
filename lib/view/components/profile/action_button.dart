import 'package:flutter/material.dart';

class ActionButton extends StatefulWidget {

  const ActionButton({
    super.key,
    required this.type,
    required this.onPressed,
  });

  final String type; // Either 'stats' or 'connect'
  final VoidCallback onPressed;

  @override
  State<ActionButton> createState() => _ActionButtonState();
  
  }


class _ActionButtonState extends State<ActionButton> {

  bool isPending = false;

  void _handleTap() {
    if (widget.type == 'connect' && !isPending) {
      setState(() {
        isPending = true;
      });
    }
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final bool isStats = widget.type == 'stats';
    final bool showPending = isPending && widget.type == 'connect';

    return GestureDetector(
      onTap: _handleTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isStats
              ? Colors.transparent
              : ( Theme.of(context).colorScheme.primary),
          border: Border.all(color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                showPending ? Icons.hourglass_bottom : (isStats ? Icons.bar_chart : Icons.person_add),
                color: showPending ? Colors.black : (isStats ? Theme.of(context).colorScheme.primary : Colors.black),
              ),
              const SizedBox(width: 8), // Space between icon and text
              Text(
                showPending ? 'Pending' : (isStats ? 'View Stats' : 'Connect'),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: showPending ? Colors.black : (isStats ? Theme.of(context).colorScheme.primary : Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
