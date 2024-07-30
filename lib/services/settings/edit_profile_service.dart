

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class editProfileService{

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
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        if (username.isNotEmpty) {
          final data = {"username.profile_name": username};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (firstname.isNotEmpty) {
          final data = {"name": firstname};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (lastName.isNotEmpty) {
          final data = {"surname": lastName};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        if (bio.isNotEmpty) {
          final data = {"bio": bio};
          await db.collection("profile_data").doc(currentUser.uid).update(
              data);
        }
        final data = {"birthday": birthday, "visibility": privacy};
        await db.collection("profile_data").doc(currentUser.uid).update(data);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously

      throw Exception('Error updating profile: $e');
      /*setState(() {
        _counter = "Error updating profile $e"; // Update counter with error message
      });*/
    }
  }

}