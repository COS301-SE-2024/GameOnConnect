import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class BadgePage extends StatefulWidget {
  final MapEntry<String, dynamic> badge;
  const BadgePage({super.key, required this.badge});

  @override
  State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  late Future<List<String>> _profilePicturesFuture;

  @override
  void initState() {
    super.initState();
    _profilePicturesFuture = BadgeService().getConnectionsBadgeStatus(
        widget.badge.key); // Use the desired badge name
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text('My Badges',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: Column(children: [
        Expanded(
            child: ModelViewer(
          disablePan: true,
          disableZoom: true,
          src: 'assets/models/${widget.badge.key}.glb',
          alt: 'A 3D model of a badge',
          autoRotate: true,
          cameraControls: true,
        )),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Divider(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        Text(widget.badge.key.replaceAll('_', ' ').toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(height: 18),
        SizedBox(
            width: 280,
            child: Text(
              widget.badge.value['description'],
              style: const TextStyle(fontSize: 13, color: Colors.grey),
              textAlign: TextAlign.center,
            )),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Earned on:",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary)),
            const SizedBox(
              width: 10,
            ),
            Text(
                DateFormat('yyyy/MM/dd')
                    .format(widget.badge.value['date_unlocked'].toDate()),
                style: const TextStyle(color: Colors.grey))
          ],
        ),
        const SizedBox(height: 31),
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Also earned by",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.all(12),
          child: FutureBuilder<List<String>>(
            future: _profilePicturesFuture,
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
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No connections with the unlocked badge');
              } else {
                List<String> profilePictures = snapshot.data!;

                return Center(
                  child: AvatarStack(
                    width: 250,
                    height: 50,
                    borderColor: Theme.of(context).colorScheme.surface,
                    avatars: [
                      for (var picture in profilePictures)
                        NetworkImage(picture),
                    ],
                  ),
                );
              }
            },
          ),
        ),
        const SizedBox(height: 100)
      ]),
    );
  }
}
