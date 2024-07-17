import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart'as user;
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/pages/connections/connection_requests_page.dart';

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
    getConnectionsInvite();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getConnectionsInvite() async {
    list = await Events().getConnectionsForInvite();
  }
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
                                onSelected: (uid, selected) {
                                  
                                });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                        )),
                 
                ]);
                }
              }),
      );
  }
   
}


