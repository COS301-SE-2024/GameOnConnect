import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsTotalTimeService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    User? user = auth.currentUser;
    return user;
  }

  Future<double> getTotalTimePlayedToday() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfDay)
          .get();

      double totalTimePlayedToday = 0.0;
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        totalTimePlayedToday += timePlayed;
      }

      return totalTimePlayedToday;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getTotalTimePlayedLastWeek() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfWeek)
          .get();

      double totalTimePlayedLastWeek = 0.0;
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        totalTimePlayedLastWeek += timePlayed;
      }

      return totalTimePlayedLastWeek;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getTotalTimePlayedLastMonth() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month);

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfMonth)
          .get();

      double totalTimePlayedLastMonth = 0.0;
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        totalTimePlayedLastMonth += timePlayed;
      }

      return totalTimePlayedLastMonth;
    } catch (e) {
      return 0.0;
    }
  }

  Future<double> getPercentageTimePlayedComparedToOthers() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .get();

      double totalTimePlayedByCurrentUser = 0.0;
      double totalTimePlayedByAllUsers = 0.0;

      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        if (doc.data()['user_id'] == currentUser.uid) {
          totalTimePlayedByCurrentUser += timePlayed;
        }
        totalTimePlayedByAllUsers += timePlayed;
      }

      if (totalTimePlayedByAllUsers == 0.0) return 0.0;

      double percentage = 100 - ((totalTimePlayedByCurrentUser / totalTimePlayedByAllUsers) * 100);
      return percentage;
    } catch (e) {
      return 0.0;
    }
  }

   Future<double> getTotalTimePlayedAll() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .get();

      double totalTimePlayedLastYear = 0.0;
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        totalTimePlayedLastYear += timePlayed;
      }

      return totalTimePlayedLastYear;
    } catch (e) {
      return 0.0;
    }
  }
}