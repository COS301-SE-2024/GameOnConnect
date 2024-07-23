import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsMoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Map<String, int>> fetchMoodData() async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return {
        'joy': 0,
        'disgust': 0,
        'sad': 0,
        'angry': 0,
        'fear': 0,
      };
    }

    final snapshot = await _firestore
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid)
        .get();

    final moods = snapshot.docs.map((doc) => doc['mood']).toList();

    return {
      'joy': moods.where((mood) => mood == 'joy').length,
      'disgust': moods.where((mood) => mood == 'disgust').length,
      'sad': moods.where((mood) => mood == 'sad').length,
      'angry': moods.where((mood) => mood == 'angry').length,
      'fear': moods.where((mood) => mood == 'fear').length,
    };
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsAndTimestamps(String mood) async {
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      return [];
    }

    final snapshot = await _firestore
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid).where('mood', isEqualTo: mood)
        .get();

    final gameData = snapshot.docs.map((doc) {
      return {
        'gameID': doc['gameID'].toString(),
        'last_played': doc['last_played'] as Timestamp,
      };
    }).toList();

    return gameData;
  }
}