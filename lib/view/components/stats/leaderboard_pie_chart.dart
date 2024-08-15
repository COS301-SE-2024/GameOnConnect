import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_leaderboard_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';
import 'package:gameonconnect/view/components/stats/leaderboard_pie_chart_sections.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StatsLeaderboardPage extends StatefulWidget {
  final String userID;
  const StatsLeaderboardPage({super.key, required this.userID});

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
      final data = await _leaderboardService.fetchLeaderboardData(widget.userID);
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
    bool allZero = leaderboardData.values.every((count) => count == 0);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
          child: Text(
            'Leaderboard',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isLoading
                ? Center(
                    child: LoadingAnimationWidget.halfTriangleDot(
                      color: Theme.of(context).colorScheme.primary,
                      size: 36,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: allZero
                        ? const Center(
                            child: Text(
                              'You have not achieved any top 10 finishes',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(
                                    PieChartData(
                                      borderData: FlBorderData(show: false),
                                      sectionsSpace: 0,
                                      centerSpaceRadius: 60,
                                      sections: LeaderboardPieChartSections
                                          .showingSectionsLB(context,
                                              leaderboardData), // showingSectionsLB(),
                                      pieTouchData: PieTouchData(
                                        touchCallback: (FlTouchEvent event,
                                            pieTouchResponse) {
                                          if (event is FlLongPressEnd ||
                                              event is FlTapUpEvent) {
                                            final touchedIndex =
                                                pieTouchResponse?.touchedSection
                                                    ?.touchedSectionIndex;
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
                                                  position = 'Top 5';
                                                  break;
                                                case 4:
                                                  position = 'Top 10';
                                                  break;
                                              }
                                              _navigateToGamesPageLB(position);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Indicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: '1st',
                                        isSquare: false,
                                        size: 12),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Indicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        text: '2nd',
                                        isSquare: false,
                                        size: 12),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    child: Indicator(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        text: '3rd',
                                        isSquare: false,
                                        size: 12),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Indicator(
                                        color: Colors.black,
                                        text: 'Top 5',
                                        isSquare: false,
                                        size: 12),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Indicator(
                                        color: Colors.white,
                                        text: 'Top 10',
                                        isSquare: false,
                                        size: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                  ),
          ],
        ),
      ],
    );
  }

  void _navigateToGamesPageLB(String position) async {
    List<Map<String, dynamic>> gameData = await fetchGameIDsByPositionLB(
        position); // Fetch the game IDs based on position
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesWidget(gameData: gameData),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsByPositionLB(
      String position) async {
    try {
      List<Map<String, dynamic>> gameData = await _leaderboardService.fetchGameIDsAndTimestamps(widget.userID, position);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for leaderboard: $e');
    }
  }
}
