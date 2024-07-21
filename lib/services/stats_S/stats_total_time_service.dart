import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsTotalTimeService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<double> getTotalTimePlayedToday() async {
    User? currentUser = await getCurrentUser();
    if (currentUser == null) return 0.0;

    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid)
        .where('last_played', isGreaterThanOrEqualTo: startOfDay)
        .get();

    double totalTimePlayedToday = 0.0;
    for (var doc in snapshot.docs) {
      totalTimePlayedToday += doc.data()['time_played_last'] / 60;
    }

    return totalTimePlayedToday;
  }

  Future<double> getTotalTimePlayedLastWeek() async {
    User? currentUser = await getCurrentUser();
    if (currentUser == null) return 0.0;

    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday));

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid)
        .where('last_played', isGreaterThanOrEqualTo: startOfWeek)
        .get();

    double totalTimePlayedLastWeek = 0.0;
    for (var doc in snapshot.docs) {
      totalTimePlayedLastWeek += doc.data()['time_played_last'] / 60;
    }

    return totalTimePlayedLastWeek;
  }

  Future<double> getTotalTimePlayedLastMonth() async {
    User? currentUser = await getCurrentUser();
    if (currentUser == null) return 0.0;

    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month);

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid)
        .where('last_played', isGreaterThanOrEqualTo: startOfMonth)
        .get();

    double totalTimePlayedLastMonth = 0.0;
    for (var doc in snapshot.docs) {
      totalTimePlayedLastMonth += doc.data()['time_played_last'] / 60;
    }

    return totalTimePlayedLastMonth;
  }

  Future<double> getTotalTimePlayedLastYear() async {
    User? currentUser = await getCurrentUser();
    if (currentUser == null) return 0.0;

    DateTime now = DateTime.now();
    DateTime startOfYear = DateTime(now.year);

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('stats')
        .where('userID', isEqualTo: currentUser.uid)
        .where('last_played', isGreaterThanOrEqualTo: startOfYear)
        .get();

    double totalTimePlayedLastYear = 0.0;
    for (var doc in snapshot.docs) {
      totalTimePlayedLastYear += doc.data()['time_played_last'] / 60;
    }

    return totalTimePlayedLastYear;
  }

  Future<double> getPercentageTimePlayedComparedToOthers() async {
    User? currentUser = await getCurrentUser();
    if (currentUser == null) return 0.0;

    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection('stats')
        .get();

    double totalTimePlayedByCurrentUser = 0.0;
    double totalTimePlayedByAllUsers = 0.0;

    for (var doc in snapshot.docs) {
      double timePlayedLast = doc.data()['time_played_last'] / 60;
      if (doc.data()['userID'] == currentUser.uid) {
        totalTimePlayedByCurrentUser += timePlayedLast;
      }
      totalTimePlayedByAllUsers += timePlayedLast;
    }

    if (totalTimePlayedByAllUsers == 0.0) return 0.0;

    return (totalTimePlayedByCurrentUser / totalTimePlayedByAllUsers) * 100;
  }
}
