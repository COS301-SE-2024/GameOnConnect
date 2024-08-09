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
                margin: const EdgeInsets.fromLTRB(13, 0, 0, 19),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 9),
                            child: const Text(
                              '12 July 2023',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                height: 0.9,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                          const Text(
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
                        margin: const EdgeInsets.fromLTRB(0, 4.5, 0, 4.5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 9, 0),
                              child: const Text(
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
                              margin: const EdgeInsets.fromLTRB(0, 5.5, 0, 5.5),
                              child: const Text(
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
              );
          

  }
}


