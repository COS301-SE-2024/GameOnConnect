import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class BadgePage extends StatefulWidget {
  final String badgeFileName;
  final String badgeName;
  const BadgePage(
      {super.key, required this.badgeFileName, required this.badgeName});

  @override
  State<BadgePage> createState() => _BadgePageState();
}

class _BadgePageState extends State<BadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
      ),
      body: Column(children: [
        Expanded(
            child: ModelViewer(
          disablePan: true,
          disableZoom: true,
          src: 'assets/models/${widget.badgeFileName}.glb',
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
        Text(widget.badgeName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        const SizedBox(height: 18),
        const SizedBox(
            width: 280,
            child: Text(
              "You earned this badge by using the app for 10 consecutive days",
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
            const Text("2024/03/02", style: TextStyle(color: Colors.grey))
          ],
        ),
        const SizedBox(height: 31),
        const Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Also earned by", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 15,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(height: 5),
                      Text("User $index")
                    ],
                  ),
                );
              },
            ),
          ),
        )
      ]),
    );
  }
}
