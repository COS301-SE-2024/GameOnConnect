import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsLeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;


  Future<Map<String, int>> fetchLeaderboardData() async {
    try {
      User? currentUser = auth.currentUser;

      // Query the Firestore collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('profile_data').where('userID', isEqualTo: currentUser?.uid).get();
      
      // Initialize counters for each position
      final Map<String, int> positionCounts = {
        '1st': 0,
        '2nd': 0,
        '3rd': 0,
        'Top 5': 0,
        'Top 10': 0,
      };

      // Iterate through each document and update position counts
      for (final doc in snapshot.docs) {
        final List<dynamic> positions = doc.data()['positions'] ?? [];

        if (positions.length >= 5) {
          positionCounts['1st'] = positionCounts['1st']! + positions[0] as int;
          positionCounts['2nd'] = positionCounts['2nd']! + positions[1] as int;
          positionCounts['3rd'] = positionCounts['3rd']! + positions[2] as int;
          positionCounts['Top 5'] = positionCounts['Top 5']! + positions[3] as int;
          positionCounts['Top 10'] = positionCounts['Top 10']! + positions[4] as int;
        }
      }

      return positionCounts;
    } catch (e) {
      print("Error fetching leaderboard data: $e");
      // Return an empty map in case of error
      return {
        '1st': 0,
        '2nd': 0,
        '3rd': 0,
        'Top 5': 0,
        'Top 10': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsAndTimestamps(String position) async {    //change to get the correct positions' games
    User? currentUser = auth.currentUser;
    if (currentUser == null) {
      return [];
    }

    final snapshot = await _firestore
      .collection('leaderboard')
      .where('positions', arrayContains: currentUser.uid)
      .get();

    List<Map<String, dynamic>> eventData = [];

    for (final doc in snapshot.docs) {
      final List<dynamic> positions = doc['positions'];
      final positionIndex = _getPositionIndex(position);

      if (positions.length > positionIndex && positions[positionIndex] == currentUser.uid) {
        final eventID = doc['eventID'];
        final eventSnapshot = await _firestore
            .collection('events')
            .doc(eventID)
            .get();

        if (eventSnapshot.exists) {
          final data = eventSnapshot.data();
          if (data != null) {
            final gameID = data['gameID'];
            final startDate = data['start_date'];
            eventData.add({
              'gameID': gameID,
              'last_played': startDate
            });
          }
        }
      }
    }

    return eventData;
  }

  int _getPositionIndex(String position) {
    switch (position) {
      case '1st':
        return 0;
      case '2nd':
        return 1;
      case '3rd':
        return 2;
      case 'Top 5':
        return 3;
      case 'Top 10':
        return 4;
      default:
        throw ArgumentError('Invalid position: $position');
    }
  }

}







// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LeaderboardService {
//   Future<Map<String, int>> getLeaderboardData() async {
//     try {
//       FirebaseFirestore db = FirebaseFirestore.instance;
//       final FirebaseAuth auth = FirebaseAuth.instance;
//       User? currentUser = auth.currentUser;

//       // Initialize counts
//       Map<String, int> counts = {
//         '1st': 0,
//         '2nd': 0,
//         '3rd': 0,
//         'Top 5': 0,
//         'Top 10': 0,
//       };

//       // Fetch leaderboard data
//       QuerySnapshot<Map<String, dynamic>> snapshot = await db.collection('leaderboard').where('userID', isEqualTo: currentUser?.uid).get();

//       for (var doc in snapshot.docs) {
//         // Assuming the document has fields `placement` which can be '1st', '2nd', '3rd', 'Top 5', 'Top 10'
//         String placement = doc.data()['placement'] ?? '';
//         if (counts.containsKey(placement)) {
//           counts[placement] = counts[placement]! + 1;
//         }
//       }

//       return counts;
//     } catch (e) {
//       print("Error fetching leaderboard data: $e");
//       return {};
//     }
//   }
// }
