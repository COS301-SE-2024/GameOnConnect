import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart'as user;
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/pages/connections/connection_requests_page.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';

class ConnectionRequestList extends StatefulWidget {
  const ConnectionRequestList({super.key, });
  //final List<User> users;

  @override
  State<ConnectionRequestList> createState() => _ConnectionRequestListState();
}

class _ConnectionRequestListState extends State<ConnectionRequestList> {

  List<user.User>? list;


  @override
  void initState() {
    super.initState();
    getConnectionRequests();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConnectionRequests() async {
    list = await ConnectionService().getConnectionRequests();
    setState(() {});
  }

  void _handleAcceptance(String uid) {
    setState(() {
      list?.removeWhere((user) => user.uid == uid);
    });
  }

  void _handleRejection(String uid) {
    setState(() {
      list?.removeWhere((user) => user.uid == uid);
    });
  }

 @override
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connection Requests'),
    ),
    
      body:  FutureBuilder<List<user.User>?>(
              future: ConnectionService().getConnectionRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  list = snapshot.data;
                  if (list!.isEmpty) {
            // Display "No connections" when the list is empty
            return Center(
              child: Text('No connection Requests'),
            );
          } else{
            return Column(
                    mainAxisSize: MainAxisSize.max, 
                    children: [
                
                    SizedBox(
                        height: 300,
                        child: ListView.separated(
                          itemCount: list!.length,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            user.User? i = list![index];

                            return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'requests',
                                onDisconnected: _handleAcceptance ,
                                onSelected: (uid, selected) {
                                  
                                });
                                
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




