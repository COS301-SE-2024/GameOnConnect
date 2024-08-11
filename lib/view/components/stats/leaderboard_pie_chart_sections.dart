import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class LeaderboardPieChartSections {
  static List<PieChartSectionData> showingSectionsLB(
      BuildContext context, Map<String, int> leaderboardData) {
    const fontSize = 12.0;
    const radius = 60.0;

    return List.generate(5, (i) {
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.primary,     //const Color.fromRGBO(200, 235, 197, 1.0),
            value: leaderboardData['1st']!.toDouble(),
            title: '${leaderboardData['1st']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.tertiary,   //const Color.fromRGBO(5, 94, 3, 1.0),
            value: leaderboardData['2nd']!.toDouble(),
            title: '${leaderboardData['2nd']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Theme.of(context).colorScheme.onPrimary,   //const Color.fromRGBO(0, 182, 40, 1.0),
            value: leaderboardData['3rd']!.toDouble(),
            title: '${leaderboardData['3rd']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.black,       //const Color.fromRGBO(0, 216, 35, 1.0),
            value: leaderboardData['Top 5']!.toDouble(),
            title: '${leaderboardData['Top 5']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.white,
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.white,    //const Color.fromRGBO(72, 228, 88, 1.0),
            value: leaderboardData['Top 10']!.toDouble(),
            title: '${leaderboardData['Top 10']}',
            radius: radius,
            titleStyle: const TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color:  Colors.black,
            ),
          );
        default:
          throw Error();
      }
    });
  }
}
