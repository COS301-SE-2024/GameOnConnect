// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';
import 'package:gameonconnect/view/components/stats/mood_pie_chart_sections.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class StatsMoodPage extends StatefulWidget {
  const StatsMoodPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatsMoodPageState createState() => _StatsMoodPageState();
}

class _StatsMoodPageState extends State<StatsMoodPage> {
  final StatsMoodService _statsMoodService = StatsMoodService();
  Map<String, int> moodCounts = {
    'Happy': 0,
    'Disgusted': 0,
    'Sad': 0,
    'Angry': 0,
    'Scared': 0,
  };
  List<String> nonZeroMoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMoodData();
  }

  Future<void> _fetchMoodData() async {
    try {
      final fetchedMoodCounts = await _statsMoodService.fetchMoodData();
      setState(() {
        moodCounts = fetchedMoodCounts;
        nonZeroMoods = _getNonZeroMoods();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

   List<String> _getNonZeroMoods() {
    return moodCounts.entries
        .where((entry) => entry.value > 0)
        .map((entry) => entry.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    bool allZero = moodCounts.values.every((count) => count == 0);

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
          child: Text(
            'Mood',
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
                ? Center(child: LoadingAnimationWidget.halfTriangleDot(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 36,
                                ),)
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: allZero
                      ? Center(
                          child: Text(
                            'You have not rated a gaming session yet',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 12,
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
                                    sections: MoodPieChartSections.showingSectionsMood(context, moodCounts), 
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        if (event is FlLongPressEnd || event is FlTapUpEvent) {
                                          final touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                          if (touchedIndex != null && touchedIndex < nonZeroMoods.length) {
                                            final touchedMood = nonZeroMoods[touchedIndex];
                                            _navigateToGamesPage(touchedMood);
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
                              children: nonZeroMoods.map((mood) {
                                Color color;
                                switch (mood) {
                                  case 'Happy':
                                    color = Colors.yellow;
                                    break;
                                  case 'Disgusted':
                                    color = Colors.green;
                                    break;
                                  case 'Sad':
                                    color = Colors.blue;
                                    break;
                                  case 'Angry':
                                    color = Colors.red;
                                    break;
                                  case 'Scared':
                                    color = Colors.purple;
                                    break;
                                  default:
                                    color = Colors.grey;
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 25.0),
                                  child: Indicator(
                                    color: color,
                                    text: mood,
                                    isSquare: false,
                                    size: 12,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                  ),
          ],
        ),
      ],
    );
  }

  void _navigateToGamesPage(String mood1) async {
    List<Map<String, dynamic>> gameData = await fetchGameIDsByMood(mood1); // Fetch the game IDs based on mood
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesWidget(gameData: gameData),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsByMood(String mood2) async {
    try {
      List<Map<String, dynamic>> gameData = await _statsMoodService.fetchGameIDsAndTimestamps(mood2);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }
}
