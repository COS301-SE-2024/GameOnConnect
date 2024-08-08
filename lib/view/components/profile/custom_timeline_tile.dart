// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/profile/activity_card.dart';
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
      height: 80,
      child: TimelineTile(
      isFirst: widget.isFirst,
      isLast: widget.isLast,

      //decor lines
      beforeLineStyle: LineStyle(
        color: Colors.grey
      ),

      //decor circle
      indicatorStyle: IndicatorStyle(
        width: 31,
        color: Colors.green,
        drawGap: true,
      ),

      endChild: ActivityCard(),
    ),

    );
    /*ListView.builder(
  itemCount: 5,
  shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(), // Disable internal scrolling
  itemBuilder: (context, index) {
    return Column(
      children: [
        TimelineTile(
          alignment: TimelineAlign.start,
          isFirst: index == 0,
          isLast: index == 5 - 1,
          indicatorStyle: IndicatorStyle(
            width: 31, // Set the diameter of the node
            height: 31, // Ensure the node is circular
            color: Colors.blue, // Node color
            indicator: Container(
              width: 31,  // Match the diameter
              height: 31, // Match the diameter
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.blue, // Outline color
                  //width: 2,
                ),
              ),
            ),
          ),
          beforeLineStyle: LineStyle(
            color: Colors.grey,
            //thickness: 46, // Thickness of the connecting line
          ),
          afterLineStyle: LineStyle(
            color: Colors.grey,
            //thickness: 46, // Thickness of the connecting line
          ),
          endChild: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            padding: EdgeInsets.all(12),
            height: 56, // Set the height of the container
            width: MediaQuery.of(context).size.width - 70, // Adjust width considering node and padding
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              'Hello',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ),
        if (index != 5 - 1) // Add spacing between containers but not after the last one
          SizedBox(height: 19),
      ],
    );
  },
);*/

    /*Container(
                margin: EdgeInsets.fromLTRB(12, 0, 12,19),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 12, 15, 13),
                        height: 31,
                      ),
                    ),
                     Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(13, 12.5, 13.3, 12.5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 9),
                                    child: Text(
                                      '12 July 2023',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 12,
                                        height: 0.9,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '12:00 - 13:42',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                      height: 0.9,
                                      color: Color(0xFFBEBEBE),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 4.5, 0, 4.5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 9, 0),
                                      child: Text(
                                        '😄',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 24,
                                          height: 0.9,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                                      child: Text(
                                        'Happy',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 0.9,
                                          color: Color(0xFFBEBEBE),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );*/
                       
    
  }
}

//            'Lorem ipsum dolor sit amet consectetur. Pellentesque amet et pellentesque risus tortor at senectus porta. Donec id convallis faucibus a porttitor viverra eleifend sed dignissim. In dui maecenas venenatis fermentum dolor turpis ut. Elementum venenatis neque at mi facilisi at donec in. Ac lacus facilisis lorem elit proin euismod.',

