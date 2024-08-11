import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';
import 'package:gameonconnect/services/stats_S/stats_leaderboard_service.dart';

import 'package:gameonconnect/view/components/stats/total_time_boxes.dart';
import 'package:gameonconnect/view/components/stats/mood_pie_chart.dart';
import 'package:gameonconnect/view/components/stats/genres_bar_graph.dart';
import 'package:gameonconnect/view/components/stats/leaderboard_pie_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final StatsTotalTimeService totalTimeService = StatsTotalTimeService();
  final StatsMoodService statsMoodService = StatsMoodService();
  final StatsGenresService statsGenresService = StatsGenresService();
  final StatsLeaderboardService leaderboardService = StatsLeaderboardService();

  bool _isLoading = true;

  double todayTime = 0;
  double pastWeekTime = 0;
  double pastMonthTime = 0;
  double allTime = 0;
  double playPercentage = 0;

  Map<String, int> leaderboardData = {
    '1st': 0,
    '2nd': 0,
    '3rd': 0,
    'Top 5': 0,
    'Top 10': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchTotalTimeStats();
    _fetchLeaderboardData();
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

  Future<void> _fetchLeaderboardData() async {
    try {
      final data = await leaderboardService.fetchLeaderboardData();
      setState(() {
        leaderboardData = data;
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
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          elevation: 2,
        ),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                top: true,
                child: Column(
                  children: [
                    TotalTimeComponent(
                      todayTime: todayTime,
                      pastWeekTime: pastWeekTime,
                      pastMonthTime: pastMonthTime,
                      allTime: allTime,
                      playPercentage: playPercentage,
                    ),
                    Divider(
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Click on any pie chart segment to view the games *",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const StatsMoodPage(),
                    Divider(
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const GenresStatsComponent(),
                    Divider(
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const StatsLeaderboardPage(),
                  ],
                ),
              ),
          ),
        ),
    );
  }
}