

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';

class EditProfileService{

  Future<Map<String,dynamic>?> databaseAccess() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      CollectionReference profileRef = db.collection("profile_data");
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot qs = await profileRef.doc(currentUser.uid).get();
        if (qs.exists) {
          //access specific data :
          Map<String, dynamic> d = qs.data() as Map<String, dynamic>;
          return d;
        }
      }
    return null;
    } catch (e) {
    return null;
    }
  }


  
  Future<void> editProfile(String username, String firstname, String lastName,
      String bio, DateTime birthday, bool privacy) async {
    bool changed =false;
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot snapshot = await db.collection("profile_data").doc(currentUser.uid).get();
        Map<String, dynamic> currentData = snapshot.data() as Map<String, dynamic>;

        if (username.isNotEmpty && currentData["username.profile_name"] != username) {
          final data = {"username.profile_name": username};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
          changed=true;
        }
        if (firstname.isNotEmpty && currentData["name"] != firstname) {
          final data = {"name": firstname};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
          changed=true;
        }
        if (lastName.isNotEmpty && currentData["surname"] != lastName) {
          final data = {"surname": lastName};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
          changed=true;
        }
        if (bio.isNotEmpty && currentData["bio"] != bio) {
          final data = {"bio": bio};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
          changed=true;
        }
        if (currentData["birthday"] != birthday || currentData["visibility"] != privacy) {
          final data = {"birthday": birthday, "visibility": privacy};
          await db.collection("profile_data").doc(currentUser.uid).update(data);
          changed=true;
        }
      }
      if(changed)
      {
        BadgeService().unlockCustomizerBadge();
      }
        

    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }


}