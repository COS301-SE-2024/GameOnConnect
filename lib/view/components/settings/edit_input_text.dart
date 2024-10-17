import 'package:flutter/material.dart';

class EditInputText extends StatefulWidget {
  final String label;
  final void Function(String value) onChanged;
  final String input;
  final int maxLength;
  final Key inputKey;
  final bool validate;
  
  const EditInputText(
      {super.key,
      required this.maxLength,
      required this.label,
      required this.onChanged,
      required this.input,
      required this.inputKey,
      required this.validate});
  
  @override
  State<EditInputText> createState() => _EditInputText();
}

class _EditInputText extends State<EditInputText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 12,
              )
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
            maxLength: widget.maxLength,
            validator: widget.validate?(value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a username';
              }
              if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                return 'Only alphabetical letters are permitted';
              }
              return null;
            }: (value){
              return null;
            },
          ),
        ],
      ),
    );
  }
}