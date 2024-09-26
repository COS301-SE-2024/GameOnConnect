import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsTotalTimeService {
  StatsTotalTimeService._privateConstructor();

  static final StatsTotalTimeService _instance = StatsTotalTimeService._privateConstructor();

  factory StatsTotalTimeService() {
    return _instance;
  }

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    User? user = auth.currentUser;
    return user;
  }

  Future<double> getTotalTimePlayedToday(String userID) async {
    try {
      // User? currentUser = await getCurrentUser();
      // if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: userID)
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

  Future<double> getTotalTimePlayedLastWeek(String userID) async {
    try {
      // User? currentUser = await getCurrentUser();
      // if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: userID)
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

  Future<double> getTotalTimePlayedLastMonth(String userID) async {
    try {
      // User? currentUser = await getCurrentUser();
      // if (currentUser == null) return 0.0;

      DateTime now = DateTime.now();
      DateTime startOfMonth = DateTime(now.year, now.month);

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: userID)
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

 Future<double> getPercentageTimePlayedComparedToOthers(String userID) async {
  try {
    // Fetch all game session stats from Firestore
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('game_session_stats')
        .get();

    // Map to store the total time played by each user
    Map<String, double> userTimeMap = {};

    // Populate the map with total time played by each user
    for (var doc in snapshot.docs) {
      String user = doc.data()['user_id'];
      double timePlayed = (doc.data()['time_played'] ?? 0) / (1000 * 3600); // Convert ms to hours

      // Accumulate the time played for each user
      userTimeMap[user] = (userTimeMap[user] ?? 0) + timePlayed;
    }

    // Get the total time played by the current user
    double totalTimePlayedByCurrentUser = userTimeMap[userID] ?? 0.0;

    // Sort the map values (time played) and count how many users played less than the current user
    int usersOutplayed = userTimeMap.values.where((time) => time < totalTimePlayedByCurrentUser).length;

    // Total number of users
    int totalUsers = userTimeMap.length;

    if (totalUsers == 0) return 0.0;

    // Calculate the percentage of users that the current user has outplayed
    double percentage = (usersOutplayed / totalUsers) * 100;

    return percentage;
  } catch (e) {
    return 0.0;
  }
}


   Future<double> getTotalTimePlayedAll(String userID) async {
    try {
      // User? currentUser = await getCurrentUser();
      // if (currentUser == null) return 0.0;

      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('game_session_stats')
          .where('user_id', isEqualTo: userID)
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