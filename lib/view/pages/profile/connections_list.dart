import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart'as user;
import 'package:gameonconnect/model/connection_M/user_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';

class ConnectionsList extends StatefulWidget {
  const ConnectionsList({super.key, });
  //final List<User> users;

  @override
  State<ConnectionsList> createState() => _ConnectionsListState();
}

class _ConnectionsListState extends State<ConnectionsList> {

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
      appBar: AppBar(title: Text('Connections')),
      body:  FutureBuilder<List<user.User>?>(
              future: Events().getConnectionsForInvite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  list = snapshot.data;
                  return Column(mainAxisSize: MainAxisSize.max, children: [
                   
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
   //@override
  /*Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Connections')),
      body: ListView.builder(
        itemCount: widget users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture),
            ),
            title: Text(user.profileName),
            subtitle: Text('#${user.uniqueNum}'),
          );
        },
      ),
    );
  }*/
}


