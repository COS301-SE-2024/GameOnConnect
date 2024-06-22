
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Wishlist {


  Future<List<String>> getCurrentlyPlaying() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser;
      currentUser = auth.currentUser;

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection('profile_data').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        List<String> wishlist = List<String>.from(snapshot.data()!['wishlist']);
        return wishlist;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addToCurrentlyPlaying(String gameID) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser;
      currentUser = auth.currentUser;

      List<String> oldList =await  getCurrentlyPlaying();
      oldList.add(gameID);
      final data = {'wishlist': oldList};
      await db
          .collection('profile_data')
          .doc(currentUser?.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      //return 0;
    }
  }

  Future<void> removeFromCurrentlyPlaying(String gameID) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;

      db.collection('profile_data')
          .doc(auth.currentUser?.uid)
          .update({
        'wishlist': FieldValue.arrayRemove([gameID])

      });
    } catch (e) {
      //return [];
    }
  }
}
