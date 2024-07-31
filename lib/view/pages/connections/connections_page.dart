// ignore_for_file: unused_element

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import '../../../services/connection_S/connection_request_service.dart';
import '../../../model/connection_M/user_model.dart';
import '../../../model/connection_M/friend_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/view/components/search/search_field.dart';

class FriendSearch extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FriendSearch();

  @override
  // ignore: library_private_types_in_public_api
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<AppUser> _users = [];
  String _searchQuery = '';
  String _currentUserId = '';
 
  @override
  void initState() {
    super.initState();
    _fetchUsers();
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

  Future<void> _fetchUsers() async {
    try {
      List<AppUser> users = await _userService.fetchAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      //'Could not fetch users'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'An error occurred. Please ensure that you have an active internet connection.',
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

  Future<void> _fetchData() async {
    try {
      List<AppUser> users = await _userService.fetchAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      //'Error fetching data'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'An error occurred. Please retry',
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

  void _sendConnectionRequest(String targetUserId) async {
    try {
      await _userService.sendConnectionRequest(_currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      //Error sending Connection request.
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error sending friend request. Please ensure that you have an active internet connection.',
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

  void _undoConnectionRequest(String targetUserId) async {
    try {
      await _userService.undoConnectionRequest(_currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      //'Error canceling friend request'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'An error occurred. Please retry',
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

  void _disconnect(String targetUserId) async {
    try {
      await _userService.disconnect(_currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      //'Error unfollowing user'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error unfollowing user. Please ensure that you have an active internet connection.',
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Friend?>(
        stream: _userService.getCurrentUserConnectionsStream(_currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            DelightToastBar(
                    builder: (context) {
                      return CustomToastCard(
                        title: Text(
                          'Please ensure that you have an active internet connection.',
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
            //return Center(child: Text('Error: ${snapshot.error}')); to see the error in the page
            return const Center(
                child: Text('Please check your internet connection.'));
          }
          Friend? currentUserConnectionData = snapshot.data;
          List<AppUser> filteredUsers = _users
              .where((user) =>
                  user.username
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) &&
                  user.uid != _currentUserId) // Exclude current user
              .toList();

          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchField(
                    controller: _searchController,
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                        filteredUsers = _users
                            .where((user) =>
                                user.username
                                    .toLowerCase()
                                    .contains(_searchQuery.toLowerCase()) &&
                                user.uid != _currentUserId)
                            .toList();
                      });
                    },
                  )),
              if (filteredUsers.isEmpty)
                const Center(
                    child: Text(
                        'No results found.')) // Display a message for no results
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      AppUser user = filteredUsers[index];
                      bool isConnection = currentUserConnectionData?.friends
                              .contains(user.uid) ??
                          false;
                      bool isPending = currentUserConnectionData?.pending
                              .contains(user.uid) ??
                          false;

                      return ListTile(
                        /*leading:  CircleAvatar(
                        child: CachedNetworkImage( 
                          imageUrl: user.profilePicture, 
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>  CircularProgressIndicator(), 
                          errorWidget: (context, url, error) => Icon(Icons.error), 
                        ),
                        //backgroundImage: NetworkImage(user.profilePicture),https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg
                        //backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg")

                      ),*/
                        title: Text(user.username),
                        onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Profilenew(uid: user.uid, isOwnProfile:false, isConnection: false, loggedInUser: _currentUserId)), // Navigate to ConnectionsList page
                        );
                      },
                        trailing: isConnection
                            ? ElevatedButton.icon(
                                onPressed: () => _disconnect(user.uid),
                                icon: const Icon(
                                  Icons.person_remove,
                                  color: Colors
                                      .white, // Set your desired icon color
                                ),
                                label: const Text('Disconnect',
                                    style: TextStyle(color: Colors.black)),
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                    const Color.fromRGBO(0, 223, 103, 1.0),
                                  ), // Set your desired color
                                ),
                              )
                            : isPending
                                ? ElevatedButton.icon(
                                    onPressed: () =>
                                        _undoConnectionRequest(user.uid),
                                    icon: const Icon(
                                      Icons.hourglass_bottom,
                                      color: Colors.white,
                                    ),
                                    label: const Text('Pending',
                                        style: TextStyle(
                                            color: Colors.black)),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ), // Set your desired color
                                    ),
                                  )
                                : ElevatedButton.icon(
                                    onPressed: () =>
                                        _sendConnectionRequest(user.uid),
                                    icon: Icon(
                                      Icons.person_add,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    label: const Text('Connect',
                                        style: TextStyle(
                                            color: Colors.black)),
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.all<Color>(
                                        Theme.of(context).colorScheme.primary,
                                      ), // Set your desired color
                                    ),
                                  ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
