import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';

class GenresStatsPage extends StatefulWidget {
  const GenresStatsPage({super.key});

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
                                legend: Legend(
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
                                        '${genre}: ${value}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    );
                                  },
                                ),
                                primaryXAxis: CategoryAxis(
                                  labelRotation: 0,
                                  majorGridLines: MajorGridLines(width: 0), // Remove grid lines
                                  axisLine: AxisLine(width: 0), // Remove the axis line
                                  labelIntersectAction: AxisLabelIntersectAction.trim, // Handle long labels
                                  labelStyle: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                primaryYAxis: NumericAxis(
                                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                                  majorGridLines: MajorGridLines(width: 0), // Remove grid lines
                                  axisLine: AxisLine(width: 0), // Remove the axis line
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
}





// tooltipBehavior: TooltipBehavior(
//   enable: true,
//   header: '',
//   canShowMarker: false,
//   builder: (dynamic data, ChartPoint<dynamic> point, ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
//     final genre = genrePlayTime.keys.elementAt(pointIndex);
//     final value = genrePlayTime[genre] ?? 0.0;
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       color: Colors.black,
//       child: Text(
//         '${genre}: ${value}',
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   },
// ),














// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';

// class GenresStatsPage extends StatefulWidget {
//   const GenresStatsPage({super.key});

//   @override
//   _GenresStatsPageState createState() => _GenresStatsPageState();
// }

// class _GenresStatsPageState extends State<GenresStatsPage> {
//   Map<String, double> genrePlayTime = {};
//   final StatsGenresService _statsGenresService = StatsGenresService();

//   @override
//   void initState() {
//     super.initState();
//     _loadGenrePlayTime();
//   }

