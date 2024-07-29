import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';

class GenresStatsPage extends StatefulWidget {
  const GenresStatsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenresStatsPageState createState() => _GenresStatsPageState();
}

class _GenresStatsPageState extends State<GenresStatsPage> {
  Map<String, double> genrePlayTime = {};
  final StatsGenresService _statsGenresService = StatsGenresService();
  String _selectedFilter = 'All Time';

  @override
  void initState() {
    super.initState();
    _loadGenrePlayTime();
  }

  Future<void> _loadGenrePlayTime({DateTime? startDate}) async {
    final data = await _statsGenresService.getGenrePlayTime(startDate: startDate);
    setState(() {
      genrePlayTime = data;
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

  @override
  Widget build(BuildContext context) {
    bool allZero = genrePlayTime.values.every((element) => element == 0);

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
        actions: const [],
        centerTitle: false,
        elevation: 2,
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5, 15, 5, 5),
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
                      child: IconButton(
                        icon: Icon(
                          Icons.filter_alt,
                          color: Theme.of(context).colorScheme.primary,
                          size: 24,
                        ),
                        onPressed: _showTimeRangeDialog,
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
                    ? const Center(child: CircularProgressIndicator())
                    : allZero
                        ? Center(
                            child: Text(
                              'No playing sessions recorded',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
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
                                  axisLine: AxisLine(width: 0), 
                                  labelIntersectAction: AxisLabelIntersectAction.trim, 
                                  labelStyle: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                primaryYAxis: const NumericAxis(
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  majorGridLines: MajorGridLines(width: 0), 
                                  axisLine: AxisLine(width: 0),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimeRangeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            'Select Time Range',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontFamily: 'Inter',
            ),
          ),
          content: DropdownButton<String>(
            value: _selectedFilter,
            items: <String>['All Time', 'Last Day', 'Last Week', 'Last Month', 'Last Year'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Inter',
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              Navigator.of(context).pop();
              if (newValue != null) {
                _onFilterSelected(newValue);
              }
            },
          ),
        );
      },
    );
  }
}
