import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/models/specific_badge_page.dart';

class AchievementBadgesPage extends StatefulWidget {
  const AchievementBadgesPage({super.key});

  @override
  State<AchievementBadgesPage> createState() => _AchievementBadgesPageState();
}

class _AchievementBadgesPageState extends State<AchievementBadgesPage> {
  //this is temporary
  List<String> badges = [
    'Loyalty',
    'Gamer',
    'Night Owl',
    'Newbie',
    'Explorer',
    'Event Planner',
    'Customizer',
    'Collector',
    'Achiever',
    'Social Butterfly'
  ];

  List<String> badgeImages = [
    'loyalty_badge.png',
    'gamer_badge.png',
    'night_owl_badge.png',
    'newbie_badge.png',
    'explorer_badge.png',
    'event_planner_badge.png',
    'customizer_badge.png',
    'collector_badge.png',
    'achiever_badge.png',
    'social_butterfly_badge.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Badges'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SpecificBadgePage()),
                  );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                          child: Image.asset(
                              'assets/badges_images/${badgeImages[index]}',
                              height: 85,
                              width: 85,
                              fit: BoxFit.contain)),
                      Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: Text(
                          "${badges[index]} Badge",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(9),
                        child: Text(
                          "2024/01/02",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
