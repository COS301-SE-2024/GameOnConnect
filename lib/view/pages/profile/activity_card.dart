// ignore_for_file: sized_box_for_whitespace, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:timelines/timelines.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:timelines/timelines.dart';

class ActivityCard extends StatefulWidget {

  const ActivityCard({
    super.key,
    //required this.isFirst,
    //required this.isLast,
  });
//final bool isFirst;
//final bool isLast;

  @override
  State<ActivityCard> createState() => _ActivityCardState();
  
  }


class _ActivityCardState extends State<ActivityCard> {

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: EdgeInsets.fromLTRB(13, 0, 0, 19),
      
      constraints: BoxConstraints(
        maxHeight: 56, // Set a maximum height for debugging
      ),
      child: Row(
       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         /* Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              //height: 31,
            ),
          ),*/
          //Expanded(
            //child: 
            Container(
              margin: EdgeInsets.fromLTRB(13, 0, 0, 0),
              //width: MediaQuery.of(context).size.width - 70,
              decoration: BoxDecoration(
                color: Color(0xFF2A2A2A),// dark grey
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
          //),
        ],
      ),
    );


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

