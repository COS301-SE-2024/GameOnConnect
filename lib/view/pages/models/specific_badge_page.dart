import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class SpecificBadgePage extends StatefulWidget {
  final String badgeFileName;
  final String badgeName;
  const SpecificBadgePage({super.key, required this.badgeFileName, required this.badgeName});

  @override
  State<SpecificBadgePage> createState() => _SpecificBadgePageState();
}

class _SpecificBadgePageState extends State<SpecificBadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Badges'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ModelViewer(
              disablePan: true,
              disableZoom: true,
              src: 'assets/models/${widget.badgeFileName}.glb', 
              alt: 'A 3D model of a badge',
              autoRotate: true,
              cameraControls: true,
            ),
          ),
          Text(widget.badgeName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24))
        ],
      ),
    );
  }
}
