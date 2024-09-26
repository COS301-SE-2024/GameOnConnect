import 'package:avatar_stack/avatar_stack.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class BadgePage extends StatefulWidget {
  final MapEntry<String, dynamic> badge;
  const BadgePage({super.key, required this.badge});

  @override
  State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
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
        const SizedBox(
            width: 280,
            child: Text(
              "You earned this badge by",
              style: TextStyle(fontSize: 13, color: Colors.grey),
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
          child: AvatarStack(
            width: 250,
            height: 50,
            borderColor: Theme.of(context).colorScheme.surface,
            avatars: [
              for (var n = 0; n < 15; n++)
                NetworkImage('https://i.pravatar.cc/150?img=$n'),
            ],
          ),
        ),
        const SizedBox(height: 100)
      ]),
    );
  }
}