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

    bool _isDropdownOpen = false;
    

  void _toggleDropdown() {
    setState(() {
      _isDropdownOpen = !_isDropdownOpen;
    });
    
  }

  void _handleTap() {
    if(widget.type != 'connected')
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
  final bool isStats = widget.type == 'stats';
  final bool isConnected = widget.type == 'connected';
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
            if (isConnected) ...[
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'disconnect') {
                      widget.onPressed();
                    }
                    _toggleDropdown();
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'disconnect',
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person_remove
                          ),
                          const SizedBox(width: 8), // Space between icon and text
                          Text('Disconnect'),
                        ],
                      ),
                    ),
                  ],
                  icon: Icon(
                    _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  onCanceled: _toggleDropdown,
                  onOpened: _toggleDropdown,
                  offset: Offset(0, 40),
                ),
              ],
            
          ],
        ),
      ),
    ),
  );
}
}
