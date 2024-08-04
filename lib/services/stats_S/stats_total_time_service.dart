import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsTotalTimeService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    // print("Fetching current user...");
    User? user = auth.currentUser;
    // print("Current user: ${user?.uid}");
    return user;
  }

  Future<double> getTotalTimePlayedToday() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      // print("Fetching data for today: $startOfDay to $now");

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfDay)
          .get();

      double totalTimePlayedToday = 0.0;
      // print("Documents found for today: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        // print("Adding time: $timePlayed hours from doc: ${doc.id}");
        totalTimePlayedToday += timePlayed;
      }

      // print("Total time played today: $totalTimePlayedToday hours");
      return totalTimePlayedToday;
    } catch (e) {
      // print("Error fetching today's data: $e");
      return 0.0;
    }
  }

  Future<double> getTotalTimePlayedLastWeek() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));
      // print("Fetching data for last week: $startOfWeek to $now");

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfWeek)
          .get();

      double totalTimePlayedLastWeek = 0.0;
      // print("Documents found for last week: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        // print("Adding time: $timePlayed hours from doc: ${doc.id}");
        totalTimePlayedLastWeek += timePlayed;
      }

      // print("Total time played last week: $totalTimePlayedLastWeek hours");
      return totalTimePlayedLastWeek;
    } catch (e) {
      // print("Error fetching last week's data: $e");
      return 0.0;
    }
  }

  Future<double> getTotalTimePlayedLastMonth() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month);
      // print("Fetching data for last month: $startOfMonth to $now");

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .where('last_played', isGreaterThanOrEqualTo: startOfMonth)
          .get();

      double totalTimePlayedLastMonth = 0.0;
      // print("Documents found for last month: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        // print("Adding time: $timePlayed hours from doc: ${doc.id}");
        totalTimePlayedLastMonth += timePlayed;
      }

      // print("Total time played last month: $totalTimePlayedLastMonth hours");
      return totalTimePlayedLastMonth;
    } catch (e) {
      // print("Error fetching last month's data: $e");
      return 0.0;
    }
  }

  Future<double> getTotalTimePlayedAll() async {
    try {
      User? currentUser = await getCurrentUser();
      if (currentUser == null) return 0.0;

      // DateTime now = DateTime.now();
      // DateTime startOfYear = DateTime(now.year);
      // print("Fetching data for last year: $startOfYear to $now");

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: currentUser.uid)
          .get();

      double totalTimePlayedLastYear = 0.0;
      // print("Documents found for last year: ${snapshot.docs.length}");
      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        // print("Adding time: $timePlayed hours from doc: ${doc.id}");
        totalTimePlayedLastYear += timePlayed;
      }

      // print("Total time played last year: $totalTimePlayedLastYear hours");
      return totalTimePlayedLastYear;
    } catch (e) {
      // print("Error fetching last year's data: $e");
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
      // print("Documents found for all users: ${snapshot.docs.length}");

      for (var doc in snapshot.docs) {
        double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600);
        if (doc.data()['user_id'] == currentUser.uid) {
          // print("Adding time to current user: $timePlayed hours from doc: ${doc.id}");
          totalTimePlayedByCurrentUser += timePlayed;
        }
        // print("Adding time to all users: $timePlayed hours from doc: ${doc.id}");
        totalTimePlayedByAllUsers += timePlayed;
      }

      if (totalTimePlayedByAllUsers == 0.0) return 0.0;

      double percentage = 100 - ((totalTimePlayedByCurrentUser / totalTimePlayedByAllUsers) * 100);
      // print("Percentage time played compared to others: $percentage%");
      return percentage;
    } catch (e) {
      // print("Error fetching percentage time played compared to others: $e");
      return 0.0;
    }
  }
}