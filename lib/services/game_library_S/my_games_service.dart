
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class MyGamesService {

  Future<List<String>> getMyGames() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser;
      currentUser = auth.currentUser;

      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await db.collection('profile_data').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        List<String> myGames = List<String>.from(snapshot.data()!['my_games']);
        return myGames;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> addToMyGames(String gameID) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser;
      currentUser = auth.currentUser;

      List<String> oldList =await  getMyGames();
      if (!oldList.contains(gameID)) {
        oldList.add(gameID);
        final data = {'my_games': oldList};
        await db
            .collection('profile_data')
            .doc(currentUser?.uid)
            .set(data, SetOptions(merge: true));
      } 
    } catch (e) {
      //return 0;
    }
  }

  Future<void> removeFromMyGames(String gameID) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;

      db.collection('profile_data')
          .doc(auth.currentUser?.uid)
          .update({
        'my_games': FieldValue.arrayRemove([gameID])

      });
    } catch (e) {
      //return [];
    }
  }

}

