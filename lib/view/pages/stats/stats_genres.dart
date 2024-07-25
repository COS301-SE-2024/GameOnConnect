import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';

class GenresStatsPage extends StatefulWidget {
  @override
  _GenresStatsPageState createState() => _GenresStatsPageState();
}

class _GenresStatsPageState extends State<GenresStatsPage> {
  Map<String, double> genrePlayTime = {};
  final StatsGenresService _statsGenresService = StatsGenresService();

  @override
  void initState() {
    super.initState();
    _loadGenrePlayTime();
  }

  Future<void> _loadGenrePlayTime() async {
    final data = await _statsGenresService.getGenrePlayTime();
    setState(() {
      genrePlayTime = data;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            'Genres',
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
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 15, 5, 5),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 0,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: Icon(
                        Icons.filter_alt,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.secondary,
              ),
              Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: genrePlayTime.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : AspectRatio(
                      aspectRatio: 1.5,
                      child: BarChart(
                        BarChartData(
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              // tooltipBgColor: Colors.transparent,
                              getTooltipItem: (
                                BarChartGroupData group,
                                int groupIndex,
                                BarChartRodData rod,
                                int rodIndex,
                              ) {
                                return BarTooltipItem(
                                  '${genrePlayTime.keys.elementAt(groupIndex)}: ${rod.toY.round()} time(s)',
                                  TextStyle(
                                    color: Theme.of(context).colorScheme.surface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  final genre = genrePlayTime.keys.elementAt(value.toInt());
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 4,
                                    child: Text(
                                      genre,
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: false,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  return SideTitleWidget(
                                    axisSide: meta.axisSide,
                                    space: 6,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.surface,
                              width: 1,
                            ),
                          ),
                          barGroups: List.generate(
                            genrePlayTime.keys.length,
                            (index) {
                              final genre = genrePlayTime.keys.elementAt(index);
                              return BarChartGroupData(
                                x: index,
                                barRods: [
                                  BarChartRodData(
                                    toY: genrePlayTime[genre]!,
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 15
                                  ),
                                ],
                              );
                            },
                          ),
                          gridData: FlGridData(show: false),
                          alignment: BarChartAlignment.spaceEvenly,
                          maxY: genrePlayTime.values.isNotEmpty ? genrePlayTime.values.reduce((a, b) => a > b ? a : b) : 0,
                        ),
                      ),
                    ),
                  ),
            ],
        ),
      ),
    );
  }
}