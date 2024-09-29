import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/GameyCon/components/score.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          Theme.of(context).colorScheme.primaryContainer,
        ),
        side: WidgetStateProperty.all(
          BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 1,
          ),
        ),
      ),
      onPressed: () {
        ScoreManager().resetScore();
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.arrow_back),
      label: Text(
        'Leave',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
