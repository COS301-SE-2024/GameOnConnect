
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../model/connection_M/user_model.dart' as user;
import '../connection_S/connection_service.dart';
import '../../model/events_M/evets_model.dart';
class Events{

  Future<List<Event>> fetchAllEvents() async{
    try{

      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      List<Event> all = [];
      if(currentUser!=null) {

        QuerySnapshot querySnapshot = await db.collection('events').orderBy('start_date', descending: false).get();
        for (var x in querySnapshot.docs) {
          var data = x.data() as Map<String, dynamic>;
          Event event = Event.fromMap(data,x.id);
          all.add(event);
        }

      }
          return all;
    }catch (e)
    {
      throw("Error fetching events: $e");
    }
  }

  Future<void> createEvent(String? type, DateTime? startDate, String name,
      DateTime? endDate, int gameID, bool privacy, List<String> invited) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String id = db
            .collection('events')
            .doc()
            .id;
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
        };
        db.collection("events").doc(id).set(data);
      }
    } catch (e) {
      //print("ERROR: $e");
    }
  }

  Future<List<user.AppUser>?> getConnectionsForInvite() async
  {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      List<user.AppUser> list = [];

      if (currentUser != null) {
        List<String>? connections = await ConnectionService().getConnections(
            'connections');
        for (var i in connections) {
          user.AppUser u = user.AppUser.fromMap(
              await ConnectionService().fetchFriendProfileData(i));
          list.add(u);
        }
      }
      return list;
    } catch (e) {
      throw('Error: $e');
    }
  }
  List<Event> getSubscribedEvents(List<Event>? allEvents)
  {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> subscribed=[];
    for(var i in allEvents!){
      for (var j in i.subscribed){
        if(j == currentUser?.uid)
          {
            subscribed.add(i);
            continue;
          }
      }
    }
    return subscribed;
  }

  List<Event> getMyEvents(List<Event>? allEvents)
  {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> myEvents=[];
    for(var i in allEvents!){
        if(i.creatorID == currentUser?.uid)
        {
          myEvents.add(i);
        }

    }
    return myEvents;
  }

  List<Event> getJoinedEvents(List<Event>? allEvents)
  {
    final currentUser = FirebaseAuth.instance.currentUser;
    List<Event> joinedEvents=[];
    for(var i in allEvents!){
      for (var j in i.participants) {
        if (j == currentUser?.uid) {
          joinedEvents.add(i);
        }
      }

    }
    return joinedEvents;
  }

}