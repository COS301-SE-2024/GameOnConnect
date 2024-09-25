import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';
//import 'package:gameonconnect/services/stats_S/stats_leaderboard_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/stats/total_time_boxes.dart';
import 'package:gameonconnect/view/components/stats/mood_pie_chart.dart';
import 'package:gameonconnect/view/components/stats/genres_bar_graph.dart';
//import 'package:gameonconnect/view/components/stats/leaderboard_pie_chart.dart';

class StatsPage extends StatefulWidget {
  final String userID;
  const StatsPage({super.key, required this.userID});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final BadgeService _badgeService = BadgeService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late final StatsTotalTimeService totalTimeService = StatsTotalTimeService();
  late final StatsMoodService statsMoodService = StatsMoodService();
  late final StatsGenresService statsGenresService = StatsGenresService();
  //late final StatsLeaderboardService leaderboardService =
  //StatsLeaderboardService();

  bool _isLoading = true;
  bool _isLoadingT = true;

  double todayTime = 0;
  double pastWeekTime = 0;
  double pastMonthTime = 0;
  double allTime = 0;
  double playPercentage = 0;

  /*Map<String, int> leaderboardData = {
    '1st': 0,
    '2nd': 0,
    '3rd': 0,
    'Top 5': 0,
    'Top 10': 0,
  };*/

  @override
  void initState() {
    super.initState();
    _fetchTotalTimeStats();
    _fetchLeaderboardData();
    _badgeService.unlockGamerBadge();
  }

  Future<void> _fetchTotalTimeStats() async {
    try {
      double today =
          await totalTimeService.getTotalTimePlayedToday(widget.userID);
      double week =
          await totalTimeService.getTotalTimePlayedLastWeek(widget.userID);
      double month =
          await totalTimeService.getTotalTimePlayedLastMonth(widget.userID);
      double all = await totalTimeService.getTotalTimePlayedAll(widget.userID);
      double percentage = await totalTimeService
          .getPercentageTimePlayedComparedToOthers(widget.userID);

      setState(() {
        todayTime = today;
        pastWeekTime = week;
        pastMonthTime = month;
        allTime = all;
        playPercentage = percentage;

        _isLoadingT = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingT = false;
      });
    }
  }

  Future<void> _fetchLeaderboardData() async {
    try {
      //final data = await leaderboardService.fetchLeaderboardData(widget.userID);
      setState(() {
        //leaderboardData = data;
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
      appBar: BackButtonAppBar(
        onBackButtonPressed: () {
          Navigator.of(context).pop();
        },
        title: 'Gaming Stats',
        iconkey: const Key('Gaming_stats_icon'),
        textkey: const Key('Gaming_stats_text'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: SafeArea(
                top: true,
                child: Column(
                  children: [
                    _isLoadingT
                        ? const Center(child: CircularProgressIndicator())
                        : TotalTimeComponent(
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
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
                      child: Align(
                        alignment: Alignment.center,
                        child: RichText(
                          text: const TextSpan(
                            text: 'Click on ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'any',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' pie chart segment to view the games *',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    StatsMoodPage(userID: widget.userID),
                    Divider(
                      thickness: 1,
                      indent: 12,
                      endIndent: 12,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    GenresStatsComponent(userID: widget.userID),
                    const Text(
                      "Amount of games played per genre",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    //StatsLeaderboardPage(userID: widget.userID),
                  ],
                ),
              ),
            ),
    ));
  }
}
