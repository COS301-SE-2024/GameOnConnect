import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../model/events_M/events_model.dart';
import '../../components/event/event_card.dart';
import '../../components/event/joined_event_card.dart';
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
  EventsService events = EventsService();
  late List<Event>? allEvents;
  late List<Event>? publicAllEvents;
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
    publicAllEvents =events.getPublicEvents(allEvents!);
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
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance .collection('events')
                        .orderBy('start_date', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if(snapshot.hasData){
                        allEvents = [];
                        for (var x in snapshot.data!.docs) {
                          var data = x.data() as Map<String, dynamic>;

                          Event event = Event.fromMap(data, x.id);
                          allEvents?.add(event);
                        }
                        getAllEvents();
                        return SingleChildScrollView(
                          child: DefaultTabController(
                            length: 3,
                            child: Wrap(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                  children: [
                                    Align(
                                      alignment:
                                          const AlignmentDirectional(-1, 0),
                                      child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(16, 5, 0, 0),
                                        child: Text(
                                          'Events:',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 12, 0, 0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 250,
                                        child: CarouselSlider.builder(
                                          itemCount: joinedEvents?.length,
                                          carouselController:
                                              CarouselController(),
                                          options: CarouselOptions(
                                            padEnds: false,
                                            initialPage: 0,
                                            viewportFraction: 0.5,
                                            disableCenter: true,
                                            enlargeCenterPage: false,
                                            enableInfiniteScroll: false,
                                            scrollDirection: Axis.horizontal,
                                            autoPlay: false,
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            Event i = joinedEvents![index];
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 16, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,

                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const Alignment(
                                                              1, 1),
                                                      child: ButtonsTabBar(
                                                        width: 110,
                                                        contentCenter: true,
                                                        labelStyle: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 16,
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,

                                                        ),
                                                        unselectedLabelStyle:
                                                            TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                        unselectedBackgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        tabs:  const [
                                                          Tab(
                                                            text: 'All',
                                                          ),
                                                          Tab(
                                                            text: 'Subscribed',
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
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              topRight: Radius
                                                                  .circular(0),
                                                            ),
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          0),
                                                                ),
                                                              ),
                                                              child: ListView
                                                                  .separated(
                                                                itemCount:
                                                                    publicAllEvents!
                                                                        .length,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  Event i =
                                                                      publicAllEvents![
                                                                          index];
                                                                  return EventCardWidget(
                                                                      e: i);
                                                                },
                                                                separatorBuilder: (context,
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
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              topRight: Radius
                                                                  .circular(0),
                                                            ),
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          0),
                                                                ),
                                                              ),
                                                              child: ListView
                                                                  .separated(
                                                                itemCount:
                                                                    subscribedEvents!
                                                                        .length,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  Event i =
                                                                      subscribedEvents![
                                                                          index];
                                                                  return EventCardWidget(
                                                                      e: i);
                                                                },
                                                                separatorBuilder: (context,
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
                                                              bottomLeft: Radius
                                                                  .circular(12),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12),
                                                              topLeft: Radius
                                                                  .circular(0),
                                                              topRight: Radius
                                                                  .circular(0),
                                                            ),
                                                            child: Container(
                                                              width: 100,
                                                              height: 100,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          0),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          0),
                                                                ),
                                                              ),
                                                              child: ListView
                                                                  .separated(
                                                                itemCount:
                                                                    myEvents!
                                                                        .length,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                scrollDirection:
                                                                    Axis.vertical,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  Event i =
                                                                      myEvents![
                                                                          index];
                                                                  return EventCardWidget(
                                                                      e: i);
                                                                },
                                                                separatorBuilder: (context,
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
                      }else{
                        return const Text('No data found');
                      }
                    }))));
  }
}
