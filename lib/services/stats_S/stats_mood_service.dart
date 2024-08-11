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

    // final hap = moods.where((mood) => mood == 'Happy').length;
    // final dis = moods.where((mood) => mood == 'Disgusted').length;
    // final sad = moods.where((mood) => mood == 'Sad').length;
    // final ang = moods.where((mood) => mood == 'Angry').length;
    // final sca = moods.where((mood) => mood == 'Scared').length;

    // print('returned moods $moods');
    // print('returned moods: happy: $hap + disgusted: $dis + sad: $sad + angry: $ang + scared: $sca');

    //returned moods [Disgusted, Angry, Angry, Happy, Happy, No mood, Angry, No mood, Happy, Angry,
// Happy, Sad, Sad, No mood, Happy, Happy, Happy]
// returned moods: happy: 7 + disgusted: 1 + sad: 2 + angry: 4 + 0

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

    // print('Mood used in function to get time and ids: $mood');

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