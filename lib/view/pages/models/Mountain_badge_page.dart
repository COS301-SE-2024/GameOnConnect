import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class MountainBadgePage extends StatefulWidget {
  const MountainBadgePage({super.key});

  @override
  State<MountainBadgePage> createState() => _MountainBadgePageState();
}

class _MountainBadgePageState extends State<MountainBadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mountain Badge'),
      ),
      body: const Center(
        child: ModelViewer(
          src: 'assets/models/mountain_badge.glb', 
          alt: 'A 3D model of a mountain badge',
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}