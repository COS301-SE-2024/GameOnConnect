import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Events{

 /* Future<Map<String,dynamic>?> fetchEvents() async{
    // fetch all events for user
  }*/

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