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
          title: Text(
            'Invites and requests',
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary),
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(
                      icon: Icon(Icons.event_available,
                          color: Theme.of(context).colorScheme.primary),
                      text: 'Event Invites'),
                  Tab(
                      icon: Icon(Icons.person_add,
                          color: Theme.of(context).colorScheme.primary),
                      text: 'Connection Updates'),
                ],
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    EventInvitesList(),
                    ConnectionUpdates(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
