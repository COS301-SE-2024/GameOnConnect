import 'package:flutter/material.dart';
import 'package:gameonconnect/services/stats_S/stats_total_time_service.dart';
import 'package:gameonconnect/services/stats_S/stats_mood_service.dart';
import 'package:gameonconnect/view/pages/stats/stats_games.dart';
import 'package:gameonconnect/model/stats_M/stats_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';
import 'package:gameonconnect/view/components/stats/stats_filter.dart';
import 'package:gameonconnect/services/stats_S/stats_leaderboard_service.dart';

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
  
  Map<String, double> genrePlayTime = {};
  String _selectedFilter = 'All Time';

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
    _fetchMoodData();
    _loadGenrePlayTime();
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

  Future<void> _fetchMoodData() async {
    try {
      final fetchedMoodCounts = await statsMoodService.fetchMoodData();
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

  Future<void> _loadGenrePlayTime({DateTime? startDate}) async {
    setState(() {
      _isLoading = true;
    });
    final data = await statsGenresService.getGenrePlayTime(startDate: startDate);
    setState(() {
      genrePlayTime = data;
      _isLoading = false;
    });
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });

    DateTime? startDate;
    final now = DateTime.now();
    switch (filter) {
      case 'Last Day':
        startDate = now.subtract(const Duration(days: 1));
        break;
      case 'Last Week':
        startDate = now.subtract(const Duration(days: 7));
        break;
      case 'Last Month':
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case 'Last Year':
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = null;
    }

    _loadGenrePlayTime(startDate: startDate);
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
    bool allZeroMood = moodCounts.values.every((count) => count == 0);
    bool allZeroGenre = genrePlayTime.values.every((element) => element == 0);
    final isEmptyLB = leaderboardData.values.every((value) => value == 0);
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
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
                      child: Text(
                        'Total Time Played',
                        textAlign: TextAlign.start,
                        style: TextStyle(
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
                            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          '${todayTime.toStringAsFixed(2)} hours',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          '${pastWeekTime.toStringAsFixed(2)} hours',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Text(
                                          '${pastMonthTime.toStringAsFixed(2)} hours',
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
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
                            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                            child: Container(
                              width: double.infinity,
                              height: 110,
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
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
                                              child: Text(
                                                allTime.toStringAsFixed(3),
                                                style: TextStyle(
                                                  color: Theme.of(context).colorScheme.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
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
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0),
                                      child: Image.asset(
                                        'assets/images/stats_icon1.png',
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
                            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 12),
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
                                      child: Image.asset(
                                        'assets/images/stats_icon2.png',
                                        width: 110,
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
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: allZeroMood
                        ? Center(
                            child: Text(
                              'You have not rated a gaming session yet',
                              style: TextStyle(
                                
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
                                      centerSpaceRadius: 60,
                                      sections: showingSectionsMood(),
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
                                              _navigateToGamesPageMood(mood);
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
                    Divider(
                      thickness: 1,
                      indent: 15,
                      endIndent: 15,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Most played genres',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              // 
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showStatsFilterDialog(context, _selectedFilter, _onFilterSelected);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Filter',
                                      style: TextStyle(
                                        
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                                      child: Icon(
                                        Icons.filter_alt,
                                        color: Theme.of(context).colorScheme.primary,
                                        size: 24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ) 
                    ),
                    genrePlayTime.isEmpty
                      ? Center(
                          child: Text(
                            _selectedFilter == 'All Time'
                                ? 'No playing sessions recorded'
                                : 'No playing data was recorded in this time period',
                            style: TextStyle(
                              
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : allZeroGenre
                          ? Center(
                              child: Text(
                                _selectedFilter == 'All Time'
                                    ? 'No playing sessions recorded'
                                    : 'No playing data was recorded in this time period',
                                style: TextStyle(
                                  
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: SfCartesianChart(
                                  legend: const Legend(
                                    isVisible: false,
                                  ),
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    header: '',
                                    canShowMarker: false,
                                    builder: (dynamic data, ChartPoint<dynamic> point, ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
                                      final genre = genrePlayTime.keys.elementAt(pointIndex);
                                      final value = genrePlayTime[genre] ?? 0.0;
                                      return Container(
                                        padding: const EdgeInsets.all(8.0),
                                        color: Colors.black,
                                        child: Text(
                                          '$genre: $value',
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      );
                                    },
                                  ),
                                  primaryXAxis: const CategoryAxis(
                                    labelRotation: 0,
                                    majorGridLines: MajorGridLines(width: 0), 
                                    axisLine: AxisLine(width: 1), 
                                    labelIntersectAction: AxisLabelIntersectAction.trim, 
                                    labelStyle: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                    isVisible: true,                                    
                                  ),
                                  primaryYAxis: const NumericAxis(
                                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                                    majorGridLines: MajorGridLines(width: 0), 
                                    axisLine: AxisLine(width: 1),
                                    labelAlignment: LabelAlignment.end,
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  series: <CartesianSeries>[
                                    BarSeries<MapEntry<String, double>, String>(
                                      dataSource: genrePlayTime.entries.toList(),
                                      xValueMapper: (entry, _) => entry.key,
                                      yValueMapper: (entry, _) => entry.value,
                                      color: Theme.of(context).colorScheme.primary,
                                      dataLabelSettings: const DataLabelSettings(isVisible: true),
                                      enableTooltip: true,
                                    ),
                                  ],
                                  borderColor: Colors.transparent,
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
                      padding: EdgeInsetsDirectional.fromSTEB(12, 20, 12, 10),
                      child: Text(
                        'Leaderboard rankings',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          // 
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: isEmptyLB
                          ? Center(
                              child: Text(
                                'You have not achieved any top 10 finishes',
                                style: TextStyle(
                                  
                                  fontSize: 20,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
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
                                        sections: showingSectionsLB(),
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
                                const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Indicator(color: Color.fromRGBO(200, 235, 197, 1.0), text: '1st', isSquare: false, size: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Indicator(color: Color.fromRGBO(5, 94, 3, 1.0), text: '2nd', isSquare: false, size: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Indicator(color: Color.fromRGBO(0, 182, 40, 1.0), text: '3rd', isSquare: false, size: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Indicator(color: Color.fromRGBO(0, 216, 35, 1.0), text: 'Top 5', isSquare: false, size: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      child: Indicator(color: Color.fromRGBO(72, 228, 88, 1.0), text: 'Top 10', isSquare: false, size: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
          ),
        ),
    );
  }

  List<PieChartSectionData> showingSectionsMood() {
    return List.generate(5, (i) {
      const fontSize = 12.0;
      const radius = 60.0;
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

  void _navigateToGamesPageMood(String mood) async {
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
      List<Map<String, dynamic>> gameData = await statsMoodService.fetchGameIDsAndTimestamps(mood);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }

  List<PieChartSectionData> showingSectionsLB() {
    return List.generate(5, (i) {
      const fontSize = 12.0;
      const radius = 60.0; 
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
              fontFamily: "inter",
            ),
          );
        default:
          throw Error();
      }
    });
  }

  void _navigateToGamesPageLB(String position) async {
    List<Map<String, dynamic>> gameData = await fetchGameIDsByPositionLB(position); // Fetch the game IDs based on position
    // ignore: use_build_context_synchronously
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => GamesWidget(gameData: gameData),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsByPositionLB(String position) async {
    try {
      List<Map<String, dynamic>> gameData = await leaderboardService.fetchGameIDsAndTimestamps(position);
      return gameData;
    } catch (e) {
      throw Exception('Error fetching game IDs for mood: $e');
    }
  }
}