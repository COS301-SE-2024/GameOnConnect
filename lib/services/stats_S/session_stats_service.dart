import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SessionStatsService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSession(int timePlayed, String gameId, String mood) async {
    try {
      final String? currentUser = _auth.currentUser?.uid;

      if (currentUser != null) {
        await _firestore.collection('game_session_stats').add({
        'game_id': gameId,
        'mood': mood,
        'time_played': timePlayed,
        'user_id': currentUser
        });
      } else {
        throw Exception("No user logged in.");
      }

    } catch (e) {
      rethrow;
    }
  }
}