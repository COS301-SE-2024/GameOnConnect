import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/connection_M/friend_model.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/profile/bio.dart';
import 'package:gameonconnect/view/components/profile/profile_buttons.dart';
import 'package:gameonconnect/view/components/profile/action_button.dart';
import 'package:gameonconnect/view/pages/profile/connections_list.dart';
import 'package:gameonconnect/view/pages/profile/my_gameslist.dart';
import 'package:gameonconnect/view/pages/profile/want_to_play.dart';


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

List<GameStats> summedMyGames(List<GameStats> gameStatsList) {
  Map<String, GameStats> gameStatsMap = {};

  for (var stats in gameStatsList) {
    String key = '${stats.gameId}_${stats.uid}';
    if (gameStatsMap.containsKey(key)) {
      GameStats existingStats = gameStatsMap[key]!;
      int totalTimePlayed = existingStats.timePlayedLast + stats.timePlayedLast;
      String latestDate = existingStats.lastPlayedDate.compareTo(stats.lastPlayedDate) > 0
          ? existingStats.lastPlayedDate
          : stats.lastPlayedDate;

      gameStatsMap[key] = GameStats(
        gameId: stats.gameId,
        lastPlayedDate: latestDate,
        mood: stats.mood,
        timePlayedLast: totalTimePlayed,
        uid: stats.uid,
      );
    } else {
      gameStatsMap[key] = stats;
    }
  }

  return gameStatsMap.values.toList();
}

void _sendConnectionRequest(String targetUserId) async {
    try {
      await UserService().sendConnectionRequest(widget.loggedInUser, targetUserId);

    } catch (e) {
      //Error sending Connection request.
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error sending friend request. Please ensure that you have an active internet connection.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                );
              },
              position: DelightSnackbarPosition.top,
              autoDismiss: true,
              snackbarDuration: const Duration(seconds: 3))
          .show(
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }

void navigateToConnections(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConnectionsList(
          isOwnProfile: widget.isOwnProfile,
          uid: widget.uid,
          loggedInUser: widget.loggedInUser,
        ),
      ),
    );
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
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body:  StreamBuilder<Friend?>(
        stream: UserService().getCurrentUserConnectionsStream(widget.loggedInUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Profile data not found.'));
          } else {
            final connections = snapshot.data;
            isConnectionParent = connections?.friends.contains(widget.uid) ?? false;

            return FutureBuilder<Profile?>(
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
            final sumOfMygames= summedMyGames(profileData.myGames);
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
                                    color: const Color.fromRGBO(42, 42, 42, 1.0),  
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: CachedNetworkImageProvider(profileData.banner),
                                      //image: const CachedNetworkImageProvider('https://thumbs.dreamstime.com/b/portrait-young-pretty-female-gamer-playing-shooter-neon-lighting-portrait-young-pretty-female-gamer-playing-272077632.jpg'),
                                      colorFilter: ColorFilter.mode(
                                        Colors.grey.withOpacity(0.6), // Adjust opacity here
                                        BlendMode.dstATop, // Use dstATop for transparency
                                      ),
                                    ),
                                  ),
                                  ),
                                ),

                              ],
                            ),
                            Positioned(
                              top: 50, 
                              left: 19,
                              child:Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 19, 0),
                          child: Container(
                                height: 100,
                                width: 100,
                                decoration: const BoxDecoration(
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
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 45),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  profileData.profileName,
                                  style:  const TextStyle(
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
                                    const Text(
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
                              left: 12,
                              bottom: 20,
                              right: 12,
                              child:
                              Row(
                                children: [
                                  Expanded(
                                    child: ProfileButton(
                                      value: '${profileData.myGames.length}',
                                      title: 'Games'),
                                  ),
                                  Expanded(
                                    child: ProfileButton(
                                      value: '${profileData.numberOfconnections}', 
                                      title: 'Connections',
                                      onPressed: () => navigateToConnections(context),
                                      ),
                                  ),
                                  Expanded(
                                    child: ProfileButton(
                                      value: '$roundedTotalTime hrs', 
                                      title: 'Time Played'),
                                  ),
                                 
                                ],
                              ),
                              
                            ),
                                                  
                          ],
                        ),
 
                      if ( profileData.visibility ||isConnectionParent ||widget.uid== widget.loggedInUser)...[
                        
                         Padding(
                          padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Row(
                            children: [
                              if(profileData.visibility && !isConnectionParent )
                                  Expanded(
                                    child: ActionButton(
                                      type: 'connect',
                                      onPressed: () => _sendConnectionRequest(widget.uid),
                                    ),
                                  ),

                              if(profileData.visibility && !isConnectionParent )
                                  SizedBox(width: 12),

                              Expanded(
                                child: ActionButton(
                                  type: 'stats',
                                  onPressed: () => navigateToConnections(context), //change to go to stats page 
                                ),
                              ),
                            ],
                        ),
                          
                        ),
                        

                        const SizedBox(height: 24),
                        Bio(bio: profileData.bio, isOwnProfile: widget.isOwnProfile,),

                        const SizedBox(height: 24),
                        profileData.myGames.isEmpty && widget.uid!= widget.loggedInUser
                        ?  const SizedBox.shrink()
                        :  widget.uid!= widget.loggedInUser
                          ? MyGameList(
                            myGameStats: sumOfMygames, 
                            heading: 'Games', 
                            currentlyPlaying: profileData.currentlyPlaying,
                            gameActivities: profileData.myGames,
                            )
                          : MyGameList(
                            myGameStats: sumOfMygames, 
                            heading: 'My Games', 
                            currentlyPlaying: profileData.currentlyPlaying,
                            gameActivities: profileData.myGames,
                            ),
                        
                       
                        
                        const Padding(
                          padding: EdgeInsets.fromLTRB(12, 10, 12, 24),
                          child: Divider(
                            color: Color(0xFF2A2A2A),//Dark grey,
                            thickness: 0.5,
                          ),
                        ),

                        WantToPlayList(gameIds: profileData.wantToPlay, heading: 'Want to play'), 
                        const SizedBox(height: 24),

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
      );
          }
        },
      ),
      
      
    );
  }
}
