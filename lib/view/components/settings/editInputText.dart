import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditInputText extends StatefulWidget{
  final String label;
  final void Function(String gameName) onChanged;
  final String input;
  final int maxLines;

  const EditInputText(
      {super.key,required this.maxLines, required this.label, required this.onChanged, required this.input});
  State<EditInputText> createState() => _EditInputText();

}

class _EditInputText extends State<EditInputText>{


  Widget build (BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(widget.label,
                style:
                TextStyle(color: Theme.of(context).colorScheme.secondary)),
          ),
          Expanded(
            flex: 4,
            child: TextFormField(
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              initialValue: widget.input,
              maxLines: widget.maxLines,
            ),
          ),
        ],
      ),
    );
  }

}