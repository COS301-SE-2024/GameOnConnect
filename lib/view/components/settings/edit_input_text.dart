import 'package:flutter/material.dart';

class EditInputText extends StatefulWidget {
  final String label;
  final void Function(String value) onChanged;
  final String input;
  final int maxLines;
  final Key inputKey;
  
  const EditInputText(
      {super.key,
      required this.maxLines,
      required this.label,
      required this.onChanged,
      required this.input,
      required this.inputKey});
  
  @override
  State<EditInputText> createState() => _EditInputText();
}

class _EditInputText extends State<EditInputText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
            child: Text(widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
              )
            ),
          ),
          const SizedBox(height: 5),
          TextFormField(
            key: widget.inputKey,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.primaryContainer,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.surface),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            initialValue: widget.input,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 12),
            maxLines: widget.maxLines,
          ),
        ],
      ),
    );
  }
}