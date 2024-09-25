// ignore_for_file: undefined_hidden_name

import 'package:carousel_slider/carousel_slider.dart' as carousel_slider2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/view/pages/events/create_events_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;
import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../components/events/event_card.dart';
import '../../components/events/joined_event_card.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import '../../../services/events_S/event_service.dart';

class ViewEvents extends StatefulWidget {
  const ViewEvents({super.key});

  @override
  State<ViewEvents> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<ViewEvents> {
  final BadgeService _badgeService = BadgeService();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  EventsService events = EventsService();
  late List<Event>? allEvents;
  late List<Event>? publicAllEvents;
  late List<Event>? subscribedEvents;
  late List<Event>? myEvents;
  late List<Event>? joinedEvents;
  late List<String> creators;

  @override
  void initState() {
    super.initState();
    getAllEvents();
    _badgeService.unlockNightOwlBadge(DateTime.now());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getAllEvents() async {
    publicAllEvents = events.getPublicEvents(allEvents!);
    subscribedEvents = events.getSubscribedEvents(allEvents);
    myEvents = events.getMyEvents(allEvents);
    joinedEvents = events.getJoinedEvents(allEvents);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                automaticallyImplyLeading: false,
                title: Text(
                  'Events',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontSize: 32.pixelScale(context),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
               ),
            key: scaffoldKey,
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
                top: true,
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('events')
                        .orderBy('start_date', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: LoadingAnimationWidget.halfTriangleDot(
                            color: Theme.of(context).colorScheme.primary,
                            size: 36.pixelScale(context),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding:
                                           EdgeInsetsDirectional.fromSTEB(
                                              24.pixelScale(context), 13.pixelScale(context), 0, 0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 230.pixelScale(context),
                                        child: joinedEvents!.isEmpty? const Align(alignment: Alignment(0, 0), child: Text("You currently have no upcoming events")):
                                         carousel_slider2.CarouselSlider.builder(
                                          itemCount: joinedEvents?.length,
                                          carouselController:
                                              carousel_slider.CarouselSliderController(),
                                          options: carousel_slider2.CarouselOptions(
                                            padEnds: false,
                                            initialPage: 0,
                                            viewportFraction: 0.5,
                                            disableCenter: true,
                                            enlargeCenterPage: false,
                                            enableInfiniteScroll: false,
                                            scrollDirection: Axis.horizontal,
                                            autoPlay: false,
                                            height: 250.pixelScale(context),
                                          ),
                                          itemBuilder:
                                              (context, index, realIndex) {
                                            Event i = joinedEvents![index];
                                            return UpcomingEventCardWidget(
                                              e: i,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                           EdgeInsetsDirectional.fromSTEB(
                                              12.pixelScale(context), 42.56.pixelScale(context), 12.pixelScale(context), 12.pixelScale(context)),
                                      child: Container(
                                        width: double.infinity,
                                        height: 360.pixelScale(context),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                          borderRadius:
                                              BorderRadius.circular(10.pixelScale(context)),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsetsDirectional
                                              .fromSTEB(12.pixelScale(context), 0, 0, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          const Alignment(0, 1),
                                                      child: ButtonsTabBar(
                                                        width: 101.pixelScale(context),
                                                        contentCenter: true,
                                                        labelStyle: TextStyle(
                                                          fontFamily: 'Inter',
                                                          color: Theme.of(context)
                                                                      .brightness ==
                                                                  Brightness
                                                                      .light
                                                              ? Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .secondary
                                                              : Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .surface,
                                                          fontSize: 16.pixelScale(context),
                                                          letterSpacing: 0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                        unselectedLabelStyle: TextStyle(
                                                            color: Theme.of(
                                                                            context)
                                                                        .brightness ==
                                                                    Brightness
                                                                        .light
                                                                ? Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary
                                                                : Colors.white),
                                                        unselectedBackgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primaryContainer,
                                                        elevation: 0,
                                                        buttonMargin:
                                                             EdgeInsets
                                                                .fromLTRB(
                                                                0, 0, 13.pixelScale(context), 10.pixelScale(context)),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .primary,
                                                        tabs: const [
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
                                                                BorderRadius
                                                                    .circular(
                                                                        10.pixelScale(context)),
                                                            child: Container(
                                                              width: 100.pixelScale(context),
                                                              height: 30.pixelScale(context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10.pixelScale(context)),
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
                                                                    e: i,
                                                                  );
                                                                },
                                                                separatorBuilder:
                                                                    (context,
                                                                            index) =>
                                                                        const SizedBox(),
                                                              ),
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                 BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(12.pixelScale(context)),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                              topLeft: const Radius
                                                                  .circular(0),
                                                              topRight: const Radius
                                                                  .circular(0),
                                                            ),
                                                            child: Container(
                                                              width: 100.pixelScale(context),
                                                              height: 100.pixelScale(context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                     BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                                  topLeft: const Radius
                                                                      .circular(
                                                                          0),
                                                                  topRight: const Radius
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
                                                                    e: i,
                                                                  );
                                                                },
                                                                separatorBuilder: (context,
                                                                        index) =>
                                                                     SizedBox(
                                                                        height:
                                                                            10.pixelScale(context)),
                                                              ),
                                                            ),
                                                          ),
                                                          ClipRRect(
                                                            borderRadius:
                                                                 BorderRadius
                                                                    .only(
                                                              bottomLeft: Radius
                                                                  .circular(12.pixelScale(context)),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                              topLeft: const Radius
                                                                  .circular(0),
                                                              topRight: const Radius
                                                                  .circular(0),
                                                            ),
                                                            child: Container(
                                                              width: 100.pixelScale(context),
                                                              height: 100.pixelScale(context),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .surface,
                                                                borderRadius:
                                                                     BorderRadius
                                                                        .only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          12.pixelScale(context)),
                                                                  topLeft: const Radius
                                                                      .circular(
                                                                          0),
                                                                  topRight: const Radius
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
                                                                    e: i,
                                                                  );
                                                                },
                                                                separatorBuilder: (context,
                                                                        index) =>
                                                                     SizedBox(
                                                                        height:
                                                                            10.pixelScale(context)),
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
                      } else {
                        return const Text('No data found');
                      }
                    })),
    floatingActionButton: FloatingActionButton(
      
      onPressed:(){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => const CreateEvents()));
    },
      backgroundColor: Theme.of(context).colorScheme.primary,
    child:  Icon(Icons.add,size: 30.pixelScale(context),color: Colors.black,),
    )
    ));
  }
}
