import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
                return Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: Theme.of(context).colorScheme.primary,
                    size: 36,
                  ),
                );
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
                return SingleChildScrollView( child:Column(mainAxisSize: MainAxisSize.max, children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 16, 0, 19),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon: const Icon(Icons.keyboard_backspace)),
                              Text(
                                'Select users to invite',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 21),
                    child: SearchField(
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
                  ),
                  if (filteredUsers.isEmpty)
                    const Center(child: Text('No results found.'))
                  else
                    SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                          itemCount: filteredUsers.length,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
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
                                isOwnProfile: true,
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
                ]));
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
        height: 35,
        width: double.infinity,
        child: MaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              Navigator.pop(context, invites);
            },
            color: Theme.of(context).colorScheme.primary,
            child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Save", style: TextStyle(color: Colors.black)),
                ])),
      ),
    );

  }
}
