import 'package:flutter/material.dart';
import 'package:gameonconnect/model/game_library_M/game_details_model.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/profile/custom_timeline_tile.dart';
import 'package:gameonconnect/view/pages/game_library/game_details_page.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../model/Stats_M/game_stats.dart';
import 'package:timeline_tile/timeline_tile.dart';


// ignore: must_be_immutable
class GameActivity extends StatefulWidget {
  GameActivity({super.key, 
   required this. gameStatsList,
    required this.gameId,
    required this.gameName,
  }) ;
  //final List<String>  gameIds;
  List<GameStats> gameStatsList;
  final String gameId;
  final String gameName;


  @override
  State<GameActivity> createState() => _GameActivityState();
}

class _GameActivityState extends State<GameActivity> {

  List<GameStats> getSpecificGameActivity() {
    print('nr of games: ${widget.gameStatsList.length} ');
    List<GameStats> activityList =widget.gameStatsList.where((game) => game.gameId == widget.gameId && game.timePlayedLast > 0).toList();
    print('Activity list: ${activityList.length}');
    return activityList;  
  }


  @override
  Widget build(BuildContext context) {
    List<GameStats> specificGameActivity =  getSpecificGameActivity();
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
          ? Center(child: Text('No recorded activity for ${widget.gameName}'))
          : Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(12, 0, 12, 19),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    '${widget.gameName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      letterSpacing: 0,
                      color:Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              Padding(
              padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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
          
         
    );
  }
}


