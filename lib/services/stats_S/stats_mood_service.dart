import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsMoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, int>> fetchMoodData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return {
        'Happy': 0,
        'Disgusted': 0,
        'Sad': 0,
        'Angry': 0,
        'Scared': 0,
      };
    }

    final snapshot = await _firestore
        .collection('game_session_stats')
        .where('user_id', isEqualTo: currentUser.uid)
        .get();

    final moods = snapshot.docs.map((doc) => doc['mood']).toList();

    return {
      'Happy': moods.where((mood) => mood == 'Happy').length,
      'Disgusted': moods.where((mood) => mood == 'Disgusted').length,
      'Sad': moods.where((mood) => mood == 'Sad').length,
      'Angry': moods.where((mood) => mood == 'Angry').length,
      'Scared': moods.where((mood) => mood == 'Scared').length,
    };
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsAndTimestamps(String mood) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('game_session_stats')
        .where('user_id', isEqualTo: currentUser.uid).where('mood', isEqualTo: mood)
        .get();

    final gameData = snapshot.docs.map((doc) {
      return {
        'gameID': doc['game_id'].toString(),
        'last_played': doc['last_played'] as Timestamp,
      };
    }).toList();

    return gameData;
  }
}