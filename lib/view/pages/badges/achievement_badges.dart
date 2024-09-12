import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AchievementBadgesPage extends StatefulWidget {
  const AchievementBadgesPage({super.key});

  @override
  State<AchievementBadgesPage> createState() => _AchievementBadgesPageState();
}

class _AchievementBadgesPageState extends State<AchievementBadgesPage> {
  //this is temporary
  List<String> badges = [
    'Loyalty',
    'Mountain',
    'Social Butterfly',
    'Customizer',
    'Newbie',
    'Gamer',
    'Collector',
    'Messanger',
    'Night Owl',
    'Globetrotter'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Badges'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemCount: badges.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: Image.network('https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png',
                          fit: BoxFit.cover)),
                  Padding(
                    padding: const EdgeInsets.all(9),
                    child: Text(
                      badges[index],
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
          );
        },
      ),
    );
  }
}
