import 'package:flutter/material.dart';

class WinnerComponent extends StatelessWidget {
  final String teamName;
  final String status;
  final String rank;
  final String points;

  const WinnerComponent({
    super.key,
    required this.teamName,
    required this.status,
    required this.rank,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const SizedBox(
                    width: 60,
                    height: 60,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teamName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              rank,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              "Rank",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              points,
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontFamily: "Inter",
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                            Text(
                              "Points",
                              style: TextStyle(
                                fontFamily: "Inter",
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary,
          thickness: 0.3,
        ),
      ],
    );
  }
}