import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSearch;

  const SearchField(
      {super.key, required this.controller, required this.onSearch});

  @override
  // ignore: library_private_types_in_public_api
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 20, right: 20),
                labelText: 'Search',
                prefixIcon: const Icon(Icons.search),
                fillColor: Theme.of(context).colorScheme.primaryContainer,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(100),
                  borderSide: const BorderSide(
                      color: Colors.transparent), 
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(100),
                  borderSide: const BorderSide(
                      color: Colors.transparent),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                  },
                )
              ),
              onSubmitted: (value) {
                widget.onSearch(value);
              },
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}
