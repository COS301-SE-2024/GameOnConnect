import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/profile/custom_timeline_tile.dart';
import '../../../model/Stats_M/game_stats.dart';

// ignore: must_be_immutable
class GameActivity extends StatefulWidget {
  GameActivity({
    super.key,
    required this.gameStatsList,
    required this.gameId,
    required this.gameName,
  });
  //final List<String>  gameIds;
  List<GameStats> gameStatsList;
  final String gameId;
  final String gameName;

  @override
  State<GameActivity> createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {
  List<GameStats> getSpecificGameActivity() {
    List<GameStats> activityList = widget.gameStatsList
        .where(
            (game) => game.gameId == widget.gameId && game.timePlayedLast > 0)
        .toList()
      ..sort((a, b) => DateTime.parse(b.lastPlayedDate)
          .compareTo(DateTime.parse(a.lastPlayedDate)));
    return activityList;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<GameStats> specificGameActivity = getSpecificGameActivity();
    return Scaffold(
      appBar: BackButtonAppBar(
        title: 'Activity',
        onBackButtonPressed: () {
          Navigator.pop(context);
        },
        iconkey: const Key('Back_button_key'),
        textkey: const Key('activity_text'),
      ),
      body: specificGameActivity.isEmpty
          ? Center(
              child: Text.rich(
                TextSpan(
                  text: 'No recorded activity for ',
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.gameName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(12, 12, 12, 19),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.gameName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: 0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(), //s
                      itemCount: specificGameActivity.length,
                      itemBuilder: (context, index) {
                        return CustomTimelineTile(
                          isFirst: index == 0,
                          isLast: index == specificGameActivity.length - 1,
                          game: specificGameActivity[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
