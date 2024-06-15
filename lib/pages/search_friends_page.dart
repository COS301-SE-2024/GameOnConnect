import 'package:flutter/material.dart';
import '../models/FriendSearch.dart';
import '../models/UserProfile.dart';

class FriendSearchPage extends StatefulWidget {
  @override
  _FriendSearchPageState createState() => _FriendSearchPageState();
}

class _FriendSearchPageState extends State<FriendSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FriendSearch _friendSearch = FriendSearch();

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
              stream: _friendSearch.searchFriends(_searchController.text),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<UserProfile> userProfiles = snapshot.data!;
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
                          // TODO: Implement follow/unfollow functionality
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
