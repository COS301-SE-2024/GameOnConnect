import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';
import 'package:gameonconnect/view/components/stats/stats_filter.dart';

class GenresStatsComponent extends StatefulWidget {
  const GenresStatsComponent({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GenresStatsComponentState createState() => _GenresStatsComponentState();
}

class _GenresStatsComponentState extends State<GenresStatsComponent> {
  Map<String, double> genrePlayTime = {};
  final StatsGenresService _statsGenresService = StatsGenresService();
  String _selectedFilter = 'All Time';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGenrePlayTime();
  }

  Future<void> _loadGenrePlayTime({DateTime? startDate}) async {
    setState(() {
      _isLoading = true;
    });
    final data = await _statsGenresService.getGenrePlayTime(startDate: startDate);
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

  @override
  Widget build(BuildContext context) {
    bool allZero = genrePlayTime.values.every((element) => element == 0);

    return Column(
      children: [
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
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : genrePlayTime.isEmpty
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
                : allZero
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
        ),
      ],
    );
  }
}
