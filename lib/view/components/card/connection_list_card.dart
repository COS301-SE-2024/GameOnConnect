
// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/card/custom_snackbar.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class ConnectionCardWidget extends StatefulWidget {
  final String image;
  final String username;
  final String uniqueNum;
  final String uid;
  final String page;
  final List<String>? invited;
  final String loggedInUser;
  final bool isOwnProfile;
  final void Function(String uid, bool selected) onSelected;
  final void Function(String uid)? onDisconnected;
  final void Function(String uid)? onAccepted;
  final void Function(String uid)? onRejected;

  const ConnectionCardWidget({
    super.key,
    required this.image,
    required this.username,
    required this.uid,
    required this.uniqueNum,
    required this.onSelected,
    required this.page,
    required this.loggedInUser,
    required this.isOwnProfile,
    this.onDisconnected,
    this.onAccepted,
    this.onRejected,
    this.invited,
  });

  @override
  State<ConnectionCardWidget> createState() => _ConnectionCardWidgetState();
}

class _ConnectionCardWidgetState extends State<ConnectionCardWidget> {
  final BadgeService _badgeService = BadgeService();
  final MessagingService _messagingService = MessagingService();
  late List<String>? invited;
  late String image;
  late String username;
  late String uniqueNum;
  late String uid;
  late String page;
  bool selected = false;

  @override
  void initState() {
    super.initState();
    image = widget.image;
    username = widget.username;
    uniqueNum = widget.uniqueNum;
    uid = widget.uid;
    page = widget.page;
    invited = widget.invited;
    if (invited == null) {
      selected = false;
    } else {
      selected = invited!.contains(uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _disconnect(String targetUserId) async {
    try {
      await ConnectionService().disconnect(targetUserId);
      if (widget.onDisconnected != null) {
        widget.onDisconnected!(
            targetUserId); // Notify parent widget if callback is provided
      }
    } catch (e) {
      //'Error unfollowing user'
     CustomSnackbar().show(context,
                    'Error disconnecting user. Please ensure that you have an active internet connection.',
                );

    }
  }

  void _accept(String targetUserId) async {
    try {
      await ConnectionService().acceptConnectionRequest(targetUserId);
      if (widget.onAccepted != null) {
        widget.onAccepted!(
            targetUserId); // Notify parent widget if callback is provided
      }
    } catch (e) {
      //'Error unfollowing user'
   CustomSnackbar().show(context,
                    'Error accepting user. Please ensure that you have an active internet connection.',
      );
    }
  }

  void _reject(String targetUserId) async {
    try {
      await ConnectionService().rejectConnectionRequest(targetUserId);
      if (widget.onRejected != null) {
        widget.onRejected!(
            targetUserId); // Notify parent widget if callback is provided
      }
    } catch (e) {
      //'Error unfollowing user'
     CustomSnackbar().show(context,
                    'Error rejecting user. Please ensure that you have an active internet connection.',
      );
    }
  }

  void _handleMenuSelection(
      String value, String uid, String username, String image) async {
    if (value == 'disconnect') {
      _disconnect(uid);
    } else if (value == 'message') {
      String conversationID =
          await _messagingService.findConversationID(widget.loggedInUser, uid);
      if (conversationID == 'Not found') {
        List<String> newList = [widget.loggedInUser, uid];
        conversationID = await _messagingService.createConversation(newList);
      }
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              profileName: username,
              receiverID: uid,
              profilePicture: image,
            ),
          ),
        );
      }
      _badgeService.unlockExplorerComponent("created_chat");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: page == "events" ? 360 : 388,
      height: page == "events" ? 68 : 72,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 0,
            color: Theme.of(context).colorScheme.surface,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile picture and name column
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: page != "events" ? 44 : 50,
                  height: page != "events" ? 44 : 50,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(44),
                      child: selected
                          ? Container(
                              color: Theme.of(context).colorScheme.primary,
                              child: Icon(
                                Icons.check,
                                size: 24,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.surface,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: image,

                              placeholder: (context, url) => Center(
                                child: LoadingAnimationWidget.halfTriangleDot(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 36,
                                ),
                              ), // Loading indicator for banner
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                    width: 12), // Add spacing between profile picture and name
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        fontWeight: page == "events"
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Text(
                      '#$uniqueNum',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Popup menu button
            if (page == 'connections' &&
                username != 'You' &&
                widget.isOwnProfile == true)
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'disconnect',
                    child: Text('Disconnect'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'message',
                    child: Text('Message'),
                  ),
                ],
                onSelected: (value) {
                  _handleMenuSelection(value, uid, username, image);
                },
              )
            else if (page == 'requests')
            Row(
              children: [
                IconButton(
                  color: Colors.green,
                  icon: Icon(Icons.check),
                  onPressed: () {
                    _accept(uid);
                  },
                ),
                IconButton(
                  color: Colors.red,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    _reject(uid);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    // Wrap cardContent in GestureDetector for navigation
    return GestureDetector(
      onTap: () {
        if (page == 'connections' || page=='search') {
          if (username != 'You') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfilePage(
                        uid: widget.uid,
                        isOwnProfile: false,
                        isConnection: true,
                        loggedInUser: widget.loggedInUser,
                      )), // Navigate to ConnectionsList page
            );
          }
        } else if (page == 'requests') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfilePage(
                    uid: widget.uid,
                    isOwnProfile: false,
                    isConnection: false,
                    loggedInUser: widget
                        .loggedInUser)), // Navigate to ConnectionsList page
          );
        } else {
          setState(() {
            selected = !selected;
          });
          widget.onSelected(uid, selected);
        }
      },
      child: cardContent,
    );
  }
}
