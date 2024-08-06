import 'package:flutter/material.dart';

class EditSwitch extends StatefulWidget {
  final bool currentValue;
  final String label;
  final void Function(bool value) onChanged;
  const EditSwitch({super.key, required this.currentValue, required this.label, required this.onChanged});

  @override
  State<EditSwitch> createState() => _EditSwitch();
}

class _EditSwitch extends State<EditSwitch> {
  late bool currentValue;
  late String label;

  @override
  void initState() {
    super.initState();
    label = widget.label;
    currentValue = widget.currentValue;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(widget.label,
                style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          Expanded(
            flex: 4,
            child: Switch.adaptive(
              value: currentValue,
              onChanged: (bool value) {
                widget.onChanged(value);
                setState(() {
                  currentValue = value;
                });
              },
              activeTrackColor: Theme.of(context).colorScheme.primary,
              inactiveTrackColor: Theme.of(context).colorScheme.surface,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
