import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'game_list.dart';
import 'stats_card.dart';
import 'profile_section.dart';

class Profilenew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Column(
                        children: [
                          // Banner
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('../../../../../assets/images/rectangle_40.jpeg'), // Your banner image
                              ),
                            ),
                          ),
                          // Bottom container
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width/1.5,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.grey[800],//dark mode
                              border: Border.all(
                                color: Theme.of(context).colorScheme.primary, 
                                width: 2, // Set the border width
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Profile picture
                      Positioned(
                        top: 120, // Adjust this value to move the profile picture downwards
                        left: (MediaQuery.of(context).size.width - 100) / 2, // Center the profile picture
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle, // Make it circular
                              /*border: Border.all(
                                color: Colors.red, // Set your desired border color
                                width: 2, // Set the border width
                              ),*/
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('../../../../../assets/images/ellipse_20.jpeg'), // Your profile picture
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60), //space 

                  Container(
                    margin: EdgeInsets.fromLTRB(19, 0, 19, 4.4),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(7, 4, 8.1, 0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFF00FF75)),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //start of currently playing fortnite
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 3.5, 3),
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      '../../../../../assets/images/image_3.png',
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 147,
                                  height: 101,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 1, 0, 0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(3.5, 0, 3.5, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Fortnite',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 20,
                                          height: 0.9,
                                          color: Color(0xFFC4C4C4),
                                        ),
                                          
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 13.9, 7.3),
                                    child: SizedBox(
                                      width: 138.5,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 11.9, 0, 0),
                                            child: SizedBox(
                                              width: 62.5,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 10.1, 0),
                                                    child: SizedBox(
                                                      width: 13.4,
                                                      height: 13.9,
                                                      child: SvgPicture.asset(
                                                        '../../../../../assets/vectors/vector_2_x2.svg',
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(0, 0, 9.8, 0),
                                                    child: SizedBox(
                                                      width: 12.7,
                                                      height: 13.9,
                                                      child: SvgPicture.asset(
                                                        '../../../../../assets/vectors/vector_1_x2.svg',
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 16.5,
                                                    height: 13.9,
                                                    child: SvgPicture.asset(
                                                      '../../../../../assets/vectors/vector_x2.svg',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(0, 0, 0, 4.7),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xFFEE1313),
                                                borderRadius: BorderRadius.circular(3),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(7, 4, 9.5, 3),
                                                child: Text(
                                                  'LIVE',
                                                  style:  TextStyle(
                                                    ////'Inter',
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    height: 0.9,
                                                    color: Color(0xFF000000),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(3.5, 0, 3.5, 8),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Released: 2017/04/24 ',
                                        style:  TextStyle(
                                          ////'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 0.9,
                                          color: Color(0xFFF5F5F5),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(3.5, 0, 0, 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 3.9, 0),
                                          child: Text(
                                            'Genres: ',
                                            style:  TextStyle(
                                             // //'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                              height: 0.9,
                                              color: Color(0xFFC4C4C4),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 1, 5.8, 1),
                                          child: Text(
                                            'Action',
                                            style:  TextStyle(
                                              ////'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              decoration: TextDecoration.underline,
                                              height: 0.9,
                                              color: Color(0xFF00FF75),
                                              decorationColor: Color(0xFF00FF75),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(0, 1, 0, 1),
                                          child: Text(
                                            'Battle Royale',
                                            style:  TextStyle(
                                              ////'Inter',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              decoration: TextDecoration.underline,
                                              height: 0.9,
                                              color: Color(0xFF00FF75),
                                              decorationColor: Color(0xFF00FF75),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(3.5, 0, 3.5, 0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Publisher: Epic Games ',
                                        style:  TextStyle(
                                          ////'Inter',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          height: 0.9,
                                          color: Color(0xFFC4C4C4),
                                        ),
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
                  Container(
                    margin: EdgeInsets.fromLTRB(21, 0, 21, 4.5),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 327,
                        child: Stack(
                          children: [
                            Container(
                              width: 327,
                              padding: EdgeInsets.fromLTRB(0, 11.7, 118.4, 7.4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFFC4C4C4)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Search Games',
                                style:  TextStyle(
                                  //'Prompt',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1,
                                  color: Color(0xFF525252),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 22,
                              top: 7.1,
                              child: Container(
                                width: 18,
                                height: 18,
                                child: Container(
                                  width: 18,
                                  height: 18,
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: SvgPicture.asset(
                                      '../../../../../assets/vectors/icon_1_x2.svg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(18.9, 0, 3, 13),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(7.4, 0, 7.4, 3),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'My Games',
                              style:  TextStyle(
                                ////'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 1.4,
                                letterSpacing: 0.5,
                                color: Color(0xFFC4C4C4),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(4.1, 0, 0, 15.7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 13, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_3.png',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89.3,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 11, 0.3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_8.jpeg',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0.3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_9.png',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 93,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(175.1, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                gradient: LinearGradient(
                                  begin: Alignment(-1, 0),
                                  end: Alignment(1, 0),
                                  colors: <Color>[Color(0xFF00FF75), Color(0xFF009946)],
                                  stops: <double>[0, 1],
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15.3, 0, 16.3, 0),
                                child: Text(
                                  'see more',
                                  style:  TextStyle(
                                    ////'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    height: 2.1,
                                    letterSpacing: 0.5,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Recent Activity',
                              style:  TextStyle(
                                //'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 1.4,
                                letterSpacing: 0.5,
                                color: Color(0xFFC4C4C4),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0.1, 0, 2, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 13, 3.7),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_3.png',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89.3,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 13, 4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_8.jpeg',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        '../../../../../assets/images/image_9.png',
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height: 93,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(195, 0, 0, 0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          gradient: LinearGradient(
                            begin: Alignment(-1, 0),
                            end: Alignment(1, 0),
                            colors: <Color>[Color(0xFF00FF75), Color(0xFF009946)],
                            stops: <double>[0, 1],
                          ),
                        ),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15.3, 0, 16.3, 0),
                          child: Text(
                            'see more',
                            style:  TextStyle(
                              //'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 2.1,
                              letterSpacing: 0.5,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(16.8, 0, 0, 58),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Want To play ',
                              style:  TextStyle(
                                //'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                                height: 1.4,
                                letterSpacing: 0.5,
                                color: Color(0xFFC4C4C4),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(9.2, 0, 0, 15.7),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 13, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_3.png',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89.3,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 4, 11, 0.3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_8.jpeg',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 89,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0.3),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          '../../../../../assets/images/image_9.png',
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 93,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(180.2, 0, 0, 0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                gradient: LinearGradient(
                                  begin: Alignment(-1, 0),
                                  end: Alignment(1, 0),
                                  colors: <Color>[Color(0xFF00FF75), Color(0xFF009946)],
                                  stops: <double>[0, 1],
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15.3, 0, 16.3, 0),
                                child: Text(
                                  'see more',
                                  style:  TextStyle(
                                    //'Inter',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    height: 2.1,
                                    letterSpacing: 0.5,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(31, 0, 31, 0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFF3E8469),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: SizedBox(
                                      width: 153,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(20, 62, 20, 29),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Text(
                                              'Mood Journal',
                                              style:  TextStyle(
                                                //'Alegreya Sans',
                                                fontWeight: FontWeight.w500,
                                                fontSize: 20,
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -29,
                                              child: SizedBox(
                                                width: 153,
                                                height: 100,
                                                child: SvgPicture.asset(
                                                  '../../../../../assets/vectors/vector_3_x2.svg',
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: -8,
                                              bottom: -9,
                                              child: SizedBox(
                                                height: 22,
                                                child: Text(
                                                  'Mood ',
                                                  style:  TextStyle(
                                                    //'Alegreya Sans',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              left: -8,
                                              child: Container(
                                                width: 16.5,
                                                height: 17.3,
                                                child: SizedBox(
                                                  width: 16.5,
                                                  height: 17.3,
                                                  child: SvgPicture.asset(
                                                    '../../../../../assets/vectors/group_x2.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF69B09C),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 15,
                                        child: SizedBox(
                                          width: 153,
                                          height: 100,
                                          child: SvgPicture.asset(
                                            '../../../../../assets/vectors/vector_4_x2.svg',
                                          ),
                                        ),
                                      ),
                                SizedBox(
                                        width: 153,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(12, 0, 0, 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      fit: BoxFit.contain,
                                                      image: AssetImage(
                                                        '../../../../../assets/images/ps_controller.png',
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'Total time ',
                                                  style:  TextStyle(
                                                    //'Alegreya Sans',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(0xFFFFFFFF),
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
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Color(0xFF6AAE72),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Stack(
                                    children: [
                                    Positioned(
                                      top: 15,
                                      child: SizedBox(
                                        width: 153,
                                        height: 100,
                                        child: SvgPicture.asset(
                                          '../../../../../assets/vectors/vector_5_x2.svg',
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                        width: 153,
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(12, 0, 0, 20),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.fromLTRB(4, 0, 4, 4),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: AssetImage(
                                                          '../../../../../assets/images/scorecard.png',
                                                        ),
                                                      ),
                                                    ),
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  'leaderboard',
                                                  style:  TextStyle(
                                                   // 'Alegreya Sans',
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                    color: Color(0xFFFFFFFF),
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
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFA9D571),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 15,
                                      child: SizedBox(
                                        width: 153,
                                        height: 100,
                                        child: SvgPicture.asset(
                                          '../../../../../assets/vectors/vector_6_x2.svg',
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                      width: 153,
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(12, 0, 0, 20),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.fromLTRB(2, 0, 2, 0.4),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: SizedBox(
                                                  width: 18,
                                                  height: 17.6,
                                                  child: SvgPicture.asset(
                                                    '../../../../../assets/vectors/group_35_x2.svg',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                'Genres',
                                                style:  TextStyle(
                                                  //'Alegreya Sans',
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 18,
                                                  color: Color(0xFFFFFFFF),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
        ),
      ),
    );
  }
}
