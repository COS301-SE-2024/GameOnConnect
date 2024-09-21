import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

class UserTile extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  final String profilepictureURL;
  final String lastMessage;
  final String time;
  final Widget profileImage;

  const UserTile({
    super.key,
    required this.text,
    required this.onTap,
    required this.profilepictureURL,
    required this.lastMessage,
    required this.time,
    required this.profileImage,
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
    _profileService.fetchProfileData().then((data) {
      if (mounted) {
        setState(() {
          profileData = data;
          isLoading =
              false; //data has been loaded so we cna stop the loading state
        });
      }
    }).catchError((error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      //added feedback to user if the content was not loaded
      DelightToastBar(
          builder: (context) {
            return SnackBar(
              content: Text(
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
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(40),
                            child: widget
                                .profileImage //build the profile picture widget
                            ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget
                                    .text, //this is the text for the profile_name
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 20,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w900),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 15, 0),
                                child: AutoSizeText(
                                  widget
                                      .lastMessage, // this text needs to change to the passed in text
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 15,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  minFontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 4, 0, 0),
                                    child: Text(
                                      widget.time,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 11,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
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
            thickness: 0.3,
            color: Theme.of(context).colorScheme.secondary,
          )
        ],
      ),
    );
  }
}