//   Future<void> _loadGenrePlayTime() async {
//     final data = await _statsGenresService.getGenrePlayTime();
//     setState(() {
//       genrePlayTime = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool allZero = genrePlayTime.values.every((element) => element == 0);

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         automaticallyImplyLeading: false,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_rounded,
//             color: Theme.of(context).colorScheme.secondary,
//             size: 30,
//           ),
//           onPressed: () async {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(
//           'Genres',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 32,
//             letterSpacing: 0,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         actions: const [],
//         centerTitle: false,
//         elevation: 2,
//       ),
//       body: SafeArea(
//         top: true,
//         child: Column(
//           mainAxisSize: MainAxisSize.max,
//           children: [
//             Padding(
//               padding: const EdgeInsetsDirectional.fromSTEB(5, 15, 5, 5),
//               child: Row(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Text(
//                     'Filter',
//                     style: TextStyle(
//                       fontFamily: 'Inter',
//                       color: Theme.of(context).colorScheme.secondary,
//                       letterSpacing: 0,
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
//                     child: Icon(
//                       Icons.filter_alt,
//                       color: Theme.of(context).colorScheme.primary,
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//               thickness: 1,
//               color: Theme.of(context).colorScheme.secondary,
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//               child: genrePlayTime.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : allZero
//                       ? Center(
//                           child: Text(
//                             'No playing sessions recorded',
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               color: Theme.of(context).colorScheme.secondary,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         )
//                       : Expanded(
//                           child: SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Padding(
//                               padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                               child: SizedBox(
//                                 width: genrePlayTime.keys.length * 80.0,
//                                 child: SfCartesianChart(
//                                   legend: const Legend(isVisible: false),
//                                   tooltipBehavior: TooltipBehavior(
//                                     enable: true,
//                                     // Use the builder method for customization
//                                     builder: (dynamic data, ChartPoint<dynamic> point, ChartSeries<dynamic, dynamic> series, int pointIndex, int seriesIndex) {
//                                       final dataPoint = genrePlayTime.entries.toList()[pointIndex];
//                                       return Container(
//                                         padding: const EdgeInsets.all(8.0),
//                                         color: Colors.black,
//                                         child: Text(
//                                           '${dataPoint.key}: ${dataPoint.value}',
//                                           style: const TextStyle(color: Colors.white),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                   primaryXAxis: CategoryAxis(
//                                     majorGridLines: const MajorGridLines(width: 0),
//                                     axisLine: const AxisLine(width: 0),
//                                     labelIntersectAction: AxisLabelIntersectAction.trim,
//                                     labelStyle: const TextStyle(
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                   primaryYAxis: NumericAxis(
//                                     edgeLabelPlacement: EdgeLabelPlacement.shift,
//                                     majorGridLines: const MajorGridLines(width: 0),
//                                     axisLine: const AxisLine(width: 0),
//                                   ),
//                                   series: <CartesianSeries>[
//                                     BarSeries<MapEntry<String, double>, String>(
//                                       dataSource: genrePlayTime.entries.toList(),
//                                       xValueMapper: (MapEntry<String, double> entry, _) => entry.key,
//                                       yValueMapper: (MapEntry<String, double> entry, _) => entry.value,
//                                       color: Theme.of(context).colorScheme.primary,
//                                       dataLabelSettings: const DataLabelSettings(isVisible: true),
//                                       enableTooltip: true,
//                                     ),
//                                   ],
//                                   borderColor: Colors.transparent,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }










// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:gameonconnect/services/stats_S/stats_genres_service.dart';

// class GenresStatsPage extends StatefulWidget {
//   const GenresStatsPage({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _GenresStatsPageState createState() => _GenresStatsPageState();
// }

// class _GenresStatsPageState extends State<GenresStatsPage> {
//   Map<String, double> genrePlayTime = {};
//   final StatsGenresService _statsGenresService = StatsGenresService();

//   @override
//   void initState() {
//     super.initState();
//     _loadGenrePlayTime();
//   }

//   Future<void> _loadGenrePlayTime() async {
//     final data = await _statsGenresService.getGenrePlayTime();
//     setState(() {
//       genrePlayTime = data;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool allZero = genrePlayTime.values.every((element) => element == 0);

//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           automaticallyImplyLeading: false,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_rounded,
//               color: Theme.of(context).colorScheme.secondary,
//               size: 30,
//             ),
//             onPressed: () async {
//               Navigator.of(context).pop();
//             },
//           ),
//           title: Text(
//             'Genres',
//             style: TextStyle(
//               fontFamily: 'Inter',
//               color: Theme.of(context).colorScheme.secondary,
//               fontSize: 32,
//               letterSpacing: 0,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           actions: const [],
//           centerTitle: false,
//           elevation: 2,
//         ),
//         body: SafeArea(
//           top: true,
//           child: Column(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Padding(
//                 padding: const EdgeInsetsDirectional.fromSTEB(5, 15, 5, 5),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.max,
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Text(
//                       'Filter',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         color: Theme.of(context).colorScheme.secondary,
//                         letterSpacing: 0,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 0),
//                       child: Icon(
//                         Icons.filter_alt,
//                         color: Theme.of(context).colorScheme.primary,
//                         size: 24,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                 thickness: 1,
//                 color: Theme.of(context).colorScheme.secondary,
//               ),
//               Padding(
//               padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
//               child: genrePlayTime.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : allZero
//                       ? Center(
//                           child: Text(
//                             'No playing sessions recorded',
//                             style: TextStyle(
//                               fontFamily: 'Inter',
//                               color: Theme.of(context).colorScheme.secondary,
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         )
//                   : AspectRatio(
//                       aspectRatio: 1.5,
//                       child: BarChart(
//                         BarChartData(
//                           barTouchData: BarTouchData(
//                             enabled: true,
//                             touchTooltipData: BarTouchTooltipData(
//                               // tooltipBgColor: Colors.transparent,
//                               getTooltipItem: (
//                                 BarChartGroupData group,
//                                 int groupIndex,
//                                 BarChartRodData rod,
//                                 int rodIndex,
//                               ) {
//                                 return BarTooltipItem(
//                                   '${genrePlayTime.keys.elementAt(groupIndex)}: ${rod.toY.round()} time(s)',
//                                   TextStyle(
//                                     color: Theme.of(context).colorScheme.surface,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           titlesData: FlTitlesData(
//                             bottomTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: true,
//                                 reservedSize: 40,
//                                 getTitlesWidget: (value, meta) {
//                                   final genre = genrePlayTime.keys.elementAt(value.toInt());
//                                   return SideTitleWidget(
//                                     axisSide: meta.axisSide,
//                                     space: 4,
//                                     child: Text(
//                                       genre,
//                                       style: TextStyle(
//                                         color: Theme.of(context).colorScheme.secondary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             leftTitles: AxisTitles(
//                               sideTitles: SideTitles(
//                                 showTitles: false,
//                                 reservedSize: 40,
//                                 getTitlesWidget: (value, meta) {
//                                   return SideTitleWidget(
//                                     axisSide: meta.axisSide,
//                                     space: 6,
//                                     child: Text(
//                                       value.toInt().toString(),
//                                       style: TextStyle(
//                                         color: Theme.of(context).colorScheme.secondary,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                             topTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                             rightTitles: const AxisTitles(
//                               sideTitles: SideTitles(showTitles: false),
//                             ),
//                           ),
//                           borderData: FlBorderData(
//                             show: true,
//                             border: Border.all(
//                               color: Theme.of(context).colorScheme.surface,
//                               width: 1,
//                             ),
//                           ),
//                           barGroups: List.generate(
//                             genrePlayTime.keys.length,
//                             (index) {
//                               final genre = genrePlayTime.keys.elementAt(index);
//                               return BarChartGroupData(
//                                 x: index,
//                                 barRods: [
//                                   BarChartRodData(
//                                     toY: genrePlayTime[genre]!,
//                                     color: Theme.of(context).colorScheme.primary,
//                                     width: 15
//                                   ),
//                                 ],
//                               );
//                             },
//                           ),
//                           gridData: const FlGridData(show: false),
//                           alignment: BarChartAlignment.spaceEvenly,
//                           maxY: genrePlayTime.values.isNotEmpty ? genrePlayTime.values.reduce((a, b) => a > b ? a : b) : 0,
//                         ),
//                       ),
//                     ),
//                   ),
//             ],
//         ),
//       ),
//     );
//   }
// }