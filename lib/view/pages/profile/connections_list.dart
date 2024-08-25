import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConnectionsList extends StatefulWidget {
  const ConnectionsList(
      {super.key,
      required this.isOwnProfile,
      required this.uid,
      required this.loggedInUser});

  final bool isOwnProfile;
  final String uid;
  final String loggedInUser;

  @override
  State<ConnectionsList> createState() => _ConnectionsListState();
}

class _ConnectionsListState extends State<ConnectionsList> {
  late List<user.AppUser> list;

  @override
  void initState() {
    super.initState();
    getConnectionsInvite(); 
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConnectionsInvite() async {
    list = (await EventsService().getConnectionsForInvite())!;
    setState(() {});
  }
  
  void sortlist(List<user.AppUser> connections)
  {
     connections.sort((a, b) => a.username.compareTo(b.username));
  }

  void moveYouToTheFront(List<user.AppUser> connections, String yourUid) {  
  for (int i = 0; i < connections.length; i++) {
    if (connections[i].uid == yourUid) {
      user.AppUser you = connections.removeAt(i);
      connections.insert(0, you);
      break;
    }
  }
}


  void _handleDisconnection(String uid) {
    setState(() {
      list = list.where((user) => user.uid != uid).toList();
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
      ),
      body: FutureBuilder<List<user.AppUser>?>(
          future: ConnectionService()
              .getProfileConnections('connections', widget.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}, ');
            } else {
              list = snapshot.data!;
              sortlist(list);
              if(!widget.isOwnProfile)
              {moveYouToTheFront(list, widget.loggedInUser);}

              if (list.isEmpty) {
                // Display "No connections" when the list is empty
                return ListView( children: [
                  if (widget.isOwnProfile)
                    GestureDetector(
                      onTap: () {
                        // Navigate to the request page when the text is clicked
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionRequestList(
                                      isOwnProfile: widget.isOwnProfile,
                                      uid: widget.uid,
                                      loggedInUser: widget.loggedInUser,
                                    ))); //go to next page
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                         decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                        child: Text(
                          'Requests',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary, // Customize the text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const Center(
                    child: Text('No Connections'),
                  )
                ]);
              } else {
                return ListView( 
                  children: [
                  if (widget.isOwnProfile)
                    GestureDetector(
                      onTap: () {
                        // Navigate to the request page when the text is clicked
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionRequestList(
                                      isOwnProfile: widget.isOwnProfile,
                                      uid: widget.uid,
                                      loggedInUser: widget.loggedInUser,
                                    ))); //go to next page
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                         decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                        child: Text(
                          'Requests',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .primary, // Customize the text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                Container(
                      height: MediaQuery.of(context).size.height,
                       decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                      child:
                       ListView.separated(
                        itemCount: list.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          user.AppUser? i = list[index];
                          if (i.uid == widget.loggedInUser) {
                            return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: 'You',
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'connections',
                                loggedInUser: widget.loggedInUser,
                                isOwnProfile: widget.isOwnProfile,
                                onDisconnected: _handleDisconnection,
                                onSelected: (uid, selected) {});
                          } else {
                            return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'connections',
                                loggedInUser: widget.loggedInUser,
                                isOwnProfile: widget.isOwnProfile,
                                onDisconnected: _handleDisconnection,
                                onSelected: (uid, selected) {});
                          }
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox();
                        },
                      ),),
                ]);
              }
            }
          }),
    );
  }
}
