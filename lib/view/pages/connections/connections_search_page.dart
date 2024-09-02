import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../components/card/connection_list_card.dart';
import '../../../services/events_S/event_service.dart';
import '../../../model/connection_M/user_model.dart';
import '../../components/search/search_field.dart';

class FriendSearch extends StatefulWidget {
  //final List<String> chosenInvites;
  const FriendSearch({super.key,});
  @override
_FriendSearchState createState() => _FriendSearchState();}

class _FriendSearchState extends State<FriendSearch> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<AppUser>? list;
  List<String> invites = [];
  final TextEditingController searchController = TextEditingController();
  String _searchQuery = '';
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    //getConnectionsInvite();
    //_currentUserId = FirebaseAuth.instance.currentUser!.uid;
    //invites = widget.chosenInvites;
    fetchUsers();
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      _currentUserId = FirebaseAuth.instance.currentUser!.uid;
    } else {
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'An error occurred. Try to login again.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              snackbarDuration: const Duration(seconds: 3))
          .show(
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  //Future<void> getConnectionsInvite() async {
  Future<void> fetchUsers() async {
    list = await UserService().fetchAllUsers();
    //list= await EventsService().getConnectionsForInvite();
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
                  child:Column(
                    mainAxisSize: MainAxisSize.max, 
                    children: [
                  Padding(
                    padding:const EdgeInsets.fromLTRB(12, 12, 12, 12),
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
                        }),
                  ),
                  GestureDetector(
                onTap: () {
                  // Navigate to the request page when the text is clicked
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConnectionRequestList(
                                isOwnProfile: true,
                                uid: _currentUserId,
                                loggedInUser: _currentUserId,
                              ))); //go to next page
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 7, 30, 0),
                  alignment: Alignment.centerRight,
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
                          itemCount: filteredUsers.length,
                          scrollDirection: Axis.vertical,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            AppUser? i = filteredUsers[index];

                            return ConnectionCardWidget(
                                invited: invites,
                                image: i.profilePicture,
                                username: i.username,
                                uniqueNum: i.uniqueNum.toString(),
                                uid: i.uid,
                                page: 'search',
                                loggedInUser: i.uid,
                                isOwnProfile: true,
                                onSelected: (uid, selected) {});
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
