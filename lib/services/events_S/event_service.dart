import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../model/connection_M/user_model.dart' as user;
import '../connection_S/connection_service.dart';
import '../../model/events_M/events_model.dart';

class Events {
  Future<List<Event>> fetchAllEvents() async {
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
          if( event.privacy == false) {
            all.add(event);
          }
        }
      }
      return all;
    } catch (e) {
      throw ("Error fetching events: $e");
    }
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
      String description
      ) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final storage = FirebaseStorage.instance.ref();
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String id = db.collection('events').doc().id;

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
          "subscribed": invited,
          // image url is in bucket, under events/eventID
          "description": description,
        };

        if(!url.startsWith('assets'))
          {
            // default image not stored, there will just not be a event image with the event id
          final imageStorage = storage.child('events/$id');
          await imageStorage.putFile(File(url));
        }

        db.collection("events").doc(id).set(data);
      }
    } catch (e) {
      throw(e);
    }
  }
  
  Future<String> getEventImage(String id) async{
    final storage = FirebaseStorage.instance.ref();
    try{
      return await storage.child('events/$id').getDownloadURL();
      
    }catch (e){
      return await storage.child('events/default_image.jpg').getDownloadURL();
    }
  }

  Future<List<user.User>?> getConnectionsForInvite() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      List<user.User> list = [];

      if (currentUser != null) {
        List<String>? connections =
            await ConnectionService().getConnections('connections');
        for (var i in connections) {
          user.User u = user.User.fromMap(
              await ConnectionService().fetchFriendProfileData(i));
          list.add(u);
        }
      }
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
        if (j == currentUser?.uid) {
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
      if (i.creatorID == currentUser?.uid) {
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
        if (j == currentUser?.uid) {
          joinedEvents.add(i);
        }
      }
    }
    return joinedEvents;
  }

  Future<void> subscribeToEvent(Event subscribed) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    try{
      if(currentUser != null) {
        await db.collection('events').doc(subscribed.eventID).set({
          'subscribed': FieldValue.arrayUnion([currentUser.uid])
        }, SetOptions(merge: true));
      }
    }catch (e){
      throw("unable to subscribe to event");
  }

  }

  Future<void> joinEvent(Event joined) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final currentUser = FirebaseAuth.instance.currentUser;
    try{
      if(currentUser != null) {
        await db.collection('events').doc(joined.eventID).set({
          'participants': FieldValue.arrayUnion([currentUser.uid])
        }, SetOptions(merge: true));
      }
    }catch (e){
      throw("unable to subscribe to event");
    }
  }

  int getAmountJoined(Event e) {
    return e.participants.length;
  }
}
