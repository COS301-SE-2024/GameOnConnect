import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../model/events_M/evets_model.dart';
class Events{

  Future<List<Event>>? fetchAllEvents() async{
    try{

      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      List<Event> all = [];
      if(currentUser!=null) {

        QuerySnapshot querySnapshot = await db.collection('events').get();
        for (var x in querySnapshot.docs) {
          var data = x.data() as Map<String, dynamic>;
          Event event = Event.fromMap(data,x.id);
          all.add(event);
        }

      }
      print(all);
          return all;
    }catch (e)
    {
      throw("Error fetching events: $e");
    }
  }

  Future<void> createEvent(String? type,DateTime? startDate,String name,
      DateTime? endDate,int gameID, bool privacy)async {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser != null) {
        String id = db.collection('events').doc().id;
        final data = <String, dynamic>{
          "name": name,
          "eventType": type,
          "participants": [],
          "start_date": startDate,
          "end_date": endDate,
          "gameID": gameID,
          "privacy": privacy,
          "conversationID" :"",
          "teams":[],
          "creatorID": currentUser.uid,
        };
        db.collection("events").doc(id).set(data);
      }

    }catch (e){
      //print("ERROR: $e");
    }
  }
}