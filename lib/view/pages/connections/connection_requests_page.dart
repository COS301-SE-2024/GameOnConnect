import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart'; //You can remove this service when replacing with your own

class Requests extends StatefulWidget {
  //final String currentUserId;
  const Requests({super.key});

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final BadgeService _badgeService = BadgeService();
  
  @override
  void initState() {
    super.initState();
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Connection Requests',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>?>>(
          future: ConnectionService().getConnections("requests").then(
              (friendIds) => Future.wait(friendIds.map(
                  (id) => ConnectionService().fetchFriendProfileData(id)))),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.halfTriangleDot(
                  color: Theme.of(context).colorScheme.primary,
                  size: 36,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<Map<String, dynamic>?> connectionsProfiles = snapshot.data!;
              return Column(children: [
                ListView.separated(
                  shrinkWrap: true,
                  itemCount: connectionsProfiles.length,
                  itemBuilder: (context, index) {
                    var connectionProfile = connectionsProfiles[index];
                    if (connectionProfile != null) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            ClipOval(
                              // ignore: sized_box_for_whitespace
                              child: Container(
                                height: 45,
                                width: 45,
                                child: CachedNetworkImage(
                                  imageUrl: connectionProfile[
                                      'profilePicture'], //the actual link to the image needs to go here
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  fadeInDuration:
                                      const Duration(milliseconds: 0),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 0),
                                  maxHeightDiskCache: 45,
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    connectionProfile['profileName'] ??
                                        'No Name Found',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    connectionProfile['username'] ??
                                        'No Username Found',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.check),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                //code to accept the request goes here
                                ConnectionService().acceptConnectionRequest(
                                    connectionProfile['userID']);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                ConnectionService().rejectConnectionRequest(
                                    connectionProfile['userID']);
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text('Profile not found'),
                      );
                    }
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                )
              ]);
            } else {
              return const Text('No connections found.');
            }
          },
        ),
      ),
    );
  }
}
