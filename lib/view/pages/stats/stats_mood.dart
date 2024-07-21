import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
// import 'package:gameonconnect/model/stats_M/stats_mood_model.dart';

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
            color: Colors.yellow,
            value: moodCounts['joy']!.toDouble(),
            title: '${moodCounts['joy']}',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: "inter",
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
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: "inter",
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
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: "inter",
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
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: "inter",
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
              color: Theme.of(context).colorScheme.secondary,
              fontFamily: "inter",
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = true,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  });

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      colorScheme: const ColorScheme.light(
        surface: Color.fromRGBO(255, 255, 255, 1),
        primary: Color.fromRGBO(0, 223, 103, 1.0),
        secondary: Color.fromRGBO(42, 42, 42, 1.0),
        tertiary: Color.fromRGBO(136, 255, 131, 1.0),
      ),
    ),
    home: const StatsMoodPage(),
  ));
}
