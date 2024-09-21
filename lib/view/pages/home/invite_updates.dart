import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/home/connection_updates.dart';
import 'package:gameonconnect/view/components/home/event_invite_list.dart';

class InviteUpdates extends StatefulWidget {
  const InviteUpdates({super.key});

  @override
  State<InviteUpdates> createState() => _InviteUpdatesState();
}

class _InviteUpdatesState extends State<InviteUpdates> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite updates', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          Text("Connection updates",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 15),
          ConnectionUpdates(),
          SizedBox(height: 30),
          Text("Event invites",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 15),
          EventInvitesList()
        ],
      ),
    );
  }
}
