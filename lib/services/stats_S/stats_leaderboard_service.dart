import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart'; // Add this line for logging

// final logger = Logger(); // Initialize the logger

class StatsLeaderboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth auth = FirebaseAuth.instance;


  Future<Map<String, int>> fetchLeaderboardData(String userID) async {
    try {
      // User? currentUser = auth.currentUser;

      // Query the Firestore collection
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('profile_data').where('userID', isEqualTo: userID).get();
      
      // Initialize counters for each position
      final Map<String, int> positionCounts = {
        '1st': 0,
        '2nd': 0,
        '3rd': 0,
        'Top 5': 0,
        'Top 10': 0,
      };

      // Iterate through each document and update position counts
      for (final doc in snapshot.docs) {
        final List<dynamic> positions = doc.data()['positions'] ?? [];

        if (positions.length >= 5) {
          positionCounts['1st'] = positionCounts['1st']! + positions[0] as int;
          positionCounts['2nd'] = positionCounts['2nd']! + positions[1] as int;
          positionCounts['3rd'] = positionCounts['3rd']! + positions[2] as int;
          positionCounts['Top 5'] = positionCounts['Top 5']! + positions[3] as int;
          positionCounts['Top 10'] = positionCounts['Top 10']! + positions[4] as int;
        }
      }

      return positionCounts;
    } catch (e) {
      // print("Error fetching leaderboard data: $e");
      // Return an empty map in case of error
      return {
        '1st': 0,
        '2nd': 0,
        '3rd': 0,
        'Top 5': 0,
        'Top 10': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> fetchGameIDsAndTimestamps(String userID, String position) async {    //change to get the correct positions' games
    // User? currentUser = auth.currentUser;
    if (userID == "") {
      return [];
    }

    final snapshot = await _firestore
      .collection('leaderboard')
      .where('positions', arrayContains: userID)
      .get();

    // logger.i('Query snapshot size: ${snapshot.docs.length}');
    // Check if data is available
      if (snapshot.docs.isEmpty) {
        throw Exception('No data found for the selected position');
      }

    List<Map<String, dynamic>> eventData = [];

    for (final doc in snapshot.docs) {
      final List<dynamic> positions = doc['positions'];
      bool isUserInPosition = false;

      switch (position) {
        case '1st':
          isUserInPosition = positions.isNotEmpty && positions[0] == userID;
          break;
        case '2nd':
          isUserInPosition = positions.length > 1 && positions[1] == userID;
          break;
        case '3rd':
          isUserInPosition = positions.length > 2 && positions[2] == userID;
          break;
        case 'Top 5':
          isUserInPosition = positions.length > 4 && (positions.sublist(0, 5).contains(userID));
          break;
        case 'Top 10':
          isUserInPosition = positions.length > 9 && (positions.sublist(0, 10).contains(userID));
          break;
      }

      // logger.i('Fetching data for position: $position');

      if (isUserInPosition) {
        // Check if user's position matches the specified position
        int userIndex = positions.indexOf(userID);
        if (_getPositionString(userIndex) == position) {
          final eventID = doc['eventID'];
          final eventSnapshot = await _firestore
              .collection('events')
              .doc(eventID)
              .get();
          
          // logger.i('Query snapshot size: ${eventSnapshot}');

          if (eventSnapshot.exists) {
            final data = eventSnapshot.data();
            if (data != null) {
              final gameID = data['gameID'];
              final startDate = data['start_date'];
              eventData.add({
                'gameID': gameID,
                'last_played': startDate
              });
              // logger.i('Query snapshot size: ${gameID}');
              // logger.i('Query snapshot size: ${startDate}');
            }
          }
          // logger.i('Query snapshot size: ${eventData}');
        }
      }
    }

    return eventData;
  }

  String _getPositionString(int index) {
    switch (index) {
      case 0:
        return '1st';
      case 1:
        return '2nd';
      case 2:
        return '3rd';
      case 3:
        return 'Top 5';
      case 4:
        return 'Top 5';
      case 5:
        return 'Top 10';
      case 6:
        return 'Top 10';
      case 7:
        return 'Top 10';
      case 8:
        return 'Top 10';
      case 9:
        return 'Top 10';
      default:
        return '';
    }
  }

}