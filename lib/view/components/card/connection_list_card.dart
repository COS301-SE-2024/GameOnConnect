import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/pages/messaging/chat_page.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';

class ConnectionCardWidget extends StatefulWidget {
  final String image;
  final String username;
  final String uniqueNum;
  final String uid;
  final String page;
  final List<String>? invited;
  final void Function(String uid,bool selected) onSelected;
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
     this.onDisconnected, 
     this.onAccepted,
     this.onRejected,
    this.invited,

  });

  @override
  State<ConnectionCardWidget> createState() => _ConnectionCardWidgetState();
}

class _ConnectionCardWidgetState extends State<ConnectionCardWidget> {
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
  page=widget.page;
  invited = widget.invited;
  if(invited == null)
    {
      selected = false;
    }else {
    selected = invited!.contains(uid);
  }

}

@override
void dispose() {
  super.dispose();
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
      DelightToastBar(
              builder: (context) {
                return CustomToastCard(
                  title: Text(
                    'Error disconnecting user. Please ensure that you have an active internet connection.',
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

  void _accept(String targetUserId) async {
    try {
      await ConnectionService().acceptConnectionRequest(targetUserId);
      if (widget.onAccepted != null) {
        widget.onAccepted!(
            targetUserId); // Notify parent widget if callback is provided
      }
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
        // ignore: use_build_context_synchronously
        context,
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
        // ignore: use_build_context_synchronously
        context,
      );
    }
  }

  @override
Widget build(BuildContext context) {
    Widget cardContent = Container(
    width: 388,
    height: 72,
    decoration: BoxDecoration(
      color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
      boxShadow: [
        BoxShadow(
          blurRadius: 0,
          color: Theme.of(context).colorScheme.surface,
          offset: const Offset(0, 1),
        )
      ],
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Profile picture and name column
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: (page != "events")
                      ? null // No border for profiles
                      : Border.all(
                          width: 1, // Add a border for non-profiles
                          color: Colors.black,
                        ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(44),
                    
                    child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()), // Loading indicator for banner
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ),
              const SizedBox(width: 12), // Add spacing between profile picture and name
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    username,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                      letterSpacing: 0,
                      fontWeight: FontWeight.normal,
                    ),
                    ),
                    Text(
                      '# $uniqueNum',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Popup menu button
            if (page == 'connections')
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
                  if (value == 'disconnect') {
                    _disconnect(uid);
                  } else if (value == 'message') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          profileName: username,
                          receiverID: uid,
                        ),
                      ),
                    );
                  }
                },
              )
            else if (page == 'requests')
              PopupMenuButton<String>(
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: 'accept',
                    child: Row(
                      children: [
                        Text('Accept'),
                        Icon(
                          Icons.check,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'reject',
                    child: Row(
                      children: [
                        Text('Reject'),
                        Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'message',
                    child: Text('Message'),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'accept') {
                    _accept(uid);
                  } else if (value == 'reject') {
                    _reject(uid);
                  } else if (value == 'message') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Messaging(),
                      ),
                    );
                  }
                },
              ),
          ],
        ),
      ),
    );

    if (page == 'events') {
      return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
          widget.onSelected(uid, selected);
        },
        child: cardContent,
      );
    } else {
      return cardContent;
    }
  }
}
