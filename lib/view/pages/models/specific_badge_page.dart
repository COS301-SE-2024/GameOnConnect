import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class SpecificBadgePage extends StatefulWidget {
  const SpecificBadgePage({super.key});

  @override
  State<SpecificBadgePage> createState() => _SpecificBadgePageState();
}

class _SpecificBadgePageState extends State<SpecificBadgePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mountain Badge'),
      ),
      body: const Center(
        child: ModelViewer(
          src: 'assets/models/newbie_badge.glb', 
          alt: 'A 3D model of a mountain badge',
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}
