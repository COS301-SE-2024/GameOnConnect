// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatefulWidget {
  const ActivityCard({
    super.key,
    required this.game,
  });

  final GameStats game;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  String formatLastPlayedDate(String lastPlayed) {
    // Parse the lastPlayed string into a DateTime object
    DateTime dateTime = DateTime.parse(lastPlayed);

    // Format the DateTime object into the desired string format
    DateFormat dateFormat = DateFormat('d MMMM yyyy');
    String formattedDate = dateFormat.format(dateTime);

    // Return the formatted date string
    return formattedDate;
  }

  String formatTimeRange(String lastPlayed, int timePlayed) {
    // Parse the lastPlayed string into a DateTime object
    DateTime startTime = DateTime.parse(lastPlayed);

    // Subtract the timePlayed duration from the endTime
    DateTime endTime = startTime.add(Duration(milliseconds: timePlayed));

    // Format the start and end times into the desired string format
    DateFormat timeFormat = DateFormat('HH:mm');
    String formattedStartTime = timeFormat.format(startTime);
    String formattedEndTime = timeFormat.format(endTime);

    // Return the formatted time range
    return '$formattedStartTime - $formattedEndTime';
  }

  String getEmojiForMood(String mood) {
    switch (mood) {
      case 'Scared':
        return '😱';
      case 'Disgusted':
        return '🤢';
      case 'Angry':
        return '😡';
      case 'Sad':
        return '😢';
      case 'Happy':
        return '😄';
      default:
        return '😶'; // Default emoji if mood is not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    final lastPlayedDateTime = formatLastPlayedDate(widget.game.lastPlayedDate);
    final timeRange =
        formatTimeRange(widget.game.lastPlayedDate, widget.game.timePlayedLast);
    return Container(
      margin: const EdgeInsets.fromLTRB(13, 0, 0, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(13, 12.5, 13.3, 12.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
                  child: Text(
                    lastPlayedDateTime,
                    style:  TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      height: 0.9,
                      color: Theme.of(context).brightness == Brightness.dark? Colors.grey: Colors.black,
                    ),
                  ),
                ),
                Text(
                  timeRange,
                  style:  TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    height: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 4.5, 0, 4.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                    child: Text(
                      widget.game.mood,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 0.9,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 1, 0),
                    child: Text(
                      getEmojiForMood(widget.game.mood),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        height: 0.9,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
