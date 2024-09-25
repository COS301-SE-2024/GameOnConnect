import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GamesPageService {
  Future<int> getUnlockedBadgesCount() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;

      if (currentUser == null) {
        return 0;
      }

      // Querying the badges collection for the current user's data based on userID
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await db.collection('badges')
        .where('userID', isEqualTo: currentUser.uid)
        .get();
      
      // Check if any badge data exists for the user
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> badgesData = querySnapshot.docs.first;
        Map<String, dynamic>? data = badgesData.data();

        if (data == null) {
          return 0;
        }

        int unlockedCount = 0;

        // Loop through each badge and count how many are unlocked
        data.forEach((key, value) {
          if (value is Map<String, dynamic> && value['unlocked'] == true) {
            unlockedCount++;
          }
        });

        return unlockedCount;
      } else {
        return 0;
      }
    } catch (e) {
      // print("Error fetching badges: $e");
      return 0;
    }
  }
}
