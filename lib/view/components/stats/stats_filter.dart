import 'package:flutter/material.dart';

class StatsFilterDialog extends StatelessWidget {
  final String selectedFilter;
  final ValueChanged<String> onFilterSelected;

  const StatsFilterDialog({
    Key? key,
    required this.selectedFilter,
    required this.onFilterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      title: Text(
        'Select Time Range',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: 'Inter',
        ),
      ),
      content: DropdownButton<String>(
        value: selectedFilter,
        items: <String>['All Time', 'Last Day', 'Last Week', 'Last Month', 'Last Year'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: 'Inter',
              ),
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          Navigator.of(context).pop();
          if (newValue != null) {
            onFilterSelected(newValue);
          }
        },
      ),
    );
  }
}

void showStatsFilterDialog(BuildContext context, String selectedFilter, ValueChanged<String> onFilterSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatsFilterDialog(
        selectedFilter: selectedFilter,
        onFilterSelected: onFilterSelected,
      );
    },
  );
}
