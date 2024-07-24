import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_leaderboard_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_mood_model.dart';
// import 'package:logger/logger.dart'; // Add this line for logging

// final logger = Logger(); // Initialize the logger

class StatsLeaderboardPage extends StatefulWidget {
  const StatsLeaderboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatsLeaderboardPageState createState() => _StatsLeaderboardPageState();
}

class _StatsLeaderboardPageState extends State<StatsLeaderboardPage> {
  final StatsLeaderboardService _leaderboardService = StatsLeaderboardService();
  Map<String, int> leaderboardData = {
    '1st': 0,
    '2nd': 0,
    '3rd': 0,
    'Top 5': 0,
    'Top 10': 0,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchLeaderboardData();
  }

  Future<void> _fetchLeaderboardData() async {
    try {
      final data = await _leaderboardService.fetchLeaderboardData();
      setState(() {
        leaderboardData = data;
        _isLoading = false;
      });
    } catch (e) {
      // print("Error fetching leaderboard data: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.secondary,
            size: 30,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 32,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 1.8,
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        sections: showingSections(),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (event is FlLongPressEnd || event is FlTapUpEvent) {
                              final touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                              if (touchedIndex != null) {
                                String position = '';
                                switch (touchedIndex) {
                                  case 0:
                                    position = '1st';
                                    break;
                                  case 1:
                                    position = '2nd';
                                    break;
                                  case 2:
                                    position = '3rd';
                                    break;
                                  case 3:
                                    position = 'top5';
                                    break;
                                  case 4:
                                    position = 'top10';
                                    break;
                                }
                                // logger.i('Toched section index: $touchedIndex');
                                _navigateToGamesPage(position);
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Indicator(color: Color.fromRGBO(200, 235, 197, 1.0), text: '1st', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Color.fromRGBO(5, 94, 3, 1.0), text: '2nd', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Color.fromRGBO(0, 182, 40, 1.0), text: '3rd', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Color.fromRGBO(0, 216, 35, 1.0), text: 'Top 5', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Color.fromRGBO(72, 228, 88, 1.0), text: 'Top 10', isSquare: false, size: 30),
                      SizedBox(height: 10),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Click on any chart segment to view the games',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: theme.colorScheme.onSurface,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          color: theme.colorScheme.onSurface,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(5, (i) {
      const fontSize = 16.0;
      const radius = 100.0;
      // final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: const Color.fromRGBO(200, 235, 197, 1.0),
            value: leaderboardData['1st']!.toDouble(),
            title: '${leaderboardData['1st']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              // shadows: shadows,
              fontFamily: "inter",
            ),
          );
        case 1:
          return PieChartSectionData(
            color: const Color.fromRGBO(5, 94, 3, 1.0),
            value: leaderboardData['2nd']!.toDouble(),
            title: '${leaderboardData['2nd']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              // shadows: shadows,
              fontFamily: "inter",
            ),
          );
        case 2:
          return PieChartSectionData(
            color: const Color.fromRGBO(0, 182, 40, 1.0),
            value: leaderboardData['3rd']!.toDouble(),
            title: '${leaderboardData['3rd']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              // shadows: shadows,
              fontFamily: "inter",
            ),
          );
        case 3:
          return PieChartSectionData(
            color: const Color.fromRGBO(0, 216, 35, 1.0),
            value: leaderboardData['Top 5']!.toDouble(),
            title: '${leaderboardData['Top 5']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              // shadows: shadows,
              fontFamily: "inter",
            ),
          );
        case 4:
          return PieChartSectionData(
            color: const Color.fromRGBO(72, 228, 88, 1.0),
            value: leaderboardData['Top 10']!.toDouble(),
            title: '${leaderboardData['Top 10']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              // shadows: shadows,
              fontFamily: "inter",
            ),
          );
        default:
          throw Error();
      }
    });
  }

  void _navigateToGamesPage(String position) async {
    List<Map<String, dynamic>> gameData = await _leaderboardService.fetchGameIDsAndTimestamps(position); // Fetch the game IDs based on position
    // logger.i('Query snapshot size: ${gameData}');
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesWidget(gameData: gameData),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsByPosition(String position) async {
    try {
      List<Map<String, dynamic>> gameData = await _leaderboardService.fetchGameIDsAndTimestamps(position);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }
}


















// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class StatsLeaderboardPage extends StatefulWidget {
//   const StatsLeaderboardPage({Key? key}) : super(key: key);

//   @override
//   _StatsLeaderboardPageState createState() => _StatsLeaderboardPageState();
// }

// class _StatsLeaderboardPageState extends State<StatsLeaderboardPage> {
//   final Map<String, int> leaderboardData = {
//     '1st': 10,
//     '2nd': 5,
//     '3rd': 3,
//     'Top 5': 7,
//     'Top 10': 2,
//   };

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     // Mocking data loading
//     Future.delayed(Duration(seconds: 1), () {
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_rounded,
//             color: Theme.of(context).colorScheme.secondary,
//             size: 30,
//           ),
//           onPressed: () async {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(
//           'Leaderboard',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 32,
//             letterSpacing: 0,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: [],
//         centerTitle: false,
//         elevation: 2,
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   AspectRatio(
//                     aspectRatio: 1.8,
//                     child: PieChart(
//                       PieChartData(
//                         borderData: FlBorderData(show: false),
//                         sectionsSpace: 0,
//                         centerSpaceRadius: 0,
//                         sections: showingSections(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Indicator(color: Color.fromRGBO(200, 235, 197, 1.0), text: '1st', isSquare: false, size: 30),
//                       SizedBox(height: 10),
//                       Indicator(color: Color.fromRGBO(5, 94, 3, 1.0), text: '2nd', isSquare: false, size: 30),
//                       SizedBox(height: 10),
//                       Indicator(color: Color.fromRGBO(0, 182, 40, 1.0), text: '3rd', isSquare: false, size: 30),
//                       SizedBox(height: 10),
//                       Indicator(color: Color.fromRGBO(0, 216, 35, 1.0), text: 'Top 5', isSquare: false, size: 30),
//                       SizedBox(height: 10),
//                       Indicator(color: Color.fromRGBO(72, 228, 88, 1.0), text: 'Top 10', isSquare: false, size: 30),
//                       SizedBox(height: 10),
//                     ],
//                   ),
//                   Padding(
//                     padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           'Click on any chart segment to view the games',
//                           style: TextStyle(
//                             fontFamily: 'Inter',
//                             color: theme.colorScheme.onSurface,
//                             letterSpacing: 0,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Divider(
//                           thickness: 1,
//                           indent: 10,
//                           endIndent: 10,
//                           color: theme.colorScheme.onSurface,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   List<PieChartSectionData> showingSections() {
//     return List.generate(5, (i) {
//       const fontSize = 16.0;
//       const radius = 100.0;
//       final shadows = [const Shadow(color: Colors.black, blurRadius: 2)];
//       switch (i) {
//         case 0:
//           return PieChartSectionData(
//             color: Color.fromRGBO(200, 235, 197, 1.0),
//             value: leaderboardData['1st']!.toDouble(),
//             title: '${leaderboardData['1st']}',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//               // shadows: shadows,
//               fontFamily: "inter",
//             ),
//           );
//         case 1:
//           return PieChartSectionData(
//             color: Color.fromRGBO(5, 94, 3, 1.0),
//             value: leaderboardData['2nd']!.toDouble(),
//             title: '${leaderboardData['2nd']}',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//               // shadows: shadows,
//               fontFamily: "inter",
//             ),
//           );
//         case 2:
//           return PieChartSectionData(
//             color: Color.fromRGBO(0, 182, 40, 1.0),
//             value: leaderboardData['3rd']!.toDouble(),
//             title: '${leaderboardData['3rd']}',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//               // shadows: shadows,
//               fontFamily: "inter",
//             ),
//           );
//         case 3:
//           return PieChartSectionData(
//             color: Color.fromRGBO(0, 216, 35, 1.0),
//             value: leaderboardData['Top 5']!.toDouble(),
//             title: '${leaderboardData['Top 5']}',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//               // shadows: shadows,
//               fontFamily: "inter",
//             ),
//           );
//         case 4:
//           return PieChartSectionData(
//             color: Color.fromRGBO(72, 228, 88, 1.0),
//             value: leaderboardData['Top 10']!.toDouble(),
//             title: '${leaderboardData['Top 10']}',
//             radius: radius,
//             titleStyle: TextStyle(
//               fontSize: fontSize,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.secondary,
//               // shadows: shadows,
//               fontFamily: "inter",
//             ),
//           );
//         default:
//           throw Error();
//       }
//     });
//   }
// }

// class Indicator extends StatelessWidget {
//   final Color color;
//   final String text;
//   final bool isSquare;
//   final double size;
//   final Color textColor;

//   const Indicator({
//     super.key,
//     required this.color,
//     required this.text,
//     this.isSquare = true,
//     this.size = 16,
//     this.textColor = const Color(0xff505050),
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Theme.of(context);
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
//         )
//       ],
//     );
//   }
// }
