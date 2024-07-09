import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Events{

 /* Future<Map<String,dynamic>?> fetchEvents() async{
    // fetch all events for user
  }*/

  Future<void> createEvent(String type,Timestamp startDate,String name,
      Timestamp endDate,int gameID)async {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final currentUser = FirebaseAuth.instance.currentUser;
      if(currentUser != null) {
        final data = <String, dynamic>{
          "eventID": db.collection('events').doc().id,
          "name": name,
          "eventType": type,
          "participants": [],
          "start_date": startDate,
          "end_date": endDate,
          "gameID": gameID,
          "conversationID" :"",
          "teams":[],
          "creatorID": currentUser.uid,
        };
        db.collection("events").doc(currentUser.uid).set(data);
      }

    }catch (e){
      //
    }
  }
}