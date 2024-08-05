// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';

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
          'Mood',
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
                  allZero
                      ? Center(
                          child: Text(
                            'You have not rated a gaming session yet',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
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
                                    centerSpaceRadius: 80,
                                    sections: showingSections(),
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        if (event is FlLongPressEnd || event is FlTapUpEvent) {
                                          final touchedIndex = pieTouchResponse?.touchedSection?.touchedSectionIndex;
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
                                Indicator(color: Colors.yellow, text: 'Happy', isSquare: false, size: 30),
                                SizedBox(height: 10),
                                Indicator(color: Colors.green, text: 'Disgusted', isSquare: false, size: 30),
                                SizedBox(height: 10),
                                Indicator(color: Colors.blue, text: 'Sad', isSquare: false, size: 30),
                                SizedBox(height: 10),
                                Indicator(color: Colors.red, text: 'Angry', isSquare: false, size: 30),
                                SizedBox(height: 10),
                                Indicator(color: Colors.purple, text: 'Scared', isSquare: false, size: 30),
                              ],
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
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
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Divider(
                          thickness: 1,
                          indent: 10,
                          endIndent: 10,
                          color: Theme.of(context).colorScheme.onSurface,
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
      const radius = 80.0;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.yellow,
            value: moodCounts['Happy']!.toDouble(),
            title: '${moodCounts['Happy']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: "Inter",
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.green,
            value: moodCounts['Disgusted']!.toDouble(),
            title: '${moodCounts['Disgusted']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: "Inter",
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.blue,
            value: moodCounts['Sad']!.toDouble(),
            title: '${moodCounts['Sad']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: "Inter",
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.red,
            value: moodCounts['Angry']!.toDouble(),
            title: '${moodCounts['Angry']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: "Inter",
            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.purple,
            value: moodCounts['Scared']!.toDouble(),
            title: '${moodCounts['Scared']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: "Inter",
            ),
          );
        default:
          throw Error();
      }
    });
  }

  void _navigateToGamesPage(String mood) async {
    List<Map<String, dynamic>> gameData = await fetchGameIDsByMood(mood); // Fetch the game IDs based on mood
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesWidget(gameData: gameData),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsByMood(String mood) async {
    try {
      List<Map<String, dynamic>> gameData = await _statsMoodService.fetchGameIDsAndTimestamps(mood);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }
}