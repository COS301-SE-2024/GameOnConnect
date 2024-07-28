import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class StatsGenresService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, double>> getGenrePlayTime({DateTime? startDate}) async {
    try {
      User? currentUser = _auth.currentUser;

      if (currentUser == null) {
        return {};
      }

      final snapshot;

      if (startDate != null) {
        snapshot = await _db.collection('game_session_stats')
            .where('user_id', isEqualTo: currentUser.uid)
            .where('last_played', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .get();
      } else {
         snapshot = await _db.collection('game_session_stats')
            .where('user_id', isEqualTo: currentUser.uid)
            .get();
      }

      Map<String, double> genrePlayTime = {};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final genres = List<Map<String, dynamic>>.from(data['genres'] ?? []);
        // final timePlayed = data['time_played']?.toDouble() ?? 0.0;

        for (var genre in genres) {
          final genreName = genre['name'] ?? 'Unknown Genre';
          
          if (genrePlayTime.containsKey(genreName)) {
            genrePlayTime[genreName] = genrePlayTime[genreName]! + 1; //timePlayed;
          } else {
            genrePlayTime[genreName] = 1;  //timePlayed;
          }
        }
      }

      return genrePlayTime;
    } catch (e) {
      // Handle errors
      // print('Error fetching genre play time: $e');
      return {};
    }
  }
}





















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class StatsGenresService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<Map<String, int>> getGenresPlayed() async {
//     try {
//       User? currentUser = _auth.currentUser;

//       if (currentUser == null) {
//         print("User not logged in");
//         return {};
//       }

//       QuerySnapshot<Map<String, dynamic>> snapshot = await _db
//           .collection('stats')
//           .where('userID', isEqualTo: currentUser.uid)
//           .get();

//       if (snapshot.docs.isEmpty) {
//         print("No stats found for user");
//         return {};
//       }

//       Map<String, int> genreCount = {};

//       for (var doc in snapshot.docs) {
//         List<String> genres = List<String>.from(doc.data()['genre'] ?? []);
//         for (var genre in genres) {
//           if (genreCount.containsKey(genre)) {
//             genreCount[genre] = genreCount[genre]! + 1;
//           } else {
//             genreCount[genre] = 1;
//           }
//         }
//       }

//       print("Genre count: $genreCount");
//       return genreCount;
//     } catch (e) {
//       print("Error fetching genres played: $e");
//       return {};
//     }
//   }

//   double getNormalizedWidth(int count, int maxCount, double screenWidth) {
//     double maxWidth = screenWidth - 20 - 30;  //10 pixel padding on each side + genre length
//     return (count / maxCount) * maxWidth; 
//   }

//   // Future<Map<String, double>> getNormalizedGenresPlayed() async {
//   //   Map<String, int> genreCounts = await getGenresPlayed();
//   //   if (genreCounts.isEmpty) return {};

//   //   int maxCount = genreCounts.values.reduce((a, b) => a > b ? a : b);
//   //   Map<String, double> normalizedCounts = genreCounts.map(
//   //     (genre, count) => MapEntry(genre, count / maxCount),
//   //   );

//   //   return normalizedCounts;
//   // }

//   Future<void> addGameGenres(String gameID, List<String> genres) async {
//     try {
//       User? currentUser = _auth.currentUser;

//       if (currentUser == null) {
//         print("User not logged in");
//         return;
//       }

//       DocumentReference userStatsRef = _db.collection('stats').doc('${currentUser.uid}_$gameID');

//       await userStatsRef.set({
//         'userID': currentUser.uid,
//         'gameID': gameID,
//         'genre': genres
//       }, SetOptions(merge: true));

//       print("Added genres for game $gameID: $genres");
//     } catch (e) {
//       print("Error adding game genres: $e");
//     }
//   }
// }
