import 'package:flutter/material.dart';

class TagContainer extends StatefulWidget {

  const TagContainer({
    super.key,
    required this.tagType,
    required this.onPressed,
  });

  final String tagType; // Either 'stats' or 'connect'
  final VoidCallback onPressed;

  @override
  State<TagContainer> createState() => _TagContainerState();
  
  }


class _TagContainerState extends State<TagContainer> {


  @override
  Widget build(BuildContext context) {
  return Container(
      height: 40,
      margin: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child:  Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
        child:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.tagType,
            style:  TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.secondary,
            ),
            onPressed: () {
              widget.onPressed();
            },
          ),
          
        ],
      ),
      ),

    );

}
}
