import 'package:flutter/material.dart';

class TournamentNameComponent extends StatelessWidget {
  final String tournamentName;
  final VoidCallback onEditScoresPressed;

  const TournamentNameComponent({
    super.key,
    required this.tournamentName,
    required this.onEditScoresPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          tournamentName,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        MaterialButton(
          height: 30,
          minWidth: 30,
          onPressed: onEditScoresPressed,
          color: Theme.of(context).colorScheme.surface,
          textColor: Theme.of(context).colorScheme.secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0), // Rounded corners
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary, // Green edge
            ),
          ),
          child: const Text(
            'Edit Scores',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}