import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendServices {
  //get an instance from FireStore Database
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;

  void initializeCurrentUser() {
    currentUser = auth.currentUser;
  }

  //Read friends from database
  Future<List<String>> getFriends() async {
    initializeCurrentUser();
    if (currentUser == null) {
      return []; //return an empty array
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('friends').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
      // Cast the friends array to List<String>
      List<String> friends = List<String>.from(snapshot.data()!['friends']);
      return friends;
    } else {
      return []; //return an empty array
    }

    } catch (e) {
      return []; //return an empty array
    }
  }
}
