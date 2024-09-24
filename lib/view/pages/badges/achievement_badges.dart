import 'package:flutter/material.dart';
import 'package:gameonconnect/model/badges_M/badge_model.dart';
import 'package:gameonconnect/view/pages/badges/badge_page.dart';

class AchievementBadgesPage extends StatefulWidget {
  const AchievementBadgesPage({super.key});

  @override
  State<AchievementBadgesPage> createState() => _AchievementBadgesPageState();
}

class _AchievementBadgesPageState extends State<AchievementBadgesPage> {
  List<BadgeModel> badges = [
    BadgeModel(badgeName: 'Loyalty', badgeFile: 'loyalty_badge', badgeDescription: ' using the app for 10 consecutive days'),
    BadgeModel(badgeName: 'Gamer', badgeFile: 'gamer_badge', badgeDescription: ' playing games for a total of 20 hours'),
    BadgeModel(badgeName: 'Night Owl', badgeFile: 'night_owl_badge', badgeDescription: ' using the app after 10pm for 3 days'),
    BadgeModel(badgeName: 'Newbie', badgeFile: 'newbie_badge', badgeDescription: ' logging into the app for the first time'),
    BadgeModel(badgeName: 'Explorer', badgeFile: 'explorer_badge', badgeDescription: ' exploring all aspects and features of the app'),
    BadgeModel(badgeName: 'Event Planner', badgeFile: 'event_planner_badge', badgeDescription: ' creating more than 3 events'),
    BadgeModel(badgeName: 'Customizer', badgeFile: 'customizer_badge', badgeDescription: ' customizing your profile more than 3 days'),
    BadgeModel(badgeName: 'Collector', badgeFile: 'collector_badge', badgeDescription: ' adding more than 10 games to your "My Games"'),
    BadgeModel(badgeName: 'Achiever', badgeFile: 'achiever_badge', badgeDescription: ' getting a score of 15 in flappy bird'),
    BadgeModel(badgeName: 'Social Butterfly', badgeFile: 'social_butterfly_badge', badgeDescription: ' having more than 15 connections'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary
        ),
        title: Text('My Badges',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary)),
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
                  MaterialPageRoute(
                      builder: (context) => BadgePage(badge: badges[index])),
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
                              'assets/badges_images/${badges[index].badgeFile}.png',
                              height: 85,
                              width: 85,
                              fit: BoxFit.contain)),
                      Padding(
                        padding: const EdgeInsets.only(top: 9),
                        child: Text(
                          "${badges[index].badgeName} Badge",
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
