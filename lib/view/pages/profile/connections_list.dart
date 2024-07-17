import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart'as user;
import 'package:gameonconnect/services/events_S/event_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';

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
    
      body:  FutureBuilder<List<user.User>?>(
              future: Events().getConnectionsForInvite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  list = snapshot.data;
                  if (list!.isEmpty) {
            // Display "No connections" when the list is empty
            return Column(
                    mainAxisSize: MainAxisSize.max, 
                    children: [
                    GestureDetector(
          onTap: () {
            // Navigate to the request page when the text is clicked
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionRequestList()));//go to next page 
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
            const Center(
              child: Text('No Connections'),
            )
            ]);
          } else{
            return Column(
                    mainAxisSize: MainAxisSize.max, 
                    children: [
                    GestureDetector(
          onTap: () {
            // Navigate to the request page when the text is clicked
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionRequestList()));//go to next page 
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
                            user.User? i = list![index];

                            return ConnectionCardWidget(
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'connections',
                                onDisconnected: _handleDisconnection ,
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


