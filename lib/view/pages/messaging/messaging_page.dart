import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
//import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/components/messaging/user_tile.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final MessagingService _messagingService = MessagingService();
  final AuthService _authService = AuthService();
  final StorageService storageService = StorageService();
  final BadgeService _badgeService = BadgeService();

  @override
  void initState() {
    super.initState();
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: BackButtonAppBar(
          title: 'Messages',
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: const Key('Back_button_key'),
          textkey: const Key('messages_text'),
        ),
        body: _buildUserList());
  }

  //build user list
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _messagingService
          .getAllChatsForCurrentUser(), //get the existing chats
      builder: (context, snapshot) {
        if (snapshot.hasError) {
      CustomSnackbar().show(context,
                        'Check your internet connection',
                    );
          return const Text('An unexpected error occurred.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ), //put a circular progress bar in the center
              ],
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text(
              'No existing chats found.',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
          );
        }

        String currentUserID =
            _authService.getCurrentUser()!.uid; //get the logged in user
        //get the user data and the last message stream
        List<Map<String, dynamic>> userDataList =
            snapshot.data!.map<Map<String, dynamic>>((userData) {
          String userID = userData['userID'] as String? ?? "default_user_id";
          Stream<DocumentSnapshot<Object?>> lastMessageStream =
              _messagingService.getLastMessage(
                  currentUserID, userID); // get the last message stream
          return {
            //return the data as a list
            'userData': userData,
            'lastMessageStream': lastMessageStream,
          };
        }).toList();

        return FutureBuilder(
          future: Future.wait(userDataList.map((data) async {
            //wait for all the data from the stream to be fetched
            var lastMessageSnapshot =
                await data['lastMessageStream'].first; //take the first snapshot
            return {
              'userData': data['userData'],
              'lastMessageSnapshot': lastMessageSnapshot,
            };
          }).toList()),
          builder: (context,
              AsyncSnapshot<List<Map<String, dynamic>>> sortedSnapshot) {
            if (sortedSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              );
            } else if (sortedSnapshot.hasError) {
              return const Text('Please check your internet connection.');
            } else if (sortedSnapshot.hasData) {
              List<Map<String, dynamic>> sortedUserDataList =
                  sortedSnapshot.data!; //make a list of the data
              sortedUserDataList.sort((first, second) {
                var firstTimestamp = (first['lastMessageSnapshot']
                        .data() //get the first timeStamp
                    as Map<String, dynamic>?)?['timestamp'] as Timestamp?;
                var secondTimestamp = (second['lastMessageSnapshot']
                        .data() //get the second timeStamp
                    as Map<String, dynamic>?)?['timestamp'] as Timestamp?;
                return secondTimestamp
                        ?.compareTo(firstTimestamp ?? Timestamp.now()) ??
                    0; //compare timestamps
              });
              return ListView(
                children: sortedUserDataList.map<Widget>((data) {
                  //map the data returned and return the user list to the _buildUserListItem to be built
                  return _buildUserListItem(
                      context, data['userData'], data['lastMessageSnapshot']);
                }).toList(),
              );
            } else {
              //if an error occurs, return text to check the internet connection
              return const Text('Please check your internet connection.');
            }
          },
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> userData,
      DocumentSnapshot<Object?> lastMessageSnapshot) {
    //check if a snapshot exists
    if (lastMessageSnapshot.exists) {
      Map<String, dynamic>? lastMessageData = lastMessageSnapshot.data()
          as Map<String, dynamic>?; // use the last message
      String lastMessage =
          lastMessageData?['message_text'] ?? 'No message'; // use the text
      Timestamp timestamp = lastMessageData?['timestamp']; // get the time
      DateTime messageDateTime =
          timestamp.toDate(); // use date and time from the stored time

      String messageTime = "";
      DateTime today = DateTime.now();
      if (messageDateTime.year == today.year &&
          messageDateTime.month == today.month &&
          messageDateTime.day == today.day) {
        messageTime = DateFormat('kk:mm').format(
            messageDateTime); //if the message is today then show the time
      } else {
        messageTime = DateFormat('yyyy-MM-dd').format(
            messageDateTime); //if the message was sent on a different day then show the date
      }

      String profilePictureUrl = userData[
          'profile_picture']; // get the profile picture from the user data
      String profileName =
          userData['username']['profile_name'] as String? ?? "Not found";
      String userID = userData['userID'] as String? ?? "default_user_id";
      String receiverID = userID;

      if (userID != _authService.getCurrentUser()!.uid) {
        return UserTile(
          profilepictureURL: profilePictureUrl,
          text: profileName,
          lastMessage: lastMessage,
          time: messageTime,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  profileName: profileName,
                  receiverID: receiverID,
                  profilePicture: profilePictureUrl,
                ),
              ),
            );
          },
          profileImage: CachedNetworkImage(
            imageUrl: profilePictureUrl,
            width: 65,
            height: 65,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingWidget(),
            errorWidget: (context, url, error) => _buildErrorWidget(),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeInCurve: Curves.easeIn,
            memCacheWidth: 65,
            memCacheHeight: 65,
            maxWidthDiskCache: 65,
            maxHeightDiskCache: 65,
          ),
        );
      } else {
        return Container();
      }
    } else {
      return Container();
    }
  }

  //this widget builds while the image is still loading
  Widget _buildLoadingWidget() {
    return SizedBox(
      width: 65,
      height: 65,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingAnimationWidget.halfTriangleDot(
          color: Theme.of(context).colorScheme.primary,
          size: 36,
        ),
      ),
    );
  }

  //this widget builds if there is an error with the image
  Widget _buildErrorWidget() {
    return Container(
      width: 65,
      height: 65,
      color: Colors.grey[300],
      child: const Icon(Icons.error),
    );
  }
}

