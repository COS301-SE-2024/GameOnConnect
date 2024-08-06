import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/view/components/profile/profile_buttons.dart';
import 'package:gameonconnect/view/components/profile/view_stats_button.dart';
import 'package:gameonconnect/view/pages/profile/connections_list.dart';
import 'package:gameonconnect/view/pages/profile/currently_playing.dart';
import 'package:gameonconnect/view/pages/profile/horizontal_gameslist.dart';
import 'package:gameonconnect/view/pages/profile/recent_activities.dart';
import 'package:gameonconnect/view/pages/profile/stats_list.dart';


class ProfilePage extends StatefulWidget {
  final String uid;
  final bool isOwnProfile;
  final bool isConnection;
  final String loggedInUser;

  // ignore: use_super_parameters
  const ProfilePage({ // Use named parameters
    Key? key,
    required this.uid, //u
    required this.isOwnProfile,
    required this.isConnection,
    required this.loggedInUser,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfileState();
}

//NB rename
class _ProfileState extends State<ProfilePage>  {
  bool isConnectionParent= false;
  late double totalTimePlayed ;
  late String roundedTotalTime;

 Future<void> isConnectionOfParent() async {
  final connections = await ConnectionService().getConnections('connections');
  isConnectionParent= connections.contains(widget.uid);
}

Future<void> getTimePlayed() async {
  totalTimePlayed = await StatsTotalTimeService().getTotalTimePlayedAll();
  roundedTotalTime = totalTimePlayed.toStringAsFixed(2);
}

@override
  void initState() {
    super.initState();
    isConnectionOfParent();
    getTimePlayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isOwnProfile
        ? const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 32, 
            fontWeight: 
            FontWeight.bold
            ),
          )
        : const Text('Profile',
            style: TextStyle(
            fontSize: 32, 
            fontWeight: 
            FontWeight.bold
            ),
          ),
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
        future: ProfileService().fetchProfileData(widget.uid),
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
                                  height: 250,
                                  width: MediaQuery.of(context).size.width,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                    color: Color.fromRGBO(42, 42, 42, 1.0),  
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      //image: CachedNetworkImageProvider(profileData.banner),
                                      //image:CachedNetworkImageProvider('https://wallup.net/wp-content/uploads/2018/03/19/579265-water-green-nature-waterfall.jpg'),
                                      image: CachedNetworkImageProvider('https://thumbs.dreamstime.com/b/portrait-young-pretty-female-gamer-playing-shooter-neon-lighting-portrait-young-pretty-female-gamer-playing-272077632.jpg'),
                                      colorFilter: ColorFilter.mode(
                                        Colors.grey.withOpacity(0.6), // Adjust opacity here
                                        BlendMode.dstATop, // Use dstATop for transparency
                                      ),
                                    ),
                                  ),
                                  ),
                                ),
                      
                                // Bottom container
                                //Center(
                               
                                    //),
                              ],
                            ),
                            // Profile picture
                            Positioned(
                              top: 50, // Adjust this value to move the profile picture downwards
                              left: 19,
                              child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 19, 0),
                          child: Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle, 
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
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 45),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  profileData.profileName,
                                  style:  TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                    letterSpacing: 0,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ), 
                                Row(
                                  children: [
                                    Icon(
                                      Icons.radio_button_checked,
                                      color: Theme.of(context).colorScheme.primary ,
                                      size: 15,
                                      ),
                                     const SizedBox(width: 5),   
                                    Text(
                                      'Currently Online',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        //fontSize: 12,
                                        letterSpacing: 0,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                              //),
                            ],
                          ),
                        ),
                      ],
                    ),
                            ),
                             Positioned(
                              left: 16,
                              bottom: 20,
                              right: 16,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ProfileButton(value: '${profileData.myGames.length}', title: 'Games'),
                                  ),
                                  Expanded(
                                    child: ProfileButton(value: '${profileData.numberOfconnections}', title: 'Connections'),
                                  ),
                                  Expanded(
                                    child: ProfileButton(value: '${roundedTotalTime} hrs', title: 'Time Played'),
                                  ),
                                 /* Expanded(
                                  child: FutureBuilder<double>(
                                    future: totalTimePlayed,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.waiting) {
                                        return const Center(child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(child: Text('Error: ${snapshot.error}'));
                                      } else {
                                        final timePlayed = snapshot.data ?? 0.0;
                                        return ProfileButton(
                                          value: '$timePlayed hrs',
                                          title: 'Time Played',
                                        );
                                      }
                                    },
                                  ),
                                ),*/
                                ],
                              ),
                              
                            ),
                                                  
                          ],
                        ),

                        const Positioned(
                              left: 16,
                              right: 16,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: StatsButton(),
                                  ),
                                 
                                ],
                              ),
                              
                            ),
                        //new

                        /*if ( profileData.visibility ||isConnectionParent ||widget.uid== widget.loggedInUser)...[
                          
                          // Conditionally display the CurrentlyPlaying widget
                      profileData.currentlyPlaying.isNotEmpty
                          ? CurrentlyPlaying(gameId: int.tryParse(profileData.currentlyPlaying) ?? 0)
                          : const SizedBox.shrink(), 
                        

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
                      profileData.myGames.isEmpty && widget.uid!= widget.loggedInUser
                          ?  const SizedBox.shrink()
                          : HorizontalGameList(
                              gameIds: profileData.myGames,
                              heading: 'My Games',
                            ),
                          
                      
                      const SizedBox(height: 5), //space 
                      profileData.wantToPlay.isEmpty && widget.uid!= widget.loggedInUser
                        ?  const SizedBox.shrink()
                        : HorizontalGameList(
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
                        ] else...[
                          const SizedBox(height: 20), // space
                          const Divider(),
                           const SizedBox(height: 20), // space
                           const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10), // space
                                Text(
                                  'This account is private',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],*/
                        
                              
                      ],
              ),
            );
      }
        },
      ),
    );
  }
}
