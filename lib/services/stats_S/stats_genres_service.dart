import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

class StatsGenresService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, double>> getGenrePlayTime({required String userID, DateTime? startDate}) async {
    try {
      // User? currentUser = _auth.currentUser;

      if (userID == "") {
        return {};
      }

      final QuerySnapshot<Map<String, dynamic>> snapshot;

      if (startDate != null) {
        snapshot = await _db.collection('game_session_stats')
            .where('user_id', isEqualTo: userID)
            .where('last_played', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
            .get();
      } else {
         snapshot = await _db.collection('game_session_stats')
            .where('user_id', isEqualTo: userID)
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