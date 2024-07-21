import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardService {
  Future<Map<String, int>> getLeaderboardData() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      User? currentUser = auth.currentUser;

      // Initialize counts
      Map<String, int> counts = {
        '1st': 0,
        '2nd': 0,
        '3rd': 0,
        'Top 5': 0,
        'Top 10': 0,
      };

      // Fetch leaderboard data
      QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection('leaderboard').where('userID', isEqualTo: currentUser?.uid).get();

      for (var doc in snapshot.docs) {
        // Assuming the document has fields `placement` which can be '1st', '2nd', '3rd', 'Top 5', 'Top 10'
        String placement = doc.data()['placement'] ?? '';
        if (counts.containsKey(placement)) {
          counts[placement] = counts[placement]! + 1;
        }
      }

      return counts;
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      return {};
    }
  }
}
