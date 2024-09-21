// ignore_for_file: unnecessary_const
// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/connection_M/friend_model.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/profile/bio.dart';
import 'package:gameonconnect/view/components/profile/profile_buttons.dart';
import 'package:gameonconnect/view/components/profile/action_button.dart';
import 'package:gameonconnect/view/components/profile/request_container.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';
import 'package:gameonconnect/view/pages/profile/connections_list.dart';
import 'package:gameonconnect/view/pages/profile/my_gameslist.dart';
import 'package:gameonconnect/view/pages/profile/want_to_play.dart';
import 'package:gameonconnect/view/pages/stats/stats_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  final bool isOwnProfile;
  final bool isConnection;
  final String loggedInUser;

  // ignore: use_super_parameters
  const ProfilePage({
    // Use named parameters
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
class _ProfileState extends State<ProfilePage> {
  final BadgeService _badgeService = BadgeService();
  final ProfileService _profileService = ProfileService();
  final MessagingService _messagingService = MessagingService();
  bool isParentsConnection = false;
  late double totalTimePlayed;
  late String roundedTotalTime;
  bool isPendingOfParent = false;
  bool isConnectionOfParent = false;
  bool isRequestToParent = false;

  Future<void> isConnectionOfLoggedInUser() async {
    final connections = await ConnectionService().getConnections('connections');
    isConnectionOfParent = connections.contains(widget.uid);
  }

  Future<void> isPendingOfLoggedInUser() async {
    final connections = await ConnectionService().getConnections('pending');
    isPendingOfParent = connections.contains(widget.uid);
  }

  Future<void> isRequestToLoggedInUser() async {
    final connections = await ConnectionService().getConnections('requests');
    isRequestToParent = connections.contains(widget.uid);
  }

  Future<void> getRelationToLoggedInUser() async {
    isConnectionOfLoggedInUser();
    isPendingOfLoggedInUser();
    isRequestToLoggedInUser();
  }

  Future<void> getTimePlayed() async {
    totalTimePlayed =
        await StatsTotalTimeService().getTotalTimePlayedAll(widget.uid);
    roundedTotalTime = totalTimePlayed.toStringAsFixed(2);
  }

  List<GameStats> summedMyGames(List<GameStats> gameStatsList) {
    Map<String, GameStats> gameStatsMap = {};

    for (var stats in gameStatsList) {
      String key = '${stats.gameId}_${stats.uid}';
      if (gameStatsMap.containsKey(key)) {
        GameStats existingStats = gameStatsMap[key]!;
        int totalTimePlayed =
            existingStats.timePlayedLast + stats.timePlayedLast;
        String latestDate =
            existingStats.lastPlayedDate.compareTo(stats.lastPlayedDate) > 0
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

  void _disconnect() async {
    try {
      await UserService().disconnect(widget.loggedInUser, widget.uid);
      setState(() {
        isConnectionOfParent = false;
      });
    } catch (e) {
      //'Error unfollowing user'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error unfollowing user. Please ensure that you have an active internet connection.',
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
        context,
      );
    }
  }

  void _accept() async {
    try {
      await ConnectionService().acceptConnectionRequest(widget.uid);
      setState(() {
        isRequestToParent = false;
        isConnectionOfParent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Accepted')),
      );
    } catch (e) {
      //'Error unfollowing user'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error accepting user. Please ensure that you have an active internet connection.',
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
        context,
      );
    }
  }

  void _reject() async {
    try {
      await ConnectionService().rejectConnectionRequest(widget.uid);
      setState(() {
        isRequestToParent = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rejected')),
      );
    } catch (e) {
      //'Error unfollowing user'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error rejecting user. Please ensure that you have an active internet connection.',
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
        context,
      );
    }
  }

  void _sendConnectionRequest() async {
    try {
      await UserService()
          .sendConnectionRequest(widget.loggedInUser, widget.uid);
      setState(() {
        isRequestToParent = false;
        isPendingOfParent = true;
      });
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
        context,
      );
    }
  }

  void _undoConnectionRequest() async {
    try {
      await UserService()
          .undoConnectionRequest(widget.loggedInUser, widget.uid);
      setState(() {
        isPendingOfParent = false;
      });
    } catch (e) {
      //'Error canceling friend request'
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'An error occurred. Please retry',
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

  void navigateToStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatsPage(userID: widget.uid)),
    );
    if (widget.isOwnProfile) {
      BadgeService().unlockViewStatsComponent();
    }
  }

  @override
  void initState() {
    super.initState();
    getRelationToLoggedInUser();
    getTimePlayed();
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isOwnProfile
            ? const Text(
                'My Profile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              )
            : const Text(
                'Profile',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
        actions: widget.isOwnProfile
            ? [
                Builder(
                  builder: (context) {
                    return IconButton(
                      key: const Key('settings_icon_button'),
                      icon: const Icon(Icons.settings),
                      color: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    );
                  },
                ),
              ]
            : null,
      ),
      body: StreamBuilder<Friend?>(
        stream:
            UserService().getCurrentUserConnectionsStream(widget.loggedInUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: Theme.of(context).colorScheme.primary,
                size: 36,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('Profile data not found.'));
          } else {
            final connections = snapshot.data;
            isParentsConnection =
                connections?.friends.contains(widget.uid) ?? false;

            return FutureBuilder<Profile?>(
              future: _profileService.fetchProfileData(widget.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    key: const Key('loadingScaffold'),
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: Theme.of(context).colorScheme.primary,
                      size: 36,
                    ),
                  ); // Show loading indicator
                } else if (snapshot.hasError) {
                  return Center(
                      key: const Key('errorScaffold'),
                      child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.data == null) {
                  return const Center(child: Text('Profile data not found.'));
                } else {
                  final profileData = snapshot.data!;
                  final sumOfMygames = summedMyGames(profileData.myGames);
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
                                      color:
                                          const Color.fromRGBO(42, 42, 42, 1.0),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: CachedNetworkImageProvider(
                                            profileData.banner),
                                        //image: const CachedNetworkImageProvider('https://thumbs.dreamstime.com/b/portrait-young-pretty-female-gamer-playing-shooter-neon-lighting-portrait-young-pretty-female-gamer-playing-272077632.jpg'),
                                        colorFilter: ColorFilter.mode(
                                          Colors.grey.withOpacity(
                                              0.6), // Adjust opacity here
                                          BlendMode
                                              .dstATop, // Use dstATop for transparency
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 19, 0),
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: profileData.profilePicture,
                                          placeholder: (context, url) => Center(
                                            child: LoadingAnimationWidget
                                                .halfTriangleDot(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 36,
                                            ),
                                          ), // Loading indicator for profile picture
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 45),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 5),
                                          child: Text(
                                            profileData.profileName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 24,
                                              letterSpacing: 0,
                                              color: Color(0xFFFFFFFF),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          '#${profileData.uniqueNumber.toString()}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w400,
                                            //fontSize: 12,
                                            letterSpacing: 0,
                                            color: Color(0xFFFFFFFF),
                                          ),
                                        ),
                                        if (profileData.currentlyPlaying != '')
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_checked,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                size: 15,
                                              ),
                                              const SizedBox(width: 5),
                                              const Text(
                                                'Currently playing',
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ProfileButton(
                                        value:
                                            '${_profileService.mygGamesLength}',
                                        title: 'Games'),
                                  ),
                                  Expanded(
                                    child: ProfileButton(
                                      value:
                                          '${profileData.numberOfconnections}',
                                      title: 'Connections',
                                      onPressed: profileData.visibility ||
                                              isParentsConnection ||
                                              widget.uid == widget.loggedInUser
                                          ? () => navigateToConnections(context)
                                          : null,
                                    ),
                                  ),
                                  Expanded(
                                    child: ProfileButton(
                                      value: '$roundedTotalTime hrs',
                                      title: 'Time Played',
                                      onPressed: () => navigateToStats(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (profileData.visibility ||
                            isParentsConnection ||
                            widget.uid == widget.loggedInUser) ...[
                          if (isRequestToParent)
                            RequestContainer(
                                requester: profileData.profileName,
                                accept: () => _accept(),
                                reject: () => _reject()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (widget.uid != widget.loggedInUser) ...[
                                  (isPendingOfParent)
                                      ? Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 12, 0),
                                            child: ActionButton(
                                                type: 'Pending',
                                                onPressed: () =>
                                                    _undoConnectionRequest(),
                                                icon: Icons.hourglass_bottom),
                                          ),
                                        )
                                      : (isConnectionOfParent)
                                          ? Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 0, 12, 0),
                                                child: ActionButton(
                                                    type: 'Connected',
                                                    onPressed: () =>
                                                        _disconnect(), // drop down for disconnect
                                                    icon: Icons.person),
                                              ),
                                            )
                                          : (isRequestToParent)
                                              ? const SizedBox.shrink()
                                              : Expanded(
                                                  // not connected yet
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 0, 12, 0),
                                                    child: ActionButton(
                                                        type: 'Connect',
                                                        onPressed: () =>
                                                            _sendConnectionRequest(),
                                                        icon: Icons.person_add),
                                                  ),
                                                ),
                                ],
                                /*Expanded(
                                  //here is the view stats button
                                  child: ActionButton(
                                    type: 'stats',
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => StatsPage(
                                                userID: widget
                                                    .uid)), //how do i get the correct userID t display here - get it and use it here
                                      );
                                    },
                                    icon: Icons.bar_chart 
                                  ),
                                ),*/

                                if (widget.uid != widget.loggedInUser) ...[
                                  Expanded(
                                      child: ActionButton(
                                          type: 'Message',
                                          onPressed: () async {
                                            String conversationID =
                                                await _messagingService
                                                    .findConversationID(
                                                        widget.loggedInUser,
                                                        widget.uid);
                                            if (conversationID == 'Not found') {
                                              List<String> newList = [
                                                widget.loggedInUser,
                                                widget.uid
                                              ];
                                              conversationID =
                                                  await _messagingService
                                                      .createConversation(
                                                          newList);
                                            }
                                            if (mounted) {
                                              if (!context.mounted) return;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                    profileName:
                                                        profileData.profileName,
                                                    receiverID: widget.uid,
                                                    profilePicture: profileData
                                                        .profilePicture,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icons.send)),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          profileData.bio.isEmpty
                              ? const SizedBox.shrink()
                              : Bio(
                                  bio: profileData.bio,
                                  isOwnProfile: widget.isOwnProfile,
                                ),
                          const SizedBox(height: 24),
                          profileData.myGames.isEmpty &&
                                  widget.uid != widget.loggedInUser
                              ? const SizedBox.shrink()
                              : widget.uid != widget.loggedInUser
                                  ? MyGameList(
                                      myGameStats: sumOfMygames,
                                      heading: 'Games',
                                      currentlyPlaying:
                                          profileData.currentlyPlaying,
                                      gameActivities: profileData.myGames,
                                      isOwnProfile: widget.isOwnProfile,
                                    )
                                  : MyGameList(
                                      myGameStats: sumOfMygames,
                                      heading: 'My Games',
                                      currentlyPlaying:
                                          profileData.currentlyPlaying,
                                      gameActivities: profileData.myGames,
                                      isOwnProfile: widget.isOwnProfile),
                          profileData.myGames.isEmpty &&
                                  widget.uid != widget.loggedInUser
                              ? const SizedBox.shrink()
                              : Column(children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(12, 10, 12, 24),
                                    child: Divider(
                                      color: Color(0xFF2A2A2A), //Dark grey,
                                      thickness: 0.5,
                                    ),
                                  ),
                                  WantToPlayList(
                                      gameIds: profileData.wantToPlay,
                                      heading: 'Want to play',
                                      isOwnProfile: widget.isOwnProfile),
                                  const SizedBox(height: 24)
                                ]),
                        ] else ...[
                          if (isRequestToParent)
                            RequestContainer(
                                requester: profileData.profileName,
                                accept: () => _accept(),
                                reject: () => _reject()),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 19, 12, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (isPendingOfParent)
                                    ? Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 12, 0),
                                          child: ActionButton(
                                              type: 'Pending',
                                              onPressed: () =>
                                                  _undoConnectionRequest(),
                                              icon: Icons.hourglass_bottom),
                                        ),
                                      )
                                    : (isConnectionOfParent)
                                        ? Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 12, 0),
                                              child: ActionButton(
                                                  type: 'Connected',
                                                  onPressed: () =>
                                                      _disconnect(),
                                                  icon: Icons.person),
                                            ),
                                          )
                                        : (isRequestToParent)
                                            ? const SizedBox.shrink()
                                            : Expanded(
                                                // not connected yet
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 0, 12, 0),
                                                  child: ActionButton(
                                                      type: 'Connect',
                                                      onPressed: () =>
                                                          _sendConnectionRequest(),
                                                      icon: Icons.person_add),
                                                ),
                                              ),
                                if (widget.uid != widget.loggedInUser) ...[
                                  Expanded(
                                      child: ActionButton(
                                          type: 'Message',
                                          onPressed: () async {
                                            String conversationID =
                                                await _messagingService
                                                    .findConversationID(
                                                        widget.loggedInUser,
                                                        widget.uid);
                                            if (conversationID == 'Not found') {
                                              List<String> newList = [
                                                widget.loggedInUser,
                                                widget.uid
                                              ];
                                              conversationID =
                                                  await _messagingService
                                                      .createConversation(
                                                          newList);
                                            }
                                            if (mounted) {
                                              if (!context.mounted) return;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ChatPage(
                                                    profileName:
                                                        profileData.profileName,
                                                    receiverID: widget.uid,
                                                    profilePicture: profileData
                                                        .profilePicture,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          icon: Icons.send)),
                                ],
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 12),
                            child: Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize
                                    .min, // This ensures the Column takes up only the necessary space
                                children: [
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        width: 2,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.lock_outline,
                                      size: 40,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 82),
                                    child: Text(
                                      'This account is Private',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ], // else
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
