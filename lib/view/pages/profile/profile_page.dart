import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/view/pages/profile/connections_list.dart';
import 'package:gameonconnect/view/pages/profile/currently_playing.dart';
import 'package:gameonconnect/view/pages/profile/horizontal_gameslist.dart';
import 'package:gameonconnect/view/pages/profile/recent_activities.dart';
import 'package:gameonconnect/view/pages/profile/stats_list.dart';


class Profilenew extends StatefulWidget {
  final String uid;
  final bool isOwnProfile;

  Profilenew(String currentUserId, bool bool, {
    Key? key, // Use 'Key?' instead of 'super.key'
    required this.uid,
    required this.isOwnProfile,
  }) : super(key: key);


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
        actions: widget.isOwnProfile
            ? [
                Builder(
                  builder: (context) {
                    return IconButton(
                      key: const Key('settings_icon_button'),
                      icon: const Icon(Icons.settings),
                      color: Theme.of(context).colorScheme.secondary,
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body: FutureBuilder<Profile?>(
        //future: ProfileService().fetchProfile(),
        future: ProfileService(). fetchAllProfileData(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  const Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Profile data not found.'));
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
                                SizedBox(
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                    imageUrl: profileData.banner,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading indicator for banner
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                          profileData.profileName,
                                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '#${profileData.uniqueNumber}',
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          profileData.bio,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        const SizedBox(height: 10), //space 
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ConnectionsList())); 
                                        },
                                        child: RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: '${profileData.numberOfconnections}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: ' Connections',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                   color: Colors.black,
                                                  ),
                                              ),
                                            ],
                                          ),
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
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading indicator for profile picture
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //ProfileInfo(),
                        // Conditionally display the CurrentlyPlaying widget
                      profileData.currentlyPlaying.isNotEmpty
                          ? CurrentlyPlaying(gameId: int.tryParse(profileData.currentlyPlaying) ?? 0)
                          : const SizedBox.shrink(), // You can replace this with any widget or SizedBox.shrink() if you don't want to show anything
                        

                        //search
                        const SizedBox(height: 10), //space 
                        Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          key: const Key('searchTextField'),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 15, right: 15),
                            labelText: 'Search',
                            suffixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          //onSubmitted: _onSearchEntered,
                        ),
                        //friends, games, events
                      ),


                      const SizedBox(height: 10), //space 
                      HorizontalGameList(
                        gameIds: profileData.myGames,
                        heading: 'My Games',
                      ),


                      const SizedBox(height: 5), //space 
                      HorizontalGameList(
                        gameIds: profileData.wantToPlay,
                        heading: 'Want To Play',
                      ),


                      //change RECENT ACTIVITY 
                      profileData. recentActivities.isEmpty
                          ? const SizedBox.shrink()
                          : RecentActivityList(
                        gameStats: profileData. recentActivities,
                        heading: 'Recent Activity',
                      ),
                                           
                      const SizedBox(height: 20), //space 
                      const StatsList (
                        heading: 'Stats',
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
