import 'package:flutter/material.dart';

class RankRowComponent extends StatelessWidget {
  final String rank;
  final String teamName;
  final int points;

  const RankRowComponent({
    required this.rank,
    required this.teamName,
    required this.points,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                  child: Text(
                    rank,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    teamName,
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                  child: Text(
                    points.toString(),
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}