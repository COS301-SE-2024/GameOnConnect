import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MoodPieChartSections {
  static List<PieChartSectionData> showingSectionsMood(
      BuildContext context, Map<String, int> moodCounts) {
    const fontSize = 12.0;
    const radius = 60.0;
    
    return List.generate(5, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.yellow,
            value: moodCounts['Happy']!.toDouble(),
            title: '${moodCounts['Happy']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: moodCounts['Disgusted']!.toDouble(),
            title: '${moodCounts['Disgusted']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue,
            value: moodCounts['Sad']!.toDouble(),
            title: '${moodCounts['Sad']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: moodCounts['Angry']!.toDouble(),
            title: '${moodCounts['Angry']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.white,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purple,
            value: moodCounts['Scared']!.toDouble(),
            title: '${moodCounts['Scared']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.white,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
