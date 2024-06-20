
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class Wishlist {
  //get an instance from FireStore Database
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;

  void initializeCurrentUser() {
    currentUser = auth.currentUser;
  }

  Future<List<String>> getWishlist() async {
    try {
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

  Future addToWishlist(int gameID) async {
    try {
      final data = {'wishlist': gameID};
      await db
          .collection('profile_data')
          .doc(currentUser?.uid)
          .set(data, SetOptions(merge: true));
    } catch (e) {
      return 0;
    }
  }

  Future<List<int>> removeFromWishlist(int gameID) async {
    try {
      final data = db
              .collection('profile_data')
              .doc(currentUser?.uid)
              .update({'wishlist': FieldValue.arrayRemove(gameID as List)})
          as List<int>;
      return data;
    } catch (e) {
      return [];
    }
  }
}
