import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
//import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
//import 'package:gameonconnect/services/profile_S/profile_service.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/messaging/user_tile.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';
import 'package:intl/intl.dart';

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
          DelightToastBar(
                  builder: (context) {
                    return CustomToastCard(
                      title: Text(
                        'Check your internet connection',
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
          return const Text('An unexpected error occurred.');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(), //put a circular progress bar in the center
              ],
            ),
          );
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(context, userData))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      BuildContext context, Map<String, dynamic> userData) {
    String currentUserID = _authService.getCurrentUser()!.uid;
    String userID = userData['userID'] as String? ?? "default_user_id";
    Stream<DocumentSnapshot<Object?>> lastMessageStream = _messagingService
        .getLastMessage(currentUserID, userID); // get the last message stream

    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: lastMessageStream,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: CircularProgressIndicator(),
                ),
              ),
              Divider(
                height: 1,
                thickness: 0.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.error_outline);
        } else if (snapshot.hasData) {
          var documentSnapshot = snapshot.data!;
          Map<String, dynamic>? lastMessageSnapshot = documentSnapshot.data()
              as Map<String, dynamic>?; // use the last message
          String lastMessage = lastMessageSnapshot?['message_text'] ??
              'No message'; // use the text
          Timestamp timestamp =
              lastMessageSnapshot?['timestamp']; // get the time
          DateTime messageDateTime =
              timestamp.toDate(); // use date and time from the stored time
          String messageTime = DateFormat('yyyy-MM-dd – kk:mm')
              .format(messageDateTime); // convert the time to string for now
          String profilePictureUrl = userData[
              'profile_picture']; // get the profile picture from the user data
          String profileName =
              userData['username']['profile_name'] as String? ?? "Not found";
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
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}

/*
  Old code for _buildUserListItem
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    Map<String, dynamic> userInfo =
        userData['username'] as Map<String, dynamic>? ?? {};
    String profileName = userInfo['profile_name'] as String? ?? "Unknown";
    String profilePictureUrl =
        userData['profile_picture'] as String? ?? "default_picture_url";
    String receiverID = userData['userID'] as String? ?? "default_user_id";

    //we need to get more info here to build the tile successfully
    if (userData['userID'] != _authService.getCurrentUser()!.uid) {
      return UserTile(
        profilepictureURL: profilePictureUrl,
        text: profileName,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                profileName: profileName,
                receiverID: receiverID,
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }*/

/* More old code

Widget _buildUserListItem(
      BuildContext context, Map<String, dynamic> userData) {
    Map<String, dynamic> userInfo =
        userData['username'] as Map<String, dynamic>? ?? {};
    String profileName = userInfo['profile_name'] as String? ?? "Unknown";
    String userID = userData['userID'] as String? ?? "default_picture_url";
    String receiverID = userData['userID'] as String? ?? "default_user_id";
    return FutureBuilder<String>(
      future: storageService.getProfilePictureUrl(userID),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          //this is the loading state
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: SizedBox(
                  width: 65,
                  height: 65,
                  child: CircularProgressIndicator(),
                ),
              ),
              Divider(
                //added divider here to induce the same loading
                height: 1,
                thickness: 0.5,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          //add a possible toastbar to check the connection
          return const Icon(Icons.error_outline);
          //Text('Error: ${snapshot.error}'
        } else {
          //this widget means that the data loaded successfully
          String profilePictureUrl = snapshot.data!;
          if (userData['userID'] != _authService.getCurrentUser()!.uid) {
            return UserTile(
              profilepictureURL: profilePictureUrl,
              text: profileName,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      profileName: profileName,
                      receiverID: receiverID,
                    ),
                  ),
                );
              },
            );
          } else {
            return Container();
          }
        }
      },
    );
  }
}*/