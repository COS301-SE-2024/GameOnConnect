// ignore_for_file: unused_element

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import '../../../services/connection_S/connection_request_service.dart';
import '../../../model/connection_M/user_model.dart';
import '../../../model/connection_M/friend_model.dart';

class FriendSearch extends StatefulWidget {
  final String currentUserId;

  // ignore: use_key_in_widget_constructors
  const FriendSearch(this.currentUserId);

  @override
  // ignore: library_private_types_in_public_api
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<User> _users = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    try {
     List<User> users = await _userService.fetchAllUsers();
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
      List<User> users = await _userService.fetchAllUsers();
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
      await _userService.sendConnectionRequest(widget.currentUserId, targetUserId);
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
      await _userService.undoConnectionRequest(widget.currentUserId, targetUserId);
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

  void _unfollowUser(String targetUserId) async {
    try {
      await _userService.disconnect(widget.currentUserId, targetUserId);
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
        stream: _userService.getCurrentUserConnectionsStream(widget.
        currentUserId),
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
            return const Center(child: Text('Please check your internet connection.'));
          }
          Friend? currentUserConnectionData = snapshot.data;
          List<User> filteredUsers = _users
              .where((user) =>
                  user.username
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) &&
                  user.uid != widget.currentUserId) // Exclude current user
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      // Update filteredUsers here based on the new search query
                      filteredUsers = _users
                          .where((user) =>
                              user.username
                                  .toLowerCase()
                                  .contains(_searchQuery.toLowerCase()) &&
                              user.uid != widget.currentUserId)
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by profile name',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          // Clear the search query and show all users
                          _searchQuery = '';
                          filteredUsers = _users;
                        });
                      },
                    ),
                  ),
                ),
              ),
              if (filteredUsers.isEmpty)
                const Center(
                    child: Text(
                        'No results found.')) // Display a message for no results
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      User user = filteredUsers[index];
                      bool isConnection =
                          currentUserConnectionData?.friends.contains(user.uid) ??
                              false;
                      bool isPending =
                          currentUserConnectionData?.pending.contains(user.uid) ??
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
                        trailing: isConnection
                            ? ElevatedButton.icon(
                                onPressed: () => _unfollowUser(user.uid),
                                icon: const Icon(
                                  Icons.person_remove,
                                  color: Colors
                                      .white, // Set your desired icon color
                                ),
                                label: const Text('Disconnect',
                                    style: TextStyle(color: Colors.white)),
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
                                    label:  Text('Pending',
                                        style: TextStyle(color:Theme.of(context).colorScheme.secondary)),
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
                                    icon:  Icon(
                                      Icons.person_add,
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    label:  Text('Connect',
                                        style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
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
