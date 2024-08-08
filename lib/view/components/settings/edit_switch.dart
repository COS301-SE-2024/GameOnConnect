import 'package:flutter/material.dart';

class EditSwitch extends StatefulWidget {
  final bool currentValue;
  final String label;
  final void Function(bool value) onChanged;

  const EditSwitch({
    Key? key,
    required this.currentValue,
    required this.label,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<EditSwitch> createState() => _EditSwitchState();
}

class _EditSwitchState extends State<EditSwitch> {
  late bool currentValue;
  late String label;

  @override
  void initState() {
    super.initState();
    label = widget.label;
    currentValue = widget.currentValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 15, 12, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10.0),
          // border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              widget.label,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary,
              fontSize: 12),
            ),
            Switch.adaptive(
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
          ],
        ),
      ),
    );
  }
}
