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
      print("current user id"+ widget.currentUserId);
      return userProfiles;
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
                return ListView.builder(
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
