import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import '../models/friend_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FriendSearch extends StatefulWidget {
  final String currentUserId;

  FriendSearch(this.currentUserId);

  @override
  _FriendSearchState createState() => _FriendSearchState();
}

class _FriendSearchState extends State<FriendSearch> {
  final TextEditingController _searchController = TextEditingController();
  final UserService _userService = UserService();
  List<User> _users = [];
  String _searchQuery = '';
   Friend? _currentUserFriendData;

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
      Friend currentUserFriendData = await _userService.fetchCurrentUserFriends(widget.currentUserId);
      setState(() {
        _users = users;
        _currentUserFriendData = currentUserFriendData;
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

  void _acceptFriendRequest(String requesterUserId) async {
    try {
      await _userService.acceptFriendRequest(widget.currentUserId, requesterUserId);
      _fetchData();
    } catch (e) {
      print('Error accepting friend request: $e');
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
    title: Text('Friends'),
  ),
  body: StreamBuilder<Friend>(
    stream: _userService.getCurrentUserFriendsStream(widget.currentUserId),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
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
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
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
            Center(child: Text('No results found.')) // Display a message for no results
          else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (context, index) {
                    User user = filteredUsers[index];
                    bool isFriend = currentUserFriendData?.friends.contains(user.uid) ?? false;
                    bool isPending = currentUserFriendData?.pending.contains(user.uid) ?? false;

                    return ListTile(
                      leading:  CircleAvatar(
                        child: CachedNetworkImage( 
                          imageUrl: user.profilePicture, 
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>  CircularProgressIndicator(), 
                          errorWidget: (context, url, error) => Icon(Icons.error), 
                        ),
                        //backgroundImage: NetworkImage(user.profilePicture),https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg
                        //backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg")

                      ),
                      title: Text(user.profileName),
                      trailing: isFriend
                          ? ElevatedButton.icon(
                              onPressed: () => _unfollowUser(user.uid),
                              icon: Icon(
                                Icons.person_remove,
                                color: Colors.white, // Set your desired icon color
                              ),
                              label: Text('Disconnect', style: TextStyle(color: Colors.white)),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
                              ),
                            )
                          
                          : isPending
                              ? ElevatedButton.icon(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.hourglass_bottom,
                                    color: Colors.white, 
                                    ),
                                  label: Text('Pending', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
                              ),
                                )
                              : ElevatedButton.icon(
                                  onPressed: () => _sendFriendRequest(user.uid),
                                  icon: Icon(
                                    Icons.person_add,
                                    color: Colors.white, 
                                    ),
                                  label: Text('Connect', style: TextStyle(color: Colors.white)),
                                  style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(0, 223, 103, 1.0),), // Set your desired color
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
