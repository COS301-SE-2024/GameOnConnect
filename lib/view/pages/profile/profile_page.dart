import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
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
  //String? parentId ;

 Future<void> isConnectionOfParent() async {
  final connections = await ConnectionService().getConnections('connections');
  isConnectionParent= connections.contains(widget.uid);
}



 /* void getParent() {
   FirebaseAuth auth = FirebaseAuth.instance;
    parentId = auth.currentUser?.uid;
  }*/

@override
  void initState() {
    super.initState();
    isConnectionOfParent();
   // getParent();
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
                                          //Navigator.push(context, MaterialPageRoute(builder: (context) =>  ConnectionsList(isOwnProfile: widget.isOwnProfile,))); 
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ConnectionsList(isOwnProfile: widget.isOwnProfile, uid: widget.uid, loggedInUser: widget.loggedInUser,))); 
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
                        if ( profileData.visibility ||isConnectionParent ||widget.uid== widget.loggedInUser)...[
                          
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
                        ],
                        
                              
                      ],
              ),
            );
      }
        },
      ),
    );
  }
}
