import 'package:flutter/material.dart';
import 'package:gameonconnect/model/connection_M/user_model.dart' as user;
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/card/connection_list_card.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ConnectionRequestList extends StatefulWidget {
  const ConnectionRequestList({
    super.key,
    required this.isOwnProfile,
    required this.uid,
    required this.loggedInUser,
  });

  final bool isOwnProfile;
  final String uid;
  final String loggedInUser;

  @override
  State<ConnectionRequestList> createState() => _ConnectionRequestListState();
}

class _ConnectionRequestListState extends State<ConnectionRequestList> {
  List<user.AppUser>? list;

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
    list =
        await ConnectionService().getProfileConnections('requests', widget.uid);
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
        //
        title: const Text('Connection Requests'),
      ),
      body: FutureBuilder<List<user.AppUser>?>(
          future:
              ConnectionService().getProfileConnections('requests', widget.uid),
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
              if (list!.isEmpty) {
                // Display "No connections" when the list is empty
                return Center(
                  child: Text(
                    'No connection requests',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              } else {
                return Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: ListView.separated(
                      itemCount: list!.length,
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        user.AppUser? i = list![index];

                        return ConnectionCardWidget(
                            image: i.profilePicture,
                            username: i.username,
                            uniqueNum: i.uniqueNum.toString(),
                            uid: i.uid,
                            page: 'requests',
                            loggedInUser: widget.loggedInUser,
                            isOwnProfile: widget.isOwnProfile,
                            onAccepted: _handleAcceptance,
                            onRejected: _handleRejection,
                            onSelected: (uid, selected) {});
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox();
                      },
                    ));
              }
            }
          }),
    );
  }
}
