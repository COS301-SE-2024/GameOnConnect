// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
//import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Create an instance of ProfileService
  final profileService = ProfileService();

  /*static final customCacheManager = CacheManager(
    Config(
      'userProfilePicturesCache',
      stalePeriod: Duration(days: 21),
    ),
  );*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: profileService.fetchProfileData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            key: Key('loadingScaffold'),
            appBar: AppBar(
              //title: const Text('Profile'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            key: Key('errorScaffold'),
            appBar: AppBar(
              //title: const Text('Profile'),
            ),
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Scaffold(
            key: Key('emptyDataScaffold'),
            appBar: AppBar(
              //title: const Text('Profile'),
            ),
            body: const Center(child: Text('No profile data found.')),
          );
        } else {
          var profileData = snapshot.data!;
          String profileName = profileData['profileName'];
          String username = profileData['username'];
          String profilePicture = profileData['profilePicture'];
          String profileBanner = profileData['profileBanner'];
          int uniqueNum = profileData['unique_num'];

          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Profile'),
                actions: [
                  Builder(
                    builder: (context) {
                      return IconButton(
                        key: Key('settings_icon_button'),
                        icon: const Icon(Icons.settings),
                        color: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          //Scaffold.of(context).openEndDrawer();
                          Navigator.pushNamed(context, '/settings');
                        },
                      );
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
                      // ignore: sized_box_for_whitespace
                      Container(
                        height: 170,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          //cacheManager: customCacheManager,
                          imageUrl: profileBanner,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          maxHeightDiskCache: 170,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                      Positioned(
                        bottom:
                            -50, // Half of the CircleAvatar's radius to align it properly
                        left: 50,
                        //profile picture
                        child: ClipOval(
                          // ignore: sized_box_for_whitespace
                          child: Container(
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              //cacheManager: customCacheManager,
                              imageUrl: profilePicture,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary,),
                              ),
                              fadeInDuration: Duration(milliseconds: 0),
                              fadeOutDuration: Duration(milliseconds: 0),
                              maxHeightDiskCache: 100,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
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
                      child: Text('$username#$uniqueNum', style: TextStyle(fontSize: 20)),
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
                        SingleChildScrollView(
                          child: FutureBuilder<List<Map<String, dynamic>?>>(
                            future: FriendServices().getFriends("friends").then(
                                (friendIds) => Future.wait(friendIds.map((id) =>
                                    FriendServices()
                                        .fetchFriendProfileData(id)))),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (snapshot.hasData) {
                                List<Map<String, dynamic>?> friendsProfiles =
                                    snapshot.data!;
                                return Column(children: [
                                  ElevatedButton.icon(
                                    icon: Icon(Icons.arrow_forward),
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/requests');
                                    },
                                    label: Text(
                                      "Connection Requests",
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary),
                                    ),
                                  ),
                                  ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: friendsProfiles.length,
                                    itemBuilder: (context, index) {
                                      var friendProfile =
                                          friendsProfiles[index];
                                      if (friendProfile != null) {
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.surface,
                                            border: Border.all(
                                              color: Theme.of(context).colorScheme.primary,
                                              width: 1.0,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              ClipOval(
                                                // ignore: sized_box_for_whitespace
                                                child: Container(
                                                  height: 45,
                                                  width: 45,
                                                  child: CachedNetworkImage(
                                                    //cacheManager: customCacheManager,
                                                    imageUrl: friendProfile[
                                                        'profilePicture'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                    fadeInDuration: Duration(
                                                        milliseconds: 0),
                                                    fadeOutDuration: Duration(
                                                        milliseconds: 0),
                                                    maxHeightDiskCache: 45,
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      friendProfile[
                                                              'profileName'] ??
                                                          'No Name Found',
                                                      style:  TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Theme.of(context).colorScheme.secondary,
                                                      ),
                                                    ),
                                                    Text(
                                                      friendProfile[
                                                              'username'] ??
                                                          'No Username Found',
                                                      style:  TextStyle(
                                                        fontFamily: 'Inter',
                                                        color: Theme.of(context).colorScheme.secondary,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.message),
                                                onPressed: () {
                                                  //here the message functionality will come in
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.more_vert),
                                                onPressed: () {
                                                  //here the remove friend option should be displayed.
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: Text('Profile not found'),
                                        );
                                      }
                                    },
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 10),
                                  )
                                ]);
                              } else {
                                return Text('No friends found.');
                              }
                            },
                          ),
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                               Text('Game Name',
                                  style: TextStyle(fontSize: 24,
                                      color: Theme.of(context).colorScheme.secondary)),
                              const SizedBox(height: 8),
                              //game tags
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical:
                                                7), // Add some padding around the text
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius: BorderRadius.circular(
                                              25), // The rounded ends of the rectangle
                                        ),
                                        child:  Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.circle, // dot icon
                                              size: 8.0,
                                              color: Theme.of(context).colorScheme.surface,
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
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child:  Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.circle,
                                              size: 8.0,
                                              color: Theme.of(context).colorScheme.surface,
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
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 7),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.secondary,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child:  Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Icon(
                                              Icons.circle,
                                              size: 8.0,
                                              color: Theme.of(context).colorScheme.surface,
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
                               Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text('Game Description',
                                      style: TextStyle(fontSize: 18,
                                      color: Theme.of(context).colorScheme.secondary)),
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
