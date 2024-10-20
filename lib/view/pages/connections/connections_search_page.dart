import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/components/connections/request_button.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/card/connection_list_card.dart';
import '../../../model/connection_M/user_model.dart';
import '../../components/search/search_field.dart';

class FriendSearch extends StatefulWidget {
  //final List<String> chosenInvites;
  const FriendSearch({
    super.key,
  });
  @override
  FriendSearchState createState() => FriendSearchState();
}

class FriendSearchState extends State<FriendSearch> {
  final BadgeService _badgeService = BadgeService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppUser>? list;
  List<String> invites = [];
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String _currentUserId = '';
  int requestsCount = 0;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    nrOfRequests();
    fetchUsers();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      CustomSnackbar().show(context,
                    'An error occurred. Try to login again.',
      );
    }
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  //Future<void> getConnectionsInvite() async {
  Future<void> fetchUsers() async {
    list = await UserService().fetchAllUsers();
    //list= await EventsService().getConnectionsForInvite();
  }

  void navigateToRequests(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ConnectionRequestList(
                  isOwnProfile: true,
                  uid: _currentUserId,
                  loggedInUser: _currentUserId,
                )));

    _badgeService.unlockExplorerComponent('view_requests');
  }

  Future<void> nrOfRequests() async {
    final connections = await ConnectionService().getConnections('requests');
    requestsCount = connections.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        top: true,
        child: FutureBuilder<List<AppUser>?>(
            future: UserService().fetchAllUsers(),
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
                return SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.max, children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    //const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 21),

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
                          _badgeService.unlockExplorerComponent('search_connection');
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        RequestButton(
                          onPressed: () => navigateToRequests(context),
                          count: requestsCount,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 1, 12, 5),
                    child: Divider(
                      thickness: 1,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                  if (filteredUsers.isEmpty)
                    const Center(child: Text('No results found.'))
                  else
                    Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                          itemCount: filteredUsers.length+1,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            if (index == filteredUsers.length){
                              return const SizedBox(height: 100,);
                            }else {
                              AppUser? i = filteredUsers[index];

                              return ConnectionCardWidget(
                                  invited: invites,
                                  image: i.profilePicture,
                                  username: i.username,
                                  uniqueNum: i.uniqueNum.toString(),
                                  uid: i.uid,
                                  page: 'search',
                                  loggedInUser: _currentUserId,
                                  isOwnProfile: true,
                                  onSelected: (uid, selected) {});
                            }
                          },

                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox();
                          },
                        )),
                ]));
              }
            }),
      ),
    );
  }
}
