import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final StatsTotalTimeService totalTimeService = StatsTotalTimeService();
  final StatsMoodService _statsMoodService = StatsMoodService();

  Map<String, int> moodCounts = {
    'Happy': 0,
    'Disgusteded': 0,
    'Sad': 0,
    'Angry': 0,
    'Scared': 0,
  };

  bool _isLoading = true;

  double todayTime = 0;
  double pastWeekTime = 0;
  double pastMonthTime = 0;
  double allTime = 0;
  double playPercentage = 0;

  @override
  void initState() {
    super.initState();
    _fetchTotalTimeStats();
    _fetchMoodData();
  }

  Future<void> _fetchTotalTimeStats() async {
    double today = await totalTimeService.getTotalTimePlayedToday();
    double week = await totalTimeService.getTotalTimePlayedLastWeek();
    double month = await totalTimeService.getTotalTimePlayedLastMonth();
    double all = await totalTimeService.getTotalTimePlayedAll();
    double percentage = await totalTimeService.getPercentageTimePlayedComparedToOthers();

    setState(() {
      todayTime = today;
      pastWeekTime = week;
      pastMonthTime = month;
      allTime = all;
      playPercentage = percentage;
    });
  }

  Future<void> _fetchMoodData() async {
    try {
      final fetchedMoodCounts = await _statsMoodService.fetchMoodData();
      setState(() {
        moodCounts = fetchedMoodCounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.secondary,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Gaming Stats',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 20, 10, 10),
                child: Text(
                  'Total Time Played',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    '${todayTime.toStringAsFixed(3)} hours',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Past week',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    '${pastWeekTime.toStringAsFixed(3)} hours',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Past month',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Text(
                                    '${pastMonthTime.toStringAsFixed(3)} hours',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                                        child: Text(
                                          'You have played',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
                                        child: Text(
                                          'n',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                    child: Text(
                                      'hours in total. Wow!',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  'https://picsum.photos/seed/753/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 10),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: Image.network(
                                  'https://picsum.photos/seed/580/600',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'You have played more than',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 2, 0),
                                        child: Text(
                                          '${playPercentage.toStringAsFixed(3)}%',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                        child: Text(
                                          'of players',
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 20, 10, 10),
                child: Text(
                  'Mood',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 20, 10, 10),
                child: Text(
                  'Most played genres',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Divider(
                thickness: 1,
                indent: 15,
                endIndent: 15,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(30, 20, 10, 10),
                child: Text(
                  'Leaderboard rankings',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}













// import 'package:flutter/material.dart';
// import 'package:gameonconnect/view/components/stats/stats_genres_bar_graph.dart';
// import 'package:gameonconnect/view/components/stats/stats_leaderboard_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_mood_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_total_time_boxes.dart';

// class StatsOverviewPage extends StatelessWidget {
//   const StatsOverviewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(
//           'My Stats',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 32,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               _buildSectionHeader(context, 'Total Time'),
//               const SizedBox(height: 10),
//               const TotalTimeStatsComponent(),
//               const SizedBox(height: 20),
//               _buildSectionHeader(context, 'Mood'),
//               const SizedBox(height: 10),
//               const StatsMoodWidget(),
//               const SizedBox(height: 20),
//               _buildSectionHeader(context, 'Genres'),
//               const SizedBox(height: 10),
//               const GenresStatsComponent(),
//               const SizedBox(height: 20),
//               _buildSectionHeader(context, 'Leaderboard'),
//               const SizedBox(height: 10),
//               const StatsLeaderboardPage(),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(BuildContext context, String title) {
//     return Text(
//       title,
//       style: TextStyle(
//         fontFamily: 'Inter',
//         color: Theme.of(context).colorScheme.onSurface,
//         fontSize: 24,
//         fontWeight: FontWeight.bold,
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:gameonconnect/view/components/stats/stats_genres_bar_graph.dart';
// import 'package:gameonconnect/view/components/stats/stats_leaderboard_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_mood_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_total_time_boxes.dart';

// class StatsOverviewPage extends StatelessWidget {
//   const StatsOverviewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(
//           'Stats Overview',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 32,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: const SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TotalTimeStatsComponent(),
//               SizedBox(height: 20),
//               StatsMoodWidget(),
//               SizedBox(height: 20),
//               GenresStatsComponent(),
//               SizedBox(height: 20),
//               StatsLeaderboardPage(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
