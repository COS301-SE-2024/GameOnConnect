import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/stats/stats_genres_bar_graph.dart';
import 'package:gameonconnect/view/components/stats/stats_leaderboard_pie_chart.dart';
import 'package:gameonconnect/view/components/stats/stats_mood_pie_chart.dart';
import 'package:gameonconnect/view/components/stats/stats_total_time_boxes.dart';

class StatsOverviewPage extends StatelessWidget {
  const StatsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'My Stats',
          style: TextStyle(
            fontFamily: 'Inter',
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildSectionHeader(context, 'Total Time'),
              const SizedBox(height: 10),
              const TotalTimeStatsComponent(),
              const SizedBox(height: 20),
              _buildSectionHeader(context, 'Mood'),
              const SizedBox(height: 10),
              const StatsMoodWidget(),
              const SizedBox(height: 20),
              _buildSectionHeader(context, 'Genres'),
              const SizedBox(height: 10),
              const GenresStatsComponent(),
              const SizedBox(height: 20),
              _buildSectionHeader(context, 'Leaderboard'),
              const SizedBox(height: 10),
              const StatsLeaderboardPage(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:gameonconnect/view/components/stats/stats_genres_bar_graph.dart';
// import 'package:gameonconnect/view/components/stats/stats_leaderboard_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_mood_pie_chart.dart';
// import 'package:gameonconnect/view/components/stats/stats_total_time_boxes.dart';

// class StatsOverviewPage extends StatelessWidget {
//   const StatsOverviewPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.primary,
//         title: Text(
//           'Stats Overview',
//           style: TextStyle(
//             fontFamily: 'Inter',
//             color: Theme.of(context).colorScheme.secondary,
//             fontSize: 32,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: const SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               TotalTimeStatsComponent(),
//               SizedBox(height: 20),
//               StatsMoodWidget(),
//               SizedBox(height: 20),
//               GenresStatsComponent(),
//               SizedBox(height: 20),
//               StatsLeaderboardPage(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
