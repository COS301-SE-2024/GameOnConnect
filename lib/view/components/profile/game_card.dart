import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfileGamesCard extends StatefulWidget {

  const ProfileGamesCard({
    super.key,
    required this. image,
    required this. name,
    required this. lastPlayedDate,
    required this. timePlayed,
    required this. playing,
  });

  final String image;
  final String name;
  final lastPlayedDate;
  final timePlayed;
  final bool playing;

  @override
  State<ProfileGamesCard> createState() => _ProfileGamesCardState();
  
  }


class _ProfileGamesCardState extends State<ProfileGamesCard> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 0), // Adjust spacing as needed
      child: Container(
  width: double.infinity,
  child: Align(
    alignment: Alignment.topLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
          child: widget.playing
          ?                 Container(
                  //margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                  'https://thumbs.dreamstime.com/b/portrait-young-pretty-female-gamer-playing-shooter-neon-lighting-portrait-young-pretty-female-gamer-playing-272077632.jpg',
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF00FF75),
                        offset: Offset(0, 0),
                        blurRadius: 5.3499999046,
                      ),
                    ],
                  ),
                  child: Container(
                    width: 112,
                    height: 70,
                  ),
                )
          :Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                fit: BoxFit.cover,
                /*image: NetworkImage(
                  //'https://thumbs.dreamstime.com/b/portrait-young-pretty-female-gamer-playing-shooter-neon-lighting-portrait-young-pretty-female-gamer-playing-272077632.jpg',
                  widget.image,                
                ),*/
                image: CachedNetworkImageProvider(widget.image),
              ),
            ),
            child: Container(
              width: 112,
              height: 70,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Text(
                    //'The Witcher wujsggeuk32ji90dyvc2mnid2',
                    widget.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      //height: 0.9,
                      color: Color(0xFFFFFFFF),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                if (widget.playing==false)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      '${widget.timePlayed} hrs on record',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        height: 0.9,
                        color: Color(0xFFBEBEBE),
                      ),
                    ),
                  ),
                ),
                if (widget.timePlayed > 0)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 7.8, 0),
                  child: Text(
                    'last played ${widget.lastPlayedDate}',
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                      height: 0.9,
                      color: Color(0xFFBEBEBE),
                    ),
                  ),
                ),
                if (widget.playing== true)
                Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 7.8, 0),
                  child: Text(
                    'playing now',
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
        ),
      ],
    ),
  ),
),

    );
    
  }
}

//            'Lorem ipsum dolor sit amet consectetur. Pellentesque amet et pellentesque risus tortor at senectus porta. Donec id convallis faucibus a porttitor viverra eleifend sed dignissim. In dui maecenas venenatis fermentum dolor turpis ut. Elementum venenatis neque at mi facilisi at donec in. Ac lacus facilisis lorem elit proin euismod.',

