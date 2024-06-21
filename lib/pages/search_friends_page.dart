import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/UserProfile.dart';

class FriendSearchPage extends StatefulWidget {
  final String currentUserId; 

  FriendSearchPage( this.currentUserId);

  @override
  _FriendSearchPageState createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;

List<UserProfile> _userProfiles = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }
  
  void _updateUserProfileStatus(String userId, String newStatus) {
    int index = _userProfiles.indexWhere((userProfile) => userProfile.id == userId);
    if (index != -1) {
      setState(() {
        _userProfiles[index].relationshipStatus = newStatus;
      });
    }
  }


   Stream<List<UserProfile>> searchFriends(String query) {
    return db
      .collection('profile_data')
      .where('username.profile_name', isGreaterThanOrEqualTo: query.toLowerCase())
      .where('username.profile_name', isLessThan: query.toLowerCase() + '\uf8ff')
      .snapshots()
      .asyncMap((snapshot) async {
        List<UserProfile> userProfiles = [];
        for (var doc in snapshot.docs) {
          UserProfile userProfile = UserProfile.fromDocumentSnapshot(doc, widget.currentUserId);
          userProfiles.add(userProfile);
        }
        setState(() {
          _userProfiles = userProfiles;
        });
        return userProfiles;
      });
  }

// follow (friend request) 
Future<void> sendConnectRequest(String currentUserId, String otherUserId ) async {
  // Add otherUserId to the current user's pending array
  final currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  //final otherUserDoc = FirebaseFirestore.instance.collection('friends').doc(otherUserId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get the current user's document
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    List<dynamic> currentUserPending = (currentUserSnapshot.data() as Map<String, dynamic>)['pending'];

    // Add otherUserId to currentUserPending list 
    if (!currentUserPending.contains(otherUserId)) {
      currentUserPending.add(otherUserId);
      transaction.update(currentUserDoc, {'pending': currentUserPending});
    }
   //-- change ui to pending and hour glass (CURRENT)
    // Handle sending a notification or updating other user's UI here if needed
    
  }).catchError((error) {
    print('Error sending friend request: $error');
  });

}

// Function to accept a friend request from another user
Future<void> acceptedFriendRequest(String currentUserId, String otherUserId) async {
  // Move otherUserId from pending array to friends array for both users
  final currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  final otherUserDoc = FirebaseFirestore.instance.collection('friends').doc(otherUserId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get both users' documents
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    DocumentSnapshot otherUserSnapshot = await transaction.get(otherUserDoc);

    List<dynamic> currentUserPending = (currentUserSnapshot.data() as Map<String, dynamic>)['pending'];
    List<dynamic> currentUserFriends = (currentUserSnapshot.data() as Map<String, dynamic>)['friends'];
    List<dynamic> otherUserFriends = (otherUserSnapshot.data() as Map<String, dynamic>)['friends'];

    // Move otherUserId from currentUserPending to currentUserFriends
    if (currentUserPending.contains(otherUserId)) {
      currentUserPending.remove(otherUserId);
      currentUserFriends.add(otherUserId);
      transaction.update(currentUserDoc, {'pending': currentUserPending, 'friends': currentUserFriends});
    }

    // Also add currentUserId to otherUserFriends
    if (!otherUserFriends.contains(currentUserId)) {
      otherUserFriends.add(currentUserId);
      transaction.update(otherUserDoc, {'friends': otherUserFriends});
    }
    //--update ui ..following is true on both , have unfollow info(BOTH)
  }).catchError((error) {
    print('Error accepting friend request: $error');
  });
}

// Function to unfollow (remove from friends list) another user
Future<void> disconnectUser(String currentUserId, String friendId) async {
  // Remove friendId from the current user's friends array and vice versa
  final currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  final friendUserDoc = FirebaseFirestore.instance.collection('friends').doc(friendId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get both users' documents
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    DocumentSnapshot friendUserSnapshot = await transaction.get(friendUserDoc);

    List<dynamic> currentUserFriends = (currentUserSnapshot.data() as Map<String, dynamic>)['friends'];
    List<dynamic> friendUserFriends = (friendUserSnapshot.data() as Map<String, dynamic>)['friends'];

    // Remove each other's IDs from their respective friends arrays
    if (currentUserFriends.contains(friendId)) {
      currentUserFriends.remove(friendId);
      transaction.update(currentUserDoc, {'friends': currentUserFriends});
    }
    
    if (friendUserFriends.contains(currentUserId)) {
      friendUserFriends.remove(currentUserId);
      transaction.update(friendUserDoc, {'friends': friendUserFriends});
    }
    //--update ui to isfollwing false have follow icon etc (BOTH)
  }).catchError((error) {
    print('Error unfollowing user: $error');
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Friends'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<UserProfile>>(
              stream: searchFriends(_searchController.text),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                List<UserProfile> userProfiles = snapshot.data!
                    .where((userProfile) => userProfile.id != widget.currentUserId)
                    .toList();
                return ListView.builder(
                  itemCount: userProfiles.length,
                  itemBuilder: (context, index) {
                    UserProfile userProfile = userProfiles[index];
                    return ListTile(
                      title: Text(userProfile.username),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (userProfile.relationshipStatus == "notFollowing")
                            TextButton(
                              child: Text('Follow'),
                              onPressed: () async {
                                await sendConnectRequest(widget.currentUserId, userProfile.id);
                                _updateUserProfileStatus(userProfile.id, "pending");
                              },
                            ),
                          if (userProfile.relationshipStatus == "following")
                            TextButton(
                              child: Text('Unfollow'),
                              onPressed: () async {
                                await disconnectUser(widget.currentUserId, userProfile.id);
                                _updateUserProfileStatus(userProfile.id, "notFollowing");
                              },
                            ),
                          if (userProfile.relationshipStatus == "pending")
                            TextButton(
                              child: Text('Pending'),
                              onPressed: null, // Optionally disable button or show a different UI
                            ),
                          IconButton(
                            icon: userProfile.relationshipStatus == "following"
                                ? Icon(Icons.person_remove)
                                : userProfile.relationshipStatus == "pending"
                                    ? Icon(Icons.hourglass_empty)
                                    : Icon(Icons.person_add),
                            onPressed: () async {
                              if (userProfile.relationshipStatus == "following") {
                                await disconnectUser(widget.currentUserId, userProfile.id);
                                _updateUserProfileStatus(userProfile.id, "notFollowing");
                              } else if (userProfile.relationshipStatus == "notFollowing") {
                                await sendConnectRequest(widget.currentUserId, userProfile.id);
                                _updateUserProfileStatus(userProfile.id, "pending");
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
