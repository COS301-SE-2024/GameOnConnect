// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';
import 'package:gameonconnect/view/components/stats/mood_pie_chart_sections.dart';

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
                ? const Center(child: CircularProgressIndicator())
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
                                    sections: MoodPieChartSections.showingSectionsMood(context, moodCounts),    // showingSectionsMood(),
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        if (event is FlLongPressEnd || event is FlTapUpEvent) {
                                          final touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
                                          // print('Touched index: $touchedIndex');
                                          if (touchedIndex != null) {
                                            String mood = '';
                                            switch (touchedIndex) {
                                              case 0:
                                                mood = 'Happy';
                                                break;
                                              case 1:
                                                mood = 'Disgusted';
                                                break;
                                              case 2:
                                                mood = 'Sad';
                                                break;
                                              case 3:
                                                mood = 'Angry';
                                                break;
                                              case 4:
                                                mood = 'Scared';
                                                break;
                                            }
                                            // print('Touched index: $touchedIndex'); 
                                            _navigateToGamesPage(mood);
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Indicator(color: Colors.yellow, text: 'Happy', isSquare: false, size: 12),
                                SizedBox(height: 25),
                                Indicator(color: Colors.green, text: 'Disgusted', isSquare: false, size: 12),
                                SizedBox(height: 25),
                                Indicator(color: Colors.blue, text: 'Sad', isSquare: false, size: 12),
                                SizedBox(height: 25),
                                Indicator(color: Colors.red, text: 'Angry', isSquare: false, size: 12),
                                SizedBox(height: 25),
                                Indicator(color: Colors.purple, text: 'Scared', isSquare: false, size: 12),
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
      // print('Fetching games for mood: $mood2');
      List<Map<String, dynamic>> gameData = await _statsMoodService.fetchGameIDsAndTimestamps(mood2);
      
      if (gameData.isEmpty) {
        // print('No games found for mood: $mood2');
      } else {
        // print('Found ${gameData.length} games for mood: $mood2');
      }

      // print('gameData given to games page: $gameData');

      return gameData;
    } catch (e) {
      // print('Error fetching game IDs for mood: $e');
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }
}
