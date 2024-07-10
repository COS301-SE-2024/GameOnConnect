import '../../components/card/event_card.dart';
import '../../components/card/joined_event_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';


class viewEvents extends StatefulWidget {
  const viewEvents({super.key});

  @override
  State<viewEvents> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<viewEvents>
    with TickerProviderStateMixin {

  final scaffoldKey = GlobalKey<ScaffoldState>();
   TabController? tabController;
  @override
  void initState() {
    super.initState();
     tabController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => setState(() {}));

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor:Theme.of(context).colorScheme.surface,

        body: SafeArea(
          top: true,
          child: DefaultTabController(
            length:3,
            child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 5, 0, 0),
                  child: Text(
                    'Joined events:',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      letterSpacing: 0,
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 22,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 150,
                  child: CarouselSlider(
                    items: const [
                      UpcomingEventCardWidget(),
                      UpcomingEventCardWidget(),
                      UpcomingEventCardWidget(),

                    ],
                    carouselController: CarouselController(),
                    options: CarouselOptions(
                      initialPage: 1,
                      viewportFraction: 0.5,
                      disableCenter: true,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.25,
                      enableInfiniteScroll: false,
                      scrollDirection: Axis.horizontal,
                      autoPlay: false,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: 430,
                  height: 400,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        color: Theme.of(context).colorScheme.secondary,
                        offset: const Offset(
                          0,
                          2,
                        ),
                      )
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 16, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: const Alignment(-1, 0),
                                child: ButtonsTabBar(
                                  labelStyle: TextStyle(
                                    fontFamily: 'Inter',
                                    color: Theme.of(context).colorScheme.secondary,
                                    fontSize: 16,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                                  unselectedBackgroundColor: Theme.of(context).colorScheme.surface,
                                  borderColor: Theme.of(context).colorScheme.primary,
                                  unselectedBorderColor: Theme.of(context).colorScheme.secondary,
                                  borderWidth: 2,
                                  elevation: 0,
                                  backgroundColor: Theme.of(context).colorScheme.surface,

                                  tabs: const [
                                    Tab(
                                      text: 'Subscribed',
                                    ),
                                    Tab(
                                      text: 'All',
                                    ),
                                    Tab(
                                      text: 'My events',
                                    ),
                                  ],
                                  onTap: (i) async {
                                    [
                                          () async {},
                                          () async {},
                                          () async {}
                                    ][i]();
                                  },
                                  controller: tabController,
                                ),
                              ),
                              Expanded(
                                child: TabBarView(
                                  controller: tabController,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                        ),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          children: const [
                                               EventCardWidget(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                        topLeft: Radius.circular(0),
                                        topRight: Radius.circular(0),
                                      ),
                                      child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.surface,
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12),
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(0),
                                          ),
                                        ),
                                        child: ListView(
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.vertical,
                                          children: const [
                                             EventCardWidget(),
                                             EventCardWidget(),
                                             EventCardWidget(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(),
                                  ],
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
          ),
        ),
      ),
    );
  }
}

