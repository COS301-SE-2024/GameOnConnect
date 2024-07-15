//import 'package:delightful_toast/delight_toast.dart';
//import 'package:delightful_toast/toast/utils/enums.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
//import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
//import 'package:gameonconnect/services/profile_S/storage_service.dart';
//import 'package:gameonconnect/services/profile_S/profile_service.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/components/messaging/user_tile.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';

class Messaging extends StatefulWidget {
  const Messaging({super.key});

  @override
  State<Messaging> createState() => _MessagingState();
}

class _MessagingState extends State<Messaging> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final MessagingService _messagingService = MessagingService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.surface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'My Messages',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Theme.of(context).colorScheme.surface,
              fontSize: 20,
              letterSpacing: 0,
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: const [],
          centerTitle: false,
          elevation: 0,
        ),
        body: _buildUserList());
  }

  //build user list
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _messagingService.getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      //the profilepicture is getting really slowly we can speed this up by getting it via storage
      Map<String, dynamic> userData,
      BuildContext context) {
    Map<String, dynamic> userInfo =
        userData['username'] as Map<String, dynamic>? ?? {};
    String profileName = userInfo['profile_name'] as String? ?? "Unknown";
    String profilePictureUrl = userData['profile_picture'];

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
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
