import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/components/connections/request_button.dart';
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
  int requestsCount=0;

  @override
  void initState() {
    super.initState();
    nrOfRequests();
  }

  @override
  void dispose() {
    super.dispose();
  }


   void navigateToRequests(BuildContext context) {
     Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ConnectionRequestList(
          isOwnProfile: true,
          uid: widget.loggedInUser,
          loggedInUser: widget.loggedInUser,
        )
      )
    ); 
    BadgeService().unlockExplorerComponent('view_requests');
  }

Future<void> nrOfRequests()async {
    final connections = await ConnectionService().getConnections('requests');
    requestsCount= connections.length; 
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
              if(!widget.isOwnProfile)
              {moveYouToTheFront(list, widget.loggedInUser);}

              if (list.isEmpty) {
                return ListView( children: [
                  if (widget.isOwnProfile)
                     Padding(
                padding:const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                      RequestButton(
                    onPressed: () =>navigateToRequests(context),
                    count: requestsCount
                  ),
                ],
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
                     Padding(
                padding:const EdgeInsets.fromLTRB(0, 0, 12, 0),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                      RequestButton(
                    onPressed: () =>navigateToRequests(context),
                    count: requestsCount
                  ),
                ],
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
