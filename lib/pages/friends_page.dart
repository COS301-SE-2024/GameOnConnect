// ignore_for_file: unused_element, avoid_print

import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../models/friend_model.dart';

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
      print('Error fetching users: $e');
    }
  }


  Future<void> _fetchData() async {
    try {
      List<User> users = await _userService.fetchAllUsers();
      setState(() {
        _users = users;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _sendFriendRequest(String targetUserId) async {
    try {
      await _userService.sendFriendRequest(widget.currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  void _undoFriendRequest(String targetUserId) async {
    try {
      await _userService.undoFriendRequest(widget.currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      print('Error undoing friend request: $e');
    }
  }


  void _unfollowUser(String targetUserId) async {
    try {
      await _userService.unfollowUser(widget.currentUserId, targetUserId);
      _fetchData();
    } catch (e) {
      print('Error unfollowing user: $e');
    }
  }

  
  @override
  Widget build(BuildContext context) {
   return Scaffold(
  appBar: AppBar(
    title: const Text('Friends'),
  ),
  body: StreamBuilder<Friend>(
    stream: _userService.getCurrentUserFriendsStream(widget.currentUserId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      Friend? currentUserFriendData = snapshot.data;
      List<User> filteredUsers = _users
          .where((user) =>
              user.profileName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
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
                          user.profileName.toLowerCase().contains(_searchQuery.toLowerCase()) &&
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
            const Center(child: Text('No results found.')) // Display a message for no results
          else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    User user = filteredUsers[index];
                    bool isFriend = currentUserFriendData?.friends.contains(user.uid) ?? false;
                    bool isPending = currentUserFriendData?.pending.contains(user.uid) ?? false;

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
                      title: Text(user.profileName),
                      trailing: isFriend
                          ? ElevatedButton.icon(
                              onPressed: () => _unfollowUser(user.uid),
                              icon: const Icon(
                                Icons.person_remove,
                                color: Colors.white, // Set your desired icon color
                              ),
                              label: const Text('Disconnect', style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
                              ),
                            )
                          
                          : isPending
                              ? ElevatedButton.icon(
                                  onPressed: () =>_undoFriendRequest(user.uid),
                                  icon: const Icon(
                                    Icons.hourglass_bottom,
                                    color: Colors.white, 
                                    ),
                                  label: const Text('Pending', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
                              ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () => _sendFriendRequest(user.uid),
                                  icon: const Icon(
                                    Icons.person_add,
                                    color: Colors.white, 
                                    ),
                                  label: const Text('Connect', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
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
