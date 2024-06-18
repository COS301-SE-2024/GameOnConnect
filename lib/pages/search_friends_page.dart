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

// follow (friend request) 
Future<void> sendConnectRequest(String currentUserId, String otherUserId) async {
  // Add otherUserId to the current user's pending array
  final currentUserDoc = FirebaseFirestore.instance.collection('friends').doc(currentUserId);
  final otherUserDoc = FirebaseFirestore.instance.collection('friends').doc(otherUserId);

  return FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get the current user's document
    DocumentSnapshot currentUserSnapshot = await transaction.get(currentUserDoc);
    List<dynamic> currentUserPending = (currentUserSnapshot.data() as Map<String, dynamic>)['pending'];

    // Add otherUserId to currentUserPending list 
    if (!currentUserPending.contains(otherUserId)) {
      currentUserPending.add(otherUserId);
      transaction.update(currentUserDoc, {'pending': currentUserPending});
    }
   //-- change ui to pending and hour glass 
    // Handle sending a notification or updating other user's UI here if needed
  }).catchError((error) {
    print('Error sending friend request: $error');
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
                //await followUser(widget.currentUserId, userProfile.uid);
                setState(() {
                  userProfile.isFollowing = true;
                });
              },
            ),
          if (userProfile.isFollowing) // Show unfollow button if following
            TextButton(
              child: Text('Unfollow'),
              onPressed: () async {
                //await unfollowUser(widget.currentUserId, userProfile.uid);
                setState(() {
                  userProfile.isFollowing = false;
                });
              },
            ),
          IconButton(
            icon: userProfile.isFollowing ? Icon(Icons.person_remove) : Icon(Icons.person_add),
            onPressed: () async {
              if (userProfile.isFollowing) {
                //await unfollowUser(widget.currentUserId, userProfile.uid);
              } else {
                //await followUser(widget.currentUserId, userProfile.uid);
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
