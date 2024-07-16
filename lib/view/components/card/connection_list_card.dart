import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';

class ConnectionCardWidget extends StatefulWidget {
  final String image ;
  final String username;
  final String uniqueNum ;
  final String uid ;
  final bool isProfile;
  final void Function(String uid,bool selected) onSelected;
  const ConnectionCardWidget({super.key,required this.image, required this.username, required this.uid, required this.uniqueNum, required this.onSelected, required this.isProfile,
});
  @override
  State<ConnectionCardWidget> createState() => _ConnectionCardWidgetState();
}

class _ConnectionCardWidgetState extends State<ConnectionCardWidget> {
late String image;
late String username;
late String uniqueNum;
late String uid;
bool selected = false;
bool isProfile= false;

@override
void initState() {
  super.initState();
  image = widget.image;
  username = widget.username;
  uniqueNum = widget.uniqueNum;
  uid = widget.uid;
}

@override
void dispose() {
  super.dispose();
}



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          setState(() {
            selected = !selected;
          });
          widget.onSelected(uid,selected);
        },
        child: Container(
        width: 388,
        height: 72,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: Theme.of(context).colorScheme.surface,
              offset: const Offset(
                0,
                1,
              ),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
          child:Row(
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
            border: widget.isProfile
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
              child: Image.network(
                image,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SizedBox(width: 12), // Add spacing between profile picture and name
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
   if (widget.isProfile)
      PopupMenuButton<String>(
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'disconnect',
            child: Text('Disconnect'),
          ),
          PopupMenuItem<String>(
            value: 'message',
            child: Text('Message'),
          ),
        ],
        onSelected: (value) {
          
        },
      ),
  ],
),

        ),

    )
    );
  }

}
