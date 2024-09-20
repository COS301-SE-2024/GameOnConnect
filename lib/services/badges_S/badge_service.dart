import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BadgeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void unlockLoyaltyBadge() async {
    try {
      DateTime currentDate = DateTime.now(); //get the current date
      final currentUser = _auth.currentUser; //get the current user

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); //get the corresponding document from firestore

        if (data != null) {
          DateTime latestDate =
              (data["loyalty_badge"]["latest_date"] as Timestamp).toDate();

          ///get the latest date from the document
          int count =
              data["loyalty_badge"]["count"]; //get the count from the document

          // check if the function has already run today
          bool isSameDay = latestDate.day == currentDate.day &&
              latestDate.month == currentDate.month &&
              latestDate.year == currentDate.year;

          if (isSameDay) { //if it is the same day, then don't run again
            return;
          }

          bool isYesterday = latestDate.day == currentDate.day - 1 && latestDate.month == currentDate.month && latestDate.year == currentDate.year;

          if (isYesterday) {
            //if the latest date was yesterday then increment the count
            count = count + 1;
          } else {
            count = 0;
          }

          if (count >= 10) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //if the count is >= 10 then update the document with the unlocked status
              "loyalty_badge": {
                "count": count,
                "latest_date": currentDate,
                "date_unlocked": currentDate,
                "unlocked": true,
              }
            });
          } else {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //update the count and latest date in the document
              "loyalty_badge": {
                "count": count,
                "latest_date": currentDate,
                "date_unlocked": null,
                "unlocked": false,
              }
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock loyalty badge: $e");
    }
  }

void unlockCollectorBadge(bool add) async {
    try {
      final currentUser = _auth.currentUser; 

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); 

        if (data != null) {
          int count = 
              data["collector_badge"]["count"]; //get the count from the document//CHANGE

          if(add){
            count++;
          }
          else{
            count--;
          }

          if (count== 10) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //if the count is >= 10 then update the document with the unlocked status
              "collector_badge": {//CHANGE
                "count": count,
                "date_unlocked": DateTime.now(),
                "unlocked": true,
              }
            });
          } else if (count<10) {
            await _firestore.collection("badges").doc(currentUser.uid).update({
              //update the count and latest date in the document
              "collector_badge": { //CHANGE
                "count": count,
                "date_unlocked": null,
                "unlocked": false,
              }
            });
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock collector badge: $e"); //CHANGE
    }
  }

  void unlockAchieverBadge() async {
    try {
      final currentUser = _auth.currentUser; 

      if (currentUser != null) {
        DocumentSnapshot<Map<String, dynamic>> doc =
            await _firestore.collection("badges").doc(currentUser.uid).get();
        Map<String, dynamic>? data =
            doc.data(); 

        if (data != null) {
          
          bool unlocked = 
              data["achiever_badge"]["unlocked"]; 

          if(unlocked==false){
            await _firestore.collection("badges").doc(currentUser.uid).update({
              "achiever_badge": {
                "date_unlocked": DateTime.now(),
                "unlocked": true,
              }
            });
          }
          else{
          }
        }
      }
    } catch (e) {
      throw Exception("Failed to unlock achiever badge: $e"); //CHANGE
    }
  }

}
