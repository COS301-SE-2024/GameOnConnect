import 'package:flutter/material.dart';

class ActivityIndicator extends StatelessWidget {
  final double size;
  final Color color;

  const ActivityIndicator({super.key, 
    required this.size, 
    required this.color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1),
      ),
    );
  }
}
