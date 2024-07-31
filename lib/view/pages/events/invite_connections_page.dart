import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../components/card/connection_list_card.dart';
import '../../../services/events_S/event_service.dart';
import '../../../model/connection_M/user_model.dart';
import '../../components/search/search_field.dart';

class ConnectionsListWidget extends StatefulWidget {
  final List<String> chosenInvites;
  const ConnectionsListWidget({super.key, required this.chosenInvites});
  @override
  State<ConnectionsListWidget> createState() => _ConnectionsListWidgetState();
}

class _ConnectionsListWidgetState extends State<ConnectionsListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppUser>? list;
  List<String> invites = [];
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    getConnectionsInvite();
    _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    invites = widget.chosenInvites;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConnectionsInvite() async {
    list = await EventsService().getConnectionsForInvite();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<AppUser>?>(
              future: EventsService().getConnectionsForInvite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  list = snapshot.data;
                  List<AppUser> filteredUsers = list!
                      .where((user) =>
                          user.username
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) &&
                          user.uid != _currentUserId) // Exclude current user
                      .toList();
                  return  Column(mainAxisSize: MainAxisSize.max, children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 3,
                            color: Theme.of(context).colorScheme.secondary,
                            offset: const Offset(
                              0,
                              1,
                            ),
                          )
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: const AlignmentDirectional(-1, 0),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  16, 0, 0, 12),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon:
                                          const Icon(Icons.keyboard_backspace)),
                                  Text(
                                    'Select users to invite',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SearchField(
                        controller: searchController,
                        onSearch: (query) {
                          setState(() {
                            _searchQuery = query;
                            filteredUsers = list!
                                .where((user) =>
                                    user.username
                                        .toLowerCase()
                                        .contains(_searchQuery.toLowerCase()) &&
                                    user.uid != _currentUserId)
                                .toList();
                          });
                        }),
                    if( filteredUsers.isEmpty)
                      const Center(
                          child: Text(
                              'No results found.'))
                    else

                    SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: filteredUsers.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            AppUser? i = filteredUsers[index];

                            return ConnectionCardWidget(
                              invited: invites,
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'events',
                                loggedInUser: i.uid,
                                onSelected: (uid, selected) {
                                  if (selected) {
                                    invites.add(uid);
                                  } else {
                                    invites.remove(uid);
                                  }
                                });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                        )),
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 770,
                      ),
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            16, 12, 16, 12),
                        child: MaterialButton(
                            onPressed: () {
                              Navigator.pop(context, invites);
                            },
                            color: Theme.of(context).colorScheme.primary,
                            child: const Row(children: [
                              Text("Save invites"),
                            ])),
                      ),
                    )
                  ]
                  );
                }
              }),
        ));
  }
}
