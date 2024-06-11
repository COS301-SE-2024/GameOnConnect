// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/friend_service.dart';
import 'package:gameonconnect/services/profile_service.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  // Create an instance of ProfileService
  final profileService = ProfileService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: profileService.fetchProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(child: Text('No profile data found.')),
          );
        } else {
          var profileData = snapshot.data!;
          String profileName = profileData['profileName'];
          String username = profileData['username'];
          String profilePicture = profileData['profilePicture'];
          String profileBanner = profileData['profileBanner'];

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                leading: IconButton(
                  icon: const Icon(Icons.keyboard_backspace),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.pushNamed(context, '/edit-profile');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Navigator.pushNamed(context, '/customize');
                    },
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.people), text: 'Friends'),
                    Tab(icon: Icon(Icons.gamepad), text: 'Games'),
                    Tab(icon: Icon(Icons.event), text: 'Events'),
                  ],
                ),
              ),
              body: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      //banner
                      Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(profileBanner),
                          fit: BoxFit.cover,
                        )),
                        height: 170,
                      ),

                      Positioned(
                        bottom:
                            -50, // Half of the CircleAvatar's radius to align it properly
                        left: 50,
                        //profile picture
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor:
                              Colors.grey, // Placeholder for profile image
                          backgroundImage: NetworkImage(profilePicture),
                          child: profilePicture.isEmpty
                              ? CircularProgressIndicator()
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(profileName, style: TextStyle(fontSize: 24)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.only(left: 30),
                      child: Text(username, style: TextStyle(fontSize: 20)),
                    ),
                  ),
                  const SizedBox(height: 30),

                  //friends, games, events

                  const Divider(
                    color: Colors.black54,
                    thickness: 1.0,
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        FutureBuilder<List<Map<String, dynamic>?>>(
                          future: FriendServices().getFriends().then(
                              (friendIds) => Future.wait(friendIds.map((id) =>
                                  FriendServices()
                                      .fetchFriendProfileData(id)))),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              List<Map<String, dynamic>?> friendsProfiles =
                                  snapshot.data!;
                              return ListView.builder(
                                itemCount: friendsProfiles.length,
                                itemBuilder: (context, index) {
                                  var friendProfile = friendsProfiles[index];
                                  if (friendProfile != null) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: friendProfile[
                                                        'profilePicture'] !=
                                                    null &&
                                                friendProfile[
                                                        'profilePicture'] !=
                                                    ''
                                            ? NetworkImage(
                                                friendProfile['profilePicture'])
                                            : AssetImage(
                                                    'assets/default_profile.png')
                                                as ImageProvider,
                                      ),
                                      title: Text(friendProfile['name'] ??
                                          'No Name'), // Assuming 'name' is the key for profile name
                                      subtitle: Text(
                                          friendProfile['username'] ??
                                              'No Username'),
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text('Profile not found'),
                                    );
                                  }
                                },
                              );
                            } else {
                              return Text('No friends found.');
                            }
                          },
                        ),
                        Column(
                          children: <Widget>[
                            const Text('Game Name',
                                style: TextStyle(fontSize: 24)),
                            const SizedBox(height: 8),
                            //game tags
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical:
                                              7), // Add some padding around the text
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(
                                            25), // The rounded ends of the rectangle
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.circle, // dot icon
                                            size: 8.0,
                                            color: Colors.black,
                                          ),
                                          SizedBox(
                                              width:
                                                  8), // Space between the icon and the text
                                          Text('Action'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.circle,
                                            size: 8.0,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Sept 2022',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 7),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Icon(
                                            Icons.circle,
                                            size: 8.0,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'MOBA',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            //game description
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('Game Description',
                                    style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                    'Game Description Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...',
                                    style: TextStyle(fontSize: 14)),
                              ),
                            ),
                          ],
                        ),
                        Center(
                            child: Text(
                                'Events')), // Replace with actual Events content
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
