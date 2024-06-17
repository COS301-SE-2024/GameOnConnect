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


   Stream<List<UserProfile>> searchFriends(String query) {
  return db
    .collection('profile_data')
    .where('username.profile_name', isGreaterThanOrEqualTo: query.toLowerCase())
    .where('username.profile_name', isLessThan: query.toLowerCase() + '\uf8ff')
    .snapshots()
    .asyncMap((snapshot) async {
      List<UserProfile> userProfiles = [];
      for (var doc in snapshot.docs) {
        UserProfile userProfile = await UserProfile.fromDocumentSnapshot(doc);
        userProfiles.add(userProfile);
      }
      return userProfiles;
    });
}

// Function to follow a user
Future<void> followUser(String currentUserId, String friendId) async {
  final DocumentReference currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  final DocumentReference friendUserDoc = FirebaseFirestore.instance.collection('friends').doc(friendId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get the current user's document
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    List<dynamic> currentUserFriends = (currentUserSnapshot.data() as Map<String, dynamic>)['friends'];

    // Get the friend's document
    DocumentSnapshot friendUserSnapshot = await transaction.get(friendUserDoc);
    List<dynamic> friendUserFriends = (friendUserSnapshot.data() as Map<String, dynamic>)['friends'];

    // Add each other's IDs to their respective friends arrays
    if (!currentUserFriends.contains(friendId)) {
      currentUserFriends.add(friendId);
      transaction.update(currentUserDoc, {'friends': currentUserFriends});
    }
    if (!friendUserFriends.contains(currentUserId)) {
      friendUserFriends.add(currentUserId);
      transaction.update(friendUserDoc, {'friends': friendUserFriends});
    }
  }).catchError((error) {
    print('Error following user: $error');
  });
}

// Function to unfollow a user
Future<void> unfollowUser(String currentUserId, String friendId) async {
  final DocumentReference currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  final DocumentReference friendUserDoc = FirebaseFirestore.instance.collection('friends').doc(friendId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get the current user's document
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    List<dynamic> currentUserFriends = (currentUserSnapshot.data() as Map<String, dynamic>)['friends'];

    // Get the friend's document
    DocumentSnapshot friendUserSnapshot = await transaction.get(friendUserDoc);
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
  }).catchError((error) {
    print('Error unfollowing user: $error');
  });
}

/**
 * // Example of how to call these functions in your IconButton's onPressed callback:
IconButton(
  icon: userProfile.isFollowing ? Icon(Icons.person_remove) : Icon(Icons.person_add),
  onPressed: () async {
    if (userProfile.isFollowing) {
      await unfollowUser(widget.currentUserId, userProfile.uid);
    } else {
      await followUser(widget.currentUserId, userProfile.uid);
    }
    
    // Update the state to reflect the new follow status
    setState(() {
      userProfile.isFollowing = !userProfile.isFollowing;
    });
  },
),
 */


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
                  return Center(child: CircularProgressIndicator()); // Centered CircularProgressIndicator
                }
                List<UserProfile> userProfiles = snapshot.data!.where((userProfile) => userProfile.uid != widget.currentUserId).toList(); // Filter out current user
                return 
                /*ListView.builder(
                  itemCount: userProfiles.length,
                  itemBuilder: (context, index) {
                    UserProfile userProfile = userProfiles[index];
                    return ListTile(
                      title: Text(userProfile.username),
                      trailing: IconButton(
                        icon: userProfile.isFollowing
                            ? Icon(Icons.person_remove)
                            : Icon(Icons.person_add),
                        onPressed: () {
                          //Implement follow/unfollow functionality
                        },
                      ),
                    );
                  },
                );*/
                ListView.builder(
  itemCount: userProfiles.length,
  itemBuilder: (context, index) {
    UserProfile userProfile = userProfiles[index];
    return ListTile(
      title: Text(userProfile.username),
      //subtitle: Text(userProfile.isFollowing ? 'Following' : 'Not Following'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!userProfile.isFollowing) // Show follow button if not following
            TextButton(
              child: Text('Follow'),
              onPressed: () async {
                await followUser(widget.currentUserId, userProfile.uid);
                setState(() {
                  userProfile.isFollowing = true;
                });
              },
            ),
          if (userProfile.isFollowing) // Show unfollow button if following
            TextButton(
              child: Text('Unfollow'),
              onPressed: () async {
                await unfollowUser(widget.currentUserId, userProfile.uid);
                setState(() {
                  userProfile.isFollowing = false;
                });
              },
            ),
          IconButton(
            icon: userProfile.isFollowing ? Icon(Icons.person_remove) : Icon(Icons.person_add),
            onPressed: () async {
              if (userProfile.isFollowing) {
                await unfollowUser(widget.currentUserId, userProfile.uid);
              } else {
                await followUser(widget.currentUserId, userProfile.uid);
              }
              setState(() {
                userProfile.isFollowing = !userProfile.isFollowing;
              });
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
