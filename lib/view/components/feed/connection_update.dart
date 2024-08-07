import 'package:flutter/material.dart';

class ConnectionUpdateCard extends StatefulWidget {
  final String user;
  final String connectionStatus;
  const ConnectionUpdateCard(
      {super.key, required this.user, required this.connectionStatus});

  @override
  State<ConnectionUpdateCard> createState() => _ConnectionUpdateCardState();
}

class _ConnectionUpdateCardState extends State<ConnectionUpdateCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.connectionStatus == "connect"
                ? Text("${widget.user} wants to connect")
                : Text("${widget.user} disconnected"),
            const Icon(Icons.close_sharp)
          ],
        ));
  }
}
