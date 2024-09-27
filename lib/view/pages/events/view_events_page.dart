// ignore_for_file: undefined_hidden_name

import 'package:carousel_slider/carousel_slider.dart' as carousel_slider2;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/view/components/events/joined_event_card.dart';
import 'package:gameonconnect/view/components/home/event_invite_list.dart';
import 'package:gameonconnect/view/pages/events/create_events_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:carousel_slider/carousel_controller.dart' as carousel_slider;
import 'package:flutter/material.dart';
import '../../../model/events_M/events_model.dart';
import '../../components/events/event_card.dart';
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
  List<Event>? allEvents;
  List<Event>? publicAllEvents;
  List<Event>? subscribedEvents;
  List<Event>? myEvents;
  List<Event>? joinedEvents;

  @override
  void initState() {
    super.initState();
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
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: IconButton(
                      key: const Key('event_invites'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventInvitesList()),
                        );
                      },
                      icon: Icon(
                        Icons.mark_email_unread_outlined,
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
                        return DefaultTabController(
                          length: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text("Upcoming Events",
                                    style: TextStyle(
                                        fontSize: 20.pixelScale(context),
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.all(12),
                                child: joinedEvents!.isEmpty
                                    ? const SizedBox()
                                    : carousel_slider2.CarouselSlider.builder(
                                        itemCount: joinedEvents?.length,
                                        carouselController: carousel_slider
                                            .CarouselSliderController(),
                                        options:
                                            carousel_slider2.CarouselOptions(
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
                                            e: i,
                                          );
                                        },
                                      ),
                              ),
                              Expanded(
                                child: EventsTabBar(
                                  publicAllEvents: publicAllEvents!,
                                  subscribedEvents: subscribedEvents!,
                                  myEvents: myEvents!,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const Text('No data found');
                      }
                    })),
            floatingActionButton: FloatingActionButton(
              elevation: 0,
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

class EventsTabBar extends StatelessWidget {
  final List<Event> publicAllEvents;
  final List<Event> subscribedEvents;
  final List<Event> myEvents;

  const EventsTabBar({
    super.key,
    required this.publicAllEvents,
    required this.subscribedEvents,
    required this.myEvents,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 20),
          child: ButtonsTabBar(
            buttonMargin: const EdgeInsets.symmetric(horizontal: 15),
            width: 120,
            contentCenter: true,
            labelStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.surface,
              fontSize: 15.pixelScale(context),
              letterSpacing: 0,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: const TextStyle(color: Colors.grey),
            unselectedBackgroundColor:
                Theme.of(context).colorScheme.primaryContainer,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Subscribed'),
              Tab(text: 'My events'),
            ],
          ),
        ),
        Flexible(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ListView.separated(
                itemCount: publicAllEvents.length,
                padding: const EdgeInsets.all(12),
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                itemBuilder: (context, index) {
                  Event event = publicAllEvents[index];
                  return EventCardWidget(e: event);
                },
              ),
              ListView.separated(
                itemCount: subscribedEvents.length,
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                itemBuilder: (context, index) {
                  Event event = subscribedEvents[index];
                  return EventCardWidget(e: event);
                },
              ),
              ListView.separated(
                itemCount: myEvents.length,
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.vertical,
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.5,
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                itemBuilder: (context, index) {
                  Event event = myEvents[index];
                  return EventCardWidget(e: event);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
