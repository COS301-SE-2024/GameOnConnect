// ignore_for_file: undefined_hidden_name

import 'package:carousel_slider/carousel_slider.dart' as carousel_slider2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
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
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      key: const Key('history_icon_button'),
                      onPressed: () {
                        //Navigate to history page
                      },
                      icon: Icon(
                        Icons.history,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ]),
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
                            size: 36,
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
                                          const EdgeInsetsDirectional.all(12),
                                      child: joinedEvents!.isEmpty
                                          ? const SizedBox()
                                          : carousel_slider2.CarouselSlider
                                              .builder(
                                              itemCount: joinedEvents?.length,
                                              carouselController: carousel_slider
                                                  .CarouselSliderController(),
                                              options: carousel_slider2
                                                  .CarouselOptions(
                                                padEnds: false,
                                                initialPage: 0,
                                                viewportFraction: 0.5,
                                                disableCenter: true,
                                                enlargeCenterPage: false,
                                                enableInfiniteScroll: false,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                autoPlay: false,
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
                                    Container(
                                      width: double.infinity,
                                      height: 360,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(0, 12, 0, 20),
                                                  child: ButtonsTabBar(
                                                    buttonMargin: const EdgeInsets.symmetric(horizontal: 15),
                                                    width: 120,
                                                    contentCenter: true,
                                                    labelStyle: TextStyle(
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.light
                                                          ? Theme.of(context)
                                                              .colorScheme
                                                              .secondary
                                                          : Theme.of(context)
                                                              .colorScheme
                                                              .surface,
                                                      fontSize: 16,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    unselectedLabelStyle:
                                                        const TextStyle(
                                                            color: Colors.grey),
                                                    unselectedBackgroundColor:
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer,
                                                    elevation: 0,       
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
                                                      ListView
                                                          .builder(
                                                        itemCount:
                                                            publicAllEvents!
                                                                .length,
                                                        padding:
                                                            const EdgeInsets.all(12),
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
                                                      ),
                                                      ListView
                                                          .builder(
                                                        itemCount:
                                                            subscribedEvents!
                                                                .length,
                                                        padding:
                                                            EdgeInsets.all(12),
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
                                                        },                                                      ),
                                                      ListView.builder(
                                                        itemCount: myEvents!
                                                            .length,
                                                        padding:
                                                            const EdgeInsets.all(12),
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEvents()));
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(
                Icons.add,
                size: 30,
                color: Colors.black,
              ),
            )));
  }
}
