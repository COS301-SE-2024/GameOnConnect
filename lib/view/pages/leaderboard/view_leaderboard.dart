import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/leaderboard/rank_row_component.dart';
import 'package:gameonconnect/view/components/leaderboard/leaderboard_heading_component.dart';
import 'package:gameonconnect/view/components/leaderboard/tournament_name_component.dart';
import 'package:gameonconnect/view/components/leaderboard/winner_component.dart';

class ViewLeaderboard extends StatefulWidget {
  const ViewLeaderboard({super.key});

  @override
  State<ViewLeaderboard> createState() => _ViewLeaderboardState();
}

class _ViewLeaderboardState extends State<ViewLeaderboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Leaderboard",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () {
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewLeaderboard(),
                  ),
                ); */
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
                size: 25.0,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                TournamentNameComponent(
                  tournamentName: 'Poker Tournament',
                  onEditScoresPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewLeaderboard()));
                  },
                ),
                const SizedBox(
                  height: 25,
                ),
                const WinnerComponent(
                  teamName: "Team 1",
                  status: "Winning",
                  rank: "1st",
                  points: "20",
                ),
                const SizedBox(
                  height: 10,
                ),
                const LeaderboardHeading(),
              ],
            ),
          ),
          const SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                RankRowComponent(
                  rank: "2nd",
                  teamName: "Team 2",
                  points: 0,
                ),
                RankRowComponent(
                  rank: "3rd",
                  teamName: "Team 3",
                  points: 0,
                ),
                RankRowComponent(
                  rank: "4th",
                  teamName: "Team 4",
                  points: 0,
                ),
                RankRowComponent(
                  rank: "5th",
                  teamName: "Team 5",
                  points: 0,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
