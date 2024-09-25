import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/services/game_library_S/game_service.dart';
import 'package:gameonconnect/services/profile_S/profile_service.dart';
import '../../../model/connection_M/user_model.dart' as user;
import '../connection_S/connection_service.dart';
import '../../model/events_M/events_model.dart';
import '../../model/game_library_M/game_details_model.dart';
import '../../services/game_library_S/my_games_service.dart';

class EventsService {
  Stream<List<Event>> fetchAllEvents() async* {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      List<Event> all = [];
      if (currentUser != null) {
        QuerySnapshot querySnapshot = await db
            .collection('events')
            .orderBy('start_date', descending: false)
            .get();
        for (var x in querySnapshot.docs) {
          var data = x.data() as Map<String, dynamic>;
          Event event = Event.fromMap(data, x.id);
          if (!DateTime.now().isAfter(event.endDate)) {
            if (event.privacy == false) {
              all.add(event);
            }
          }
        }
      }
      yield all;
    } catch (e) {
      throw ("Error fetching events: $e");
    }
  }

  List<Event> getPublicEvents(List<Event> e) {
    List<Event> all = [];
    for (var x in e) {
        if (x.privacy == true && !DateTime.now().isAfter(x.endDate)) {
        all.add(x);
      }
    }
    return all;
  }

  Future<Event?> getEvent(String id) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    Event? e;
    DocumentSnapshot doc = await db.collection('events').doc(id).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      e = Event.fromMap(data, id);
    }
    return e;
  }

  Future<List<Map<String, dynamic>>> getInvitedEvents() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    List<Map<String, dynamic>> invitedEvents = [];
    final currentUser = FirebaseAuth.instance.currentUser;

    QuerySnapshot snapshot = await db.collection('events').get();

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      if (data['invited'] != null && data['invited'] is List) {
        List<dynamic> array = data['invited'];

        if (array.contains(currentUser!.uid)) {
          invitedEvents.add(data);
        }
      }
    }

    return invitedEvents;
  }

  Future<void> createEvent(
      String? type,
      DateTime? startDate,
      String name,
      DateTime? endDate,
      int gameID,
      bool privacy,
      List<String> invited,
      String url,
      String description) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance.ref();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String id = db.collection('events').doc().id;
        final String creatorName = await ProfileService().getProfileName(currentUser.uid);

        final data = <String, dynamic>{
          "name": name,
          "eventType": type,
          "participants": [],
          "start_date": startDate,
          "end_date": endDate,
          "gameID": gameID,
          "privacy": privacy,
          "conversationID": "",
          "teams": [],
          "creatorID": currentUser.uid,
          "invited": invited,
          "subscribed": [],
          // image url is in bucket, under events/eventID
          "description": description,
          "creatorName": creatorName,
        };

        if (!url.startsWith('assets')) {
          // default image not stored, there will just not be a event image with the event id
          final imageStorage = storage.child('events/$id');
          await imageStorage.putFile(File(url));
        }

        db.collection("events").doc(id).set(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getEventImage(String id) async {
    final storage = FirebaseStorage.instance.ref();
    try {
      return await storage.child('events/$id').getDownloadURL();
    } catch (e) {
      return await storage.child('events/default_image.jpg').getDownloadURL();
    }
  }

  Future<void> declineEventInvitation(Event event) async {
    final DocumentReference docRef =
        FirebaseFirestore.instance.collection('events').doc(event.eventID);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await docRef.update({
          'invited': FieldValue.arrayRemove([currentUser.uid])
        });
      }
    } catch (e) {
      throw ('Error: $e');
    }
  }

  Future<List<user.AppUser>?> getConnectionsForInvite() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      List<user.AppUser> list = [];

      if (currentUser != null) {
        List<String>? connections =
            await ConnectionService().getConnections('connections');
        for (var i in connections) {
          user.AppUser u = user.AppUser.fromMap(
              await ConnectionService().fetchFriendProfileData(i));
          list.add(u);
        }
      }

      list.sort((a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()));
      return list;
    } catch (e) {
      throw ('Error: $e');
    }
  }

  List<Event> getSubscribedEvents(List<Event>? allEvents) {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> subscribed = [];
    for (var i in allEvents!) {
      for (var j in i.subscribed) {
        if (j == currentUser?.uid&& !DateTime.now().isAfter(i.endDate)) {
          subscribed.add(i);
          continue;
        }
      }
    }
    return subscribed;
  }

  List<Event> getMyEvents(List<Event>? allEvents) {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> myEvents = [];
    for (var i in allEvents!) {
      if (i.creatorID == currentUser?.uid&& !DateTime.now().isAfter(i.endDate)) {
        myEvents.add(i);
      }
    }
    return myEvents;
  }

  List<Event> getJoinedEvents(List<Event>? allEvents) {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> joinedEvents = [];
    for (var i in allEvents!) {
      for (var j in i.participants) {
        if (j == currentUser?.uid&& !DateTime.now().isAfter(i.endDate)) {
          joinedEvents.add(i);
        }
      }
    }
    return joinedEvents;
  }

  Future<void> subscribeToEvent(Event subscribed) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser != null) {
        await db.collection('events').doc(subscribed.eventID).update({
          'subscribed': FieldValue.arrayUnion([currentUser.uid])
        });
      }
    } catch (e) {
      throw ("unable to subscribe to event");
    }
  }

  Future<void> unsubscribeToEvent(Event subscribed) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      if (currentUser != null) {
        subscribed.subscribed.remove(currentUser.uid);
        await db.collection('events').doc(subscribed.eventID).update(
          {
            'subscribed': FieldValue.arrayRemove([currentUser.uid])
          },
        );
      }
    } catch (e) {
      throw ("unable to unsubscribe from event");
    }
  }

  bool isSubscribed(Event e) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      for (var i in e.subscribed) {
        if (i == currentUser.uid) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  bool isJoined(Event e) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      for (var i in e.participants) {
        if (i == currentUser.uid) {
          return true;
        }
      }
      return false;
    }
    return false;
  }

  bool isCreator(Event e) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.uid == e.creatorID) {
      return true;
    }
    return false;
  }

  Future<void> joinEvent(Event joined) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;

    try {
      if (currentUser != null) {
        await db.collection('events').doc(joined.eventID).set({
          'participants': FieldValue.arrayUnion([currentUser.uid])
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw ("unable to subscribe to event");
    }
  }

  int getAmountJoined(Event e) {
    return e.participants.length;
  }


  Future<List<GameDetails>> getMyGames() async{
    List<String> gameIds = await MyGamesService().getMyGames();
    List<GameDetails> gameDetails = [];
    for (var i in gameIds) {
      GameDetails game = await GameService().fetchGameDetails(i);
      gameDetails.add(game);
    }
    return gameDetails;
  }

  Future<void> editEvent(
      bool imageChanged,
      String type,
      DateTime? startDate,
      String name,
      DateTime? endDate,
      int gameID,
      bool privacy,
      List<String> invited,
      String url,
      String description, String eventId) async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final storage = FirebaseStorage.instance.ref();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        final data = <String, dynamic>{
          "name": name,
          "eventType": type,
          "participants": [],
          "start_date": startDate,
          "end_date": endDate,
          "gameID": gameID,
          "privacy": privacy,
          "conversationID": "",
          "teams": [],
          "creatorID": currentUser.uid,
          "invited": invited,
          "subscribed": [],
          // image url is in bucket, under events/eventID
          "description": description,
        };

        if (imageChanged && !url.startsWith('assets')) {
          // default image not stored, there will just not be a event image with the event id
          final imageStorage = storage.child('events/$eventId');
          await imageStorage.putFile(File(url));
        }

        db.collection("events").doc(eventId).set(data, SetOptions(merge: true));
      }
    }
  }

  String myUid(){
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return currentUser.uid;
    }
    return "";
  }


}
