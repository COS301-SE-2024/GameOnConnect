import 'package:flutter/material.dart';
// import 'package:gameonconnect/view/pages/stats/stats_page.dart';

class StatsList extends StatefulWidget {
  const StatsList({super.key ,required this.heading}) ;
  final String heading;

  @override
  State<StatsList > createState() => _StatsListState();
}

class _StatsListState extends State<StatsList > {
final List<String> labels = ['Mood', 'Genres', 'Total Time', 'Leaderboard'];
  final List<Color> greenShades = [
    const Color(0xFF3E8469),
    const Color(0xFF6AAE72),
    const Color(0xFFA9D571),
    const Color(0xFF69B09C),
  ];
  final List<IconData> icons = [
    Icons.psychology,
    Icons.sports_esports,
    Icons.leaderboard,
    Icons.local_offer,
  ];

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const StatsPage()),
        // );
        break;
      case 1:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const StatsPage()),
        // );
        break;
      case 2:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const StatsPage()),
        // );
        break;
      case 3:
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const StatsPage()),
        // );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            widget.heading,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height:100,
          child:  ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: labels.length,
      itemBuilder: (context, index) {
        final color = greenShades[index];
        final icon = icons[index];

        return GestureDetector(
          onTap: () => _navigateToPage(index),
          child: Container(
            width: 150,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  labels[index],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    ),
        ),
        ]
        );
        }
  
}