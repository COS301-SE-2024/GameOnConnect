import 'package:flutter/material.dart';

class LeaderboardHeading extends StatelessWidget {
  const LeaderboardHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
          child: Row(
            children: [
              const Text(
                style: TextStyle(
                  fontFamily: "Inter",
                ),
                "Name",
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
        ),
        Row(
          children: [
            const Text(
              style: TextStyle(
                fontFamily: "Inter",
              ),
              "Points",
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }
}