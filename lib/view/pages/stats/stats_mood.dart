import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_mood_model.dart';

class StatsMoodPage extends StatefulWidget {
  const StatsMoodPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StatsMoodPageState createState() => _StatsMoodPageState();
}

class _StatsMoodPageState extends State<StatsMoodPage> {
  final StatsMoodService _statsMoodService = StatsMoodService();
  Map<String, int> moodCounts = {
    'joy': 0,
    'disgust': 0,
    'sad': 0,
    'angry': 0,
    'fear': 0,
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
      // print("Error fetching mood data: $e");
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
        backgroundColor: theme.colorScheme.primary,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: theme.colorScheme.secondary,
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
            color: theme.colorScheme.secondary,
            fontSize: 32,
            letterSpacing: 0,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [],
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
                                String mood = '';
                                switch (touchedIndex) {
                                  case 0:
                                    mood = 'joy';
                                    break;
                                  case 1:
                                    mood = 'disgust';
                                    break;
                                  case 2:
                                    mood = 'sad';
                                    break;
                                  case 3:
                                    mood = 'angry';
                                    break;
                                  case 4:
                                    mood = 'fear';
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
                  const SizedBox(height: 16),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Indicator(color: Colors.yellow, text: 'Joy', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Colors.green, text: 'Disgust', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Colors.blue, text: 'Sad', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Colors.red, text: 'Angry', isSquare: false, size: 30),
                      SizedBox(height: 10),
                      Indicator(color: Colors.purple, text: 'Fear', isSquare: false, size: 30),
                      SizedBox(height: 10),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
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
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.yellow,
            value: moodCounts['joy']!.toDouble(),
            title: '${moodCounts['joy']}',
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
            value: moodCounts['disgust']!.toDouble(),
            title: '${moodCounts['disgust']}',
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
            value: moodCounts['sad']!.toDouble(),
            title: '${moodCounts['sad']}',
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
            value: moodCounts['angry']!.toDouble(),
            title: '${moodCounts['angry']}',
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
            value: moodCounts['fear']!.toDouble(),
            title: '${moodCounts['fear']}',
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