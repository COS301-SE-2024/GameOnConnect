// ignore_for_file: unused_element

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/pages/profile/connections_request_list.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

  double _calculateButtonWidth(BuildContext context) {
    final TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: 'Disconnect',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double textWidth = textPainter.width;

    return textWidth;
  }

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

  /*Future<void> _fetchUsers() async {
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
  }*/
  bool _isLoading = true;

  Future<void> _fetchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<AppUser> users = await _userService.fetchAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
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
          // ignore: use_build_context_synchronously
          .show(context);
    } finally {
      setState(() {
        _isLoading = false;
      });
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
          if (_isLoading) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
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
                .show(context);
            return const Center(
                child: Text('Please check your internet connection.'));
          }

          Friend? currentUserConnectionData = snapshot.data;
          List<AppUser> filteredUsers = _users
              .where((user) =>
                  user.username
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase()) &&
                  user.uid != _currentUserId)
              .toList();
          // ignore: unused_local_variable
          //final double buttonWidth = _calculateButtonWidth(context);

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
                  //const SizedBox(height: 30),
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
                        padding: const EdgeInsets.fromLTRB(16, 7, 30,0 ),
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
                  padding: const EdgeInsets.fromLTRB(12, 1, 12,5 ),
                  child:  Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
                  ),
                 
              if (filteredUsers.isEmpty)
                const Center(child: Text('No results found.'))
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

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      uid: user.uid,
                                      isOwnProfile: false,
                                      isConnection: false,
                                      loggedInUser:
                                          _currentUserId)), // Navigate to ConnectionsList page
                            );
                          },
                          child: Row(
                            children: [
                              /*CircleAvatar(
                          radius: 24, // Adjust the radius as needed
                          backgroundImage: CachedNetworkImageProvider(
                            user.profilePicture,
                          ),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle image load error
                          },
                          backgroundColor: Colors.grey.shade200, // Fallback background color
                          child: user.profilePicture.isEmpty
                              ? Icon(Icons.error) // Fallback icon if no image is provided
                              : null,
                        ),*/
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              SizedBox(
                                width: 130,
                                child: isConnection
                                    ? ElevatedButton.icon(
                                        onPressed: () => _disconnect(user.uid),
                                        label: const Text(
                                          'Disconnect',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              WidgetStateProperty.all<Color>(
                                            Theme.of(context)
                                                .colorScheme
                                                .tertiary,
                                          ),
                                        ),
                                      )
                                    : isPending
                                        ? ElevatedButton.icon(
                                            onPressed: () =>
                                                _undoConnectionRequest(
                                                    user.uid),
                                            label: Text(
                                              'Pending',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty
                                                      .resolveWith<Color>(
                                                (states) {
                                                  final isDarkMode =
                                                      Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark;
                                                  return isDarkMode
                                                      ? Colors.grey[800]!
                                                      : Colors.grey[300]!;
                                                },
                                              ),
                                            ),
                                          )
                                        : ElevatedButton.icon(
                                            onPressed: () =>
                                                _sendConnectionRequest(
                                                    user.uid),
                                            label: const Text(
                                              'Connect',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStateProperty.all<
                                                      Color>(
                                                Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                          ),
                              ),
                            ],
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
