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
          future: Future.wait(userDataList.map((data) async { //wait for all the data from the stream to be fetched
            var lastMessageSnapshot = await data['lastMessageStream'].first; //take the first snapshot
            return {
              'userData': data['userData'],
              'lastMessageSnapshot': lastMessageSnapshot,
            };
          }).toList()),
          builder: (context,
              AsyncSnapshot<List<Map<String, dynamic>>> sortedSnapshot) {
            if (sortedSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (sortedSnapshot.hasError) {
              return const Text('Please check your internet connection.');
            } else if (sortedSnapshot.hasData) {
              List<Map<String, dynamic>> sortedUserDataList =
                  sortedSnapshot.data!; //make a list of the data
              sortedUserDataList.sort((first, second) {
                var firstTimestamp = (first['lastMessageSnapshot'].data() //get the first timeStamp
                    as Map<String, dynamic>?)?['timestamp'] as Timestamp?;
                var secondTimestamp = (second['lastMessageSnapshot'].data() //get the second timeStamp
                    as Map<String, dynamic>?)?['timestamp'] as Timestamp?;
                return secondTimestamp?.compareTo(firstTimestamp ?? Timestamp.now()) ??
                    0; //compare timestamps
              });
              return ListView(
                children: sortedUserDataList.map<Widget>((data) { //map the data returned and return the user list to the _buildUserListItem to be built
                  return _buildUserListItem(
                      context, data['userData'], data['lastMessageSnapshot']);
                }).toList(),
              );
            } else { //if an error occurs, return text to check the internet connection
              return const Text('Please check your internet connection.');
            }
          },
        );
      },
    );
  }

  Widget _buildUserListItem(BuildContext context, Map<String, dynamic> userData,
    DocumentSnapshot<Object?> lastMessageSnapshot) { //check if a snapshot exists
      if (lastMessageSnapshot.exists) {
        Map<String, dynamic>? lastMessageData = lastMessageSnapshot.data()
            as Map<String, dynamic>?; // use the last message
        String lastMessage =
            lastMessageData?['message_text'] ?? 'No message'; // use the text
        Timestamp timestamp = lastMessageData?['timestamp']; // get the time
        DateTime messageDateTime =
            timestamp.toDate(); // use date and time from the stored time
        String messageTime = DateFormat('yyyy-MM-dd – kk:mm')
            .format(messageDateTime); // convert the time to string for now
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
          );
        } else {
          return Container();
        }
      } else {
        return Container();
      }
  }
}
