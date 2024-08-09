// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/profile/Activity_indicator.dart';
import 'package:gameonconnect/view/components/profile/activity_card.dart';
//import 'package:timelines/timelines.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:timelines/timelines.dart';

class CustomTimelineTile extends StatefulWidget {

  const CustomTimelineTile({
    super.key,
    required this.isFirst,
    required this.isLast,
  });
final bool isFirst;
final bool isLast;

  @override
  State<CustomTimelineTile> createState() => _CustomTimelineTileState();
  
  }


class _CustomTimelineTileState extends State<CustomTimelineTile> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      //height: 40,
      child: TimelineTile(
      isFirst: widget.isFirst,
      isLast: widget.isLast,

      //decor lines
      beforeLineStyle: LineStyle(
        color: Theme.of(context).colorScheme.primary,
        thickness: 1 ,
      ),

      //decor circle
      indicatorStyle: IndicatorStyle(
        //width: 35,
        indicator: ActivityIndicator(
          size: 35,
          color: Theme.of(context).colorScheme.primary,
        ),
        drawGap: true,
      ),

      endChild: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child:  ActivityCard(),
        ) 
     
    ),

    );
  
                       
    
  }
}


