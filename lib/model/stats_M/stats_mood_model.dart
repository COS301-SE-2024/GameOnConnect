class MoodCounts {
  final int joy;
  final int disgust;
  final int sad;
  final int angry;
  final int fear;

  MoodCounts({
    required this.joy,
    required this.disgust,
    required this.sad,
    required this.angry,
    required this.fear,
  });
}









// import 'package:flutter/material.dart';

// class Indicator extends StatelessWidget {
//   final Color color;
//   final String text;
//   final bool isSquare;
//   final double size;
//   final Color textColor;

//   const Indicator({
//     Key? key,
//     required this.color,
//     required this.text,
//     this.isSquare = true,
//     this.size = 16,
//     this.textColor = const Color(0xff505050),
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
//             color: color,
//           ),
//         ),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: textColor,
//           ),
//         ),
//       ],
//     );
//   }
// }
