import '../../../model/events_M/events_model.dart';
import '../../components/card/event_card.dart';
import '../../components/card/joined_event_card.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import '../../../services/events_S/event_service.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key});

  @override
  State<ViewEvents> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ViewEvents> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Events events = Events();
  late List<Event>? allEvents;
  late List<Event>? subscribedEvents;
  late List<Event>? myEvents;
  late List<Event>? joinedEvents;

  @override
  void initState() {
    super.initState();
    getAllEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getAllEvents() async {
    //allEvents =  events.fetchAllEvents() as List<Event>?;
    subscribedEvents= events.getSubscribedEvents(allEvents );
    myEvents = events.getMyEvents(allEvents );
    joinedEvents = events.getJoinedEvents(allEvents);

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
                top: true,
                child: StreamBuilder<List<Event>?>(
                    stream: events.fetchAllEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        allEvents = snapshot.data;
                        getAllEvents();
                        return SingleChildScrollView(child:  DefaultTabController(
                          length: 3,
                          child: Wrap( children: [Column(

                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Align(
                                alignment: const AlignmentDirectional(-1, 0),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      16, 5, 0, 0),
                                  child: Text(
                                    'Joined events:',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      letterSpacing: 0,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 12, 0, 0),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 150,
                                  child: CarouselSlider.builder(
                                    itemCount: joinedEvents?.length,
                                    carouselController: CarouselController(),
                                    options: CarouselOptions(
                                      initialPage: 0,
                                      viewportFraction: 0.5,
                                      disableCenter: true,
                                      enlargeCenterPage: true,
                                      enlargeFactor: 0.25,
                                      enableInfiniteScroll: false,
                                      scrollDirection: Axis.horizontal,
                                      autoPlay: false,
                                    ), itemBuilder: (context,index,realIndex) {
                                    Event i =
                                    joinedEvents![index];
                                    return UpcomingEventCardWidget(
                                        e: i);
                                  },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Container(
                                  width: 430,
                                  height: 400,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.surface,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 2,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        offset: const Offset(
                                          0,
                                          2,
                                        ),
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Padding(
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 16, 0, 0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(

                                            children: [
                                              Align(
                                                alignment:
                                                    const Alignment(-1, 0),
                                                child: ButtonsTabBar(
                                                  labelStyle: TextStyle(
                                                    fontFamily: 'Inter',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 16,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  unselectedLabelStyle:
                                                      TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                  unselectedBackgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
                                                  borderColor: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  unselectedBorderColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .secondary,
                                                  borderWidth: 2,
                                                  elevation: 0,
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surface,
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
                                                ),
                                              ),
                                              Expanded(
                                                child: TabBarView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                        topLeft:
                                                            Radius.circular(0),
                                                        topRight:
                                                            Radius.circular(0),
                                                      ),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0),
                                                          ),
                                                        ),
                                                        child:
                                                            ListView.separated(
                                                          itemCount:
                                                              subscribedEvents!.length,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Event i =
                                                                subscribedEvents![
                                                                    index];
                                                            return EventCardWidget(
                                                                e: i);
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                        topLeft:
                                                            Radius.circular(0),
                                                        topRight:
                                                            Radius.circular(0),
                                                      ),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0),
                                                          ),
                                                        ),
                                                        child:
                                                            ListView.separated(
                                                          itemCount:
                                                              allEvents!.length,
                                                          padding:
                                                              EdgeInsets.zero,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Event i =
                                                                allEvents![
                                                                    index];
                                                            return EventCardWidget(
                                                                e: i);
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                                      index) =>
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                        ),
                                                      ),
                                                    ),
                                                    ClipRRect(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        bottomLeft:
                                                            Radius.circular(12),
                                                        bottomRight:
                                                            Radius.circular(12),
                                                        topLeft:
                                                            Radius.circular(0),
                                                        topRight:
                                                            Radius.circular(0),
                                                      ),
                                                      child: Container(
                                                        width: 100,
                                                        height: 100,
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .surface,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    12),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    12),
                                                            topLeft:
                                                                Radius.circular(
                                                                    0),
                                                            topRight:
                                                                Radius.circular(
                                                                    0),
                                                          ),
                                                        ),
                                                        child:
                                                        ListView.separated(
                                                          itemCount:
                                                          myEvents!.length,
                                                          padding:
                                                          EdgeInsets.zero,
                                                          scrollDirection:
                                                          Axis.vertical,
                                                          itemBuilder:
                                                              (context, index) {
                                                            Event i =
                                                            myEvents![
                                                            index];
                                                            return EventCardWidget(
                                                                e: i);
                                                          },
                                                          separatorBuilder:
                                                              (context,
                                                              index) =>
                                                          const SizedBox(
                                                              height:
                                                              10),
                                                        ),
                                                        ),
                                                      ),
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
                          ],
                          ),
                        ),
                        );
                      }
                    }))));
  }
}
