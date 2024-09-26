import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/badges/badge_page.dart';
import 'package:intl/intl.dart';

class AchievementBadgesPage extends StatefulWidget {
  final Map<String, dynamic> badges;

  const AchievementBadgesPage({super.key, required this.badges});

  @override
  State<AchievementBadgesPage> createState() => _AchievementBadgesPageState();
}

class _AchievementBadgesPageState extends State<AchievementBadgesPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
        title: Text('My Badges',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary)),
      ),
      body: widget.badges.isEmpty
          ? const Center(child: Text("No badges found"))
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: widget.badges.length,
                itemBuilder: (context, index) {
                  final badgeEntry = widget.badges.entries.elementAt(index);
                  final badgeName = badgeEntry.key;
                  final badgeDetails = badgeEntry.value;

                  return GestureDetector(
                    onTap: badgeDetails['unlocked'] &&
                            badgeDetails['date_unlocked'] != null
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BadgePage(badge: badgeEntry)),
                            );
                          }
                        : null,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Expanded(
                                  child: badgeDetails['unlocked'] &&
                                          badgeDetails['date_unlocked'] != null
                                      ? Image.asset(
                                          'assets/badges_images/$badgeName.png',
                                          height: 85,
                                          width: 85,
                                          fit: BoxFit.contain)
                                      : ColorFiltered(
                                          colorFilter:
                                              const ColorFilter.matrix(<double>[
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0.2126,
                                            0.7152,
                                            0.0722,
                                            0,
                                            0,
                                            0,
                                            0,
                                            0,
                                            1,
                                            0,
                                          ]),
                                          child: Image.asset(
                                            'assets/badges_images/$badgeName.png',
                                            height: 85,
                                            width: 85,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 9),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    badgeName
                                        .replaceAll('_', ' ')
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                badgeDetails['unlocked'] &&
                                        badgeDetails['date_unlocked'] != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(9),
                                        child: Text(
                                          DateFormat('yyyy/MM/dd').format(
                                              badgeDetails['date_unlocked']
                                                  .toDate()),
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ),
                        if (!badgeDetails['unlocked'] ||
                            badgeDetails['date_unlocked'] == null)
                          Positioned(
                            top: 15,
                            right: 15,
                            child: Icon(
                              Icons.lock,
                              color: Colors.white.withOpacity(0.8),
                              size: 24,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
