import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart'as user;
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';

class ConnectionsList extends StatefulWidget {
  const ConnectionsList({
    super.key,
    required this.isOwnProfile,// true
    required this.uid,
    required this.LoggedInUser
     });

    final bool isOwnProfile;
    final String uid;
    final String LoggedInUser;

  @override
  State<ConnectionsList> createState() => _ConnectionsListState();
}

class _ConnectionsListState extends State<ConnectionsList> {

  List<user.AppUser>? list;


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
    list = await EventsService().getConnectionsForInvite();
    setState(() {});
  }

  
  void _handleDisconnection(String uid) {
    setState(() {
      list = list?.where((user) => user.uid != uid).toList();
    });
  }

 @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connections'),
    ),
    
      body:  FutureBuilder<List<user.AppUser>?>(
              future:  ConnectionService().getProfileConnections('connections',widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}, ');
                } else {
                  list = snapshot.data;
                  if (list!.isEmpty) {
                  // Display "No connections" when the list is empty
                  return Column(
                    mainAxisSize: MainAxisSize.max, 
                    children: [
                    if (widget.isOwnProfile)
                    GestureDetector(
                      onTap: () {
                        // Navigate to the request page when the text is clicked
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ConnectionRequestList(isOwnProfile: widget.isOwnProfile,uid : widget.uid, LoggedInUser: widget.LoggedInUser,)));//go to next page 
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Requests',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary, // Customize the text color
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ), 
                       Center(
                        child: Text('No Connections'),
                      )
                      ]);
                    } else{
                      return Column(
                        mainAxisSize: MainAxisSize.max, 
                        children: [
                        if (widget.isOwnProfile)
                        GestureDetector(
                          onTap: () {
                            // Navigate to the request page when the text is clicked
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>  ConnectionRequestList(isOwnProfile: widget.isOwnProfile,uid : widget.uid, LoggedInUser: widget.LoggedInUser,)));//go to next page 
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Requests',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary, // Customize the text color
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: list!.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            user.AppUser? i = list![index];

                            if(i.uid == widget.LoggedInUser)
                            {
                              return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: 'You',
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'connections',
                                loggedInUser: widget.LoggedInUser,
                                onDisconnected: _handleDisconnection ,
                                onSelected: (uid, selected) {
                                  
                                });
                            }else{
                              return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'connections',
                                loggedInUser: widget.LoggedInUser,
                                onDisconnected: _handleDisconnection ,
                                onSelected: (uid, selected) {
                                  
                                });
                            }
                            
                                
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                        )),
                 
                ]);
          }
                  
                }
              }),
      );
  }
   
}


