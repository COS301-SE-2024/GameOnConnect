import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/game_library_S/my_games_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/view/pages/profile/currently_playing.dart';
import 'package:gameonconnect/view/pages/profile/horizontal_gameslist.dart';
import 'package:gameonconnect/view/pages/profile/profile_info.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'stats_card.dart';

class Profilenew extends StatefulWidget {
  const Profilenew({super.key});

  @override
  State<Profilenew> createState() => _ProfileState();
}

//NB rename
class _ProfileState extends State<Profilenew>  {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [ // NB only show if its my own profile
                  Builder(
                    builder: (context) {
                      return IconButton(
                        key: const Key('settings_icon_button'),
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
      ),
      body: FutureBuilder<Profile?>(
        future: ProfileService().fetchProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return Center(child: Text('Profile data not found.'));
          } else {
            final profileData = snapshot.data!;
      return SingleChildScrollView(
        child: Column(
          children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Column(
                        children: [
                          // Banner
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: profileData.banner,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Loading indicator for banner
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Bottom container
                          //Center(
                          Container(
                            margin: const EdgeInsets.fromLTRB(50, 0, 3, 13),
                            child:Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 55), //space 
                                  Text(
                                    '${profileData.profileName}',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '#${profileData.uniqueNumber}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '${profileData.bio}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 10), //space 
                                  RichText(
                                    text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '${profileData.numberOfconnections}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: ' Connections',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                              //),
                        ],
                      ),
                      // Profile picture
                      Positioned(
                        top: 120, // Adjust this value to move the profile picture downwards
                        //left: (MediaQuery.of(context).size.width - 100) / 2, // Center the profile picture
                        left: 50,
                        child:Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, // Make it circular
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary, // Set your desired border color
                              width: 3, // Set the border width
                            ),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: profileData.profilePicture,
                              placeholder: (context, url) => Center(child: CircularProgressIndicator()), // Loading indicator for profile picture
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  //display the currely playing widget here
                  //ProfileInfo(),
                  const SizedBox(height: 20), //space 
                  CurrentlyPlaying(gameId: int.tryParse(profileData.currentlyPlaying) ?? 0),

                  //search
                   const SizedBox(height: 10), //space 
                  Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    key: Key('searchTextField'),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 15, right: 15),
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                    //onSubmitted: _onSearchEntered,
                  ),
                ),

                const SizedBox(height: 15), //space 
                HorizontalGameList(
                  myGameIds: profileData.myGames,
                  heading: 'My Games',
                ),

                const SizedBox(height: 15), //space 
                HorizontalGameList(
                  myGameIds: profileData.wantToPlay,
                  heading: 'Want To Play',
                ),
                  
                ],
        ),
      );
      }
        },
      ),
    );
  }
}
