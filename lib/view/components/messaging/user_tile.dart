import 'package:cached_network_image/cached_network_image.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:gameonconnect/view/components/card/custom_toast_card.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final String profilepictureURL;
  final String lastMessage;
  final String time;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.profilepictureURL,
    required this.lastMessage,
    required this.time,
  });

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  final ProfileService _profileService = ProfileService();
  
  Profile? profileData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData(); //load the function upon first load
  }

  void _loadProfileData() {
    setState(() {
      isLoading =
          true; //sets the loading state to true to build the loading widget
    });
    _profileService.fetchProfile().then((data) {
      setState(() {
        profileData = data;
        isLoading =
            false; //data has been loaded so we cna stop the loading state
      });
    }).catchError((error) {
      setState(() {
        isLoading = false;
      });

      //added feedback to user if the content was not loaded
      DelightToastBar(
          builder: (context) {
            return CustomToastCard(
              title: Text(
                'Please check your internet connection.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            );
          },
          position: DelightSnackbarPosition.top,
          autoDismiss: true,
          snackbarDuration: const Duration(seconds: 3));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
                    child: Material(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 2,
                                  ),
                                ),
                                child: buildProfilePicture(widget.profilepictureURL), //build the profile picture widget
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      8, 0, 0, 0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.text, //this is the text for the profile_name
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontSize: 20,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 4, 0, 0),
                                        child: Text(
                                          widget.lastMessage, //this text needs to change to the passed in text
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontSize: 15,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 4, 0, 0),
                                            child: Text(
                                              widget.time,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontSize: 10,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 0.5,
                    color: Theme.of(context).colorScheme.secondary,
                  )
                ],
              ),
    );
  }

  //build the chats here
  /*Widget _buildChatList() {
    return SafeArea(
      top: true,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      profileName: profileData!.profileName,
                    ),
                  ),
                ),
              },
              child: 
            ),
          ),
        ],
      ),
    );
  } */

  ////this widget builds the image as a cached network image
  Widget buildProfilePicture(String? profilePicUrl) {
    if (isLoading) {
      return _buildLoadingWidget();
    } else if (profilePicUrl != null) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: CachedNetworkImage(
            imageUrl: profilePicUrl,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingWidget(),
            errorWidget: (context, url, error) => _buildErrorWidget(),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeInCurve: Curves.easeIn,
            memCacheWidth: 88,
            memCacheHeight: 88,
            maxWidthDiskCache: 88,
            maxHeightDiskCache: 88,
          ),
        ),
      );
    } else {
      return _buildErrorWidget();
    }
  }

  //this widget builds while the image is still loading
  Widget _buildLoadingWidget() {
    return const SizedBox(
      width: 44,
      height: 44,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  //this widget builds if there is an error with the image
  Widget _buildErrorWidget() {
    return Container(
      width: 44,
      height: 44,
      color: Colors.grey[300],
      child: const Icon(Icons.error),
    );
  }
}
