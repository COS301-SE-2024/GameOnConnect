import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchField(
      {Key? key, required this.controller, required this.onSearch})
      : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 20, right: 20),
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(100)),
            ),
          ),
        ),
        SizedBox(width: 15),
        IconButton.filled(
          color: Colors.black,
          icon: const Icon(Icons.search),
          onPressed: () {
            widget.onSearch(widget.controller.text);
          },
        ),
      ],
    );
  }
}
