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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.label,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
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
                // borderSide: BorderSide(
                //     color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            initialValue: widget.input,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            maxLines: widget.maxLines,
          ),
        ],
      ),
    );
  }
}










// import 'package:flutter/material.dart';

// class EditInputText extends StatefulWidget {
//   final String label;
//   final void Function(String value) onChanged;
//   final String input;
//   final int maxLines;
//   final Key inputKey;
//   const EditInputText(
//       {super.key,
//       required this.maxLines,
//       required this.label,
//       required this.onChanged,
//       required this.input,
//       required this.inputKey});
//   @override
//   State<EditInputText> createState() => _EditInputText();
// }

// class _EditInputText extends State<EditInputText> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             flex: 2,
//             child: Text(widget.label,
//                 style:
//                     TextStyle(color: Theme.of(context).colorScheme.secondary)),
//           ),
//           Expanded(
//             flex: 4,
//             child: TextFormField(
//               key: widget.inputKey,
//               onTapOutside: (event) {
//                 FocusManager.instance.primaryFocus?.unfocus();
//               },
//               onChanged: widget.onChanged,
//               decoration: InputDecoration(
//                 enabledBorder: OutlineInputBorder(
//                   borderSide:
//                       BorderSide(color: Theme.of(context).colorScheme.primary),
//                   borderRadius: BorderRadius.circular(20.0),
//                 ),
//               ),
//               initialValue: widget.input,
//               style: TextStyle(color: Theme.of(context).colorScheme.secondary),
//               maxLines: widget.maxLines,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
