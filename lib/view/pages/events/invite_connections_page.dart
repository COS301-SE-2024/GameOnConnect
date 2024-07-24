import 'package:flutter/material.dart';
import '../../components/card/connection_list_card.dart';
import '../../../services/events_S/event_service.dart';
import '../../../model/connection_M/user_model.dart' as user;

class ConnectionsListWidget extends StatefulWidget {
  const ConnectionsListWidget({super.key});

  @override
  State<ConnectionsListWidget> createState() => _ConnectionsListWidgetState();
}

class _ConnectionsListWidgetState extends State<ConnectionsListWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<user.AppUser>? list;
  List<String> invites=[];


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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: FutureBuilder<List<user.AppUser>?>(
              future: EventsService().getConnectionsForInvite(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  list = snapshot.data;
                  return Column(mainAxisSize: MainAxisSize.max, children: [
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
                    SizedBox(
                        height: 300,
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
                                page: 'events',
                                onSelected: (uid, selected) {
                                  if (selected) {
                                    invites.add(uid);
                                  }else{
                                    invites.remove(uid);
                                  }
                                });
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                        )),
                 Padding(
                padding:const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
                    child: MaterialButton(onPressed: () {Navigator.pop(context,invites);},
                        color: Theme.of(context).colorScheme.primary,
                        child: const Row(children: [
                          Text("Save invites"),
                        ])),
                  )
                ]);
                }
              }),
        ));
  }
}
