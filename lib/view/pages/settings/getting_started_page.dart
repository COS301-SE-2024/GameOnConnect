// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/help/video_widget.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon:  Icon(
              key: Key('back_button'),
              Icons.arrow_back_rounded,
              color: Theme.of(context).colorScheme.surface,
              size: 30,
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
          title:  Text(
            key : Key('getting_started'),
            'Getting Started',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Theme.of(context).colorScheme.surface,
              fontSize: 30,
              letterSpacing: 0,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          elevation: 2,
        ),
        body: SafeArea(
            top: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      key: Key('Friends_section'),
                      width: 352,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 12,
                            color: Color(0x33000000),
                            offset: Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Friends',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        color: Theme.of(context).colorScheme.secondary,
                                        fontSize: 20,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis, //handles possible overflow
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             Divider(
                              height: 1,
                              thickness: 1,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            ListView(
                                physics: NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 0, 0, 1),
                                    child: Container(
                                      decoration:  BoxDecoration(
                                        color: Theme.of(context).colorScheme.surface,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ExpansionTile(
                                          key: Key('how_to_friends_List_tile'),
                                          title:  Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    12, 8, 12, 8),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'How to search for friends',
                                                    style: TextStyle(
                                                      fontFamily: 'Inter',
                                                      color: Theme.of(context).colorScheme.secondary,
                                                      letterSpacing: 0,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    overflow: TextOverflow.ellipsis, //handles possible overflow
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  decoration:
                                                       BoxDecoration(
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  decoration:
                                                       BoxDecoration(
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_searching_friends'),
                                                              'Navigate to the '
                                                              'search tab. '
                                                              'Select the Friends'
                                                              ' tab. You can now '
                                                              'search for friends'
                                                              ' using their username',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsetsDirectional
                                                          .fromSTEB(0, 4, 0, 0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                    child: TutorialVideo(videoPath: 'assets/videos/Connections_1.mp4'),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                  child: Container(
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('how_to_add_friends'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'How to add friends',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  overflow: TextOverflow.ellipsis, //handles possible overflow
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 4),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration:
                                                       BoxDecoration(
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_adding_friends'),
                                                              'To add friends,'
                                                              ' navigate to the'
                                                              ' search page , search'
                                                              ' for their profile.'
                                                              ' You will get a list'
                                                              ' of profiles.'
                                                              ' Select their profile'
                                                              ' and click the '
                                                              'Add friend button',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/Connections_2.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('Accepting_friends'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'Accepting/rejecting friend requests',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 4),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_friend_requests'),
                                                              'To accept or reject'
                                                              ' friend requests, '
                                                              'navigate to your'
                                                              ' profile. '
                                                              'Click on the'
                                                              ' Friends tab to see'
                                                              ' the friend requests',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/Connections_3.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                ]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      key: Key('game_library_section'),
                      width: 352,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 12,
                            color: Color(0x33000000),
                            offset: Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color:  Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Game Library',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontSize: 20,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                             Divider(
                              height: 1,
                              thickness: 1,
                              color: Theme.of(context).colorScheme.surface,
                            ),
                            ListView(
                              physics: NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 1),
                                  child: Container(
                                    decoration:  BoxDecoration(
                                      color: Theme.of(context).colorScheme.surface,
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 0,
                                          color: Theme.of(context).colorScheme.surface,
                                          offset: Offset(
                                            0,
                                            1,
                                          ),
                                        )
                                      ],
                                    ),
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('how_search_games'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'How to search for games',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child:  Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(12, 8, 12, 8),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(12,
                                                                      0, 0, 0),
                                                          child: Text(
                                                            key: Key('key_navigate_search_games'),
                                                            'Navigate to the'
                                                            ' search tab.'
                                                            ' Select the Games'
                                                            ' tab. You can now'
                                                            ' search for a game.',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Inter',
                                                              color: Theme.of(context).colorScheme.secondary,
                                                              fontSize: 14,
                                                              letterSpacing: 0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),

                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/GameLibrary_1.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ExpansionTile(
                                    key: Key('how_sort_games'),
                                    title:  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'How to sort the Game Library',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context).colorScheme.secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 4),
                                            child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Theme.of(context).colorScheme.surface,
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 8, 12, 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(12, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          key: Key('key_navigate_sort_games'),
                                                          'Navigate to the search'
                                                          ' tab. Click on the'
                                                          ' sort button and '
                                                          'select the sort '
                                                          'settings you want'
                                                          ' to apply to the'
                                                          ' Library',
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Theme.of(context).colorScheme.secondary,
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                              child: TutorialVideo(videoPath: 'assets/videos/GameLibrary_2.mp4'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ExpansionTile(
                                    key: Key('filter_games'),
                                    title:  Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 8),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              'How to filter the Game Library',
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                color: Theme.of(context).colorScheme.secondary,
                                                letterSpacing: 0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    children: [
                                      Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color:Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Container(
                                            width: double.infinity,
                                            decoration:  BoxDecoration(
                                              color: Theme.of(context).colorScheme.surface,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 0, 0, 4),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child:  Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(12, 8, 12, 8),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(12, 0,
                                                                    0, 0),
                                                        child: Text(
                                                          key: Key('key_how_to_filter_games'),
                                                          'Navigate to the search'
                                                          ' tab. Click on the'
                                                          ' filter button and '
                                                          'select the filter'
                                                          ' you want to apply '
                                                          'to the Game Library.',
                                                          style: TextStyle(
                                                            fontFamily: 'Inter',
                                                            color: Theme.of(context).colorScheme.secondary,
                                                            fontSize: 14,
                                                            letterSpacing: 0,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                              child: TutorialVideo(videoPath: 'assets/videos/GameLibrary_3.mp4'),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(),
                                            ),
                                          ),
                                        ],
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      key: Key('game_information_section'),
                      width: 352,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 12,
                            color: Color(0x33000000),
                            offset: Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 12, 0, 4),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      12, 0, 12, 12),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Game Information',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontSize: 20,
                                          letterSpacing: 0,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                 Divider(
                                  height: 1,
                                  thickness: 1,
                                  color: Theme.of(context).colorScheme.surface,
                                ),
                                ListView(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 0, 0, 1),
                                      child: Container(
                                        decoration:  BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                        ),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: ExpansionTile(
                                            key: Key('view_game_info'),
                                            title: Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(12, 8, 12, 8),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children:  [
                                                  Flexible(
                                                    child: Text(
                                                      'How to view more information about a game',
                                                      style: TextStyle(
                                                        fontFamily: 'Inter',
                                                        color:
                                                        Theme.of(context).colorScheme.secondary,
                                                        letterSpacing: 0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            children: [
                                              Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Container(
                                                    width: double.infinity,
                                                    decoration:
                                                         BoxDecoration(
                                                      color: Theme.of(context).colorScheme.surface,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: double.infinity,
                                                    decoration:
                                                         BoxDecoration(
                                                      color: Theme.of(context).colorScheme.surface,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child:  Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12, 8, 12, 8),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          12,
                                                                          0,
                                                                          0,
                                                                          0),
                                                              child: Text(
                                                                key: Key('key_view_specific_game'),
                                                                'When you click'
                                                                ' on a specific '
                                                                'game in the Game'
                                                                ' Library, you '
                                                                'will be taken'
                                                                ' to a page with'
                                                                ' more'
                                                                ' information'
                                                                ' about the Game'
                                                                ' you selected.'
                                                                ' Here you will'
                                                                ' find the '
                                                                'different genres,'
                                                                ' Game '
                                                                'description, '
                                                                'screenshots of '
                                                                'the game and'
                                                                ' much more.',
                                                                style:
                                                                    TextStyle(
                                                                  fontFamily:
                                                                      'Inter',
                                                                  color: Theme.of(context).colorScheme.secondary,
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 4, 0, 0),
                                                    child: Container(
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                  
                                                  SizedBox(
                                                    width: double.infinity,
                                                    child: Padding(
                                                      padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                      child: TutorialVideo(videoPath: 'assets/videos/GameInfo_1.mp4'),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('share_game_info'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'How to share a game ',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 4),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration:
                                                       BoxDecoration(
                                                    color: Theme.of(context).colorScheme.surface,
                                                  ),
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_sharing_game_info'),
                                                              'Select a Game you'
                                                              ' want to share.'
                                                              'Click on the share'
                                                              ' button. This will'
                                                              ' allow you to copy'
                                                              ' the link for'
                                                              ' sharing',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/GameInfo_2.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('add_game_to_wishlist'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'How do I add a game to my wishlist',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 8, 12, 8),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_add_to_wishlist'),
                                                              'To add a game to '
                                                              'your wishlist,'
                                                              ' navigate to '
                                                              ' specific game you'
                                                              ' want to add to '
                                                              'your wishlist.'
                                                              ' Click on the Add'
                                                              ' to wishlist '
                                                              'button. This will'
                                                              ' add the game '
                                                              'to your wishlist.',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/GameInfo_3.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('add_to_currently_playing'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'How to add a game to my Currently Playings list',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 8, 12, 8),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_navigate_to_currently_playing'),
                                                              'To add a game to'
                                                              ' your'
                                                              ' currently '
                                                              'playing, '
                                                              'navigate'
                                                              ' to  specific '
                                                              'game you '
                                                              'want to add to '
                                                              'the list.'
                                                              ' Click on the '
                                                              'Add to '
                                                              'currently playing'
                                                              ' button.'
                                                              ' This will add '
                                                              'the game'
                                                              ' to your '
                                                              'currently '
                                                              'playing '
                                                              'list. ',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/GameInfo_4.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: ExpansionTile(
                                        key: Key('remove_from_wishlist'),
                                        title:  Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  12, 8, 12, 8),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  'How do I remove a game from my Wishlist',
                                                  style: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                decoration:  BoxDecoration(
                                                  color: Theme.of(context).colorScheme.surface,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(12, 8, 12, 8),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(
                                                                12, 8, 12, 8),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        12,
                                                                        0,
                                                                        0,
                                                                        0),
                                                            child: Text(
                                                              key: Key('key_removing_from_wishlist'),
                                                              'To remove a game '
                                                              'to your '
                                                              'wishlist, '
                                                              'navigate to your'
                                                              ' profile. Click'
                                                              ' on the '
                                                              'Wishlist tab. '
                                                              'This will'
                                                              ' show you '
                                                              'all the'
                                                              ' games in your'
                                                              ' Wishlist.'
                                                              ' Click on the'
                                                              ' game you want'
                                                              ' to remove from '
                                                              'your '
                                                              'wishlist. This '
                                                              'will take'
                                                              ' you to that '
                                                              'game page. '
                                                              'Click on the'
                                                              ' Remove'
                                                              ' from Wishlist'
                                                              ' button .'
                                                              ' The game is now'
                                                              ' removed'
                                                              ' from your '
                                                              'wishlist.',
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    'Inter',
                                                                color: Theme.of(context).colorScheme.secondary,
                                                                fontSize: 14,
                                                                letterSpacing:
                                                                    0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                                                  child: TutorialVideo(videoPath: 'assets/videos/GameInfo_5.mp4'),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                                                child: Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
