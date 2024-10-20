import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';

class ProfileService {
  ProfileService._privateConstructor();

  static final ProfileService _instance = ProfileService._privateConstructor();

  factory ProfileService() {
    return _instance;
  }

  int mygGamesLength = 0;

  Future<Profile?> fetchProfileData([String? uid = 'CurrentUser']) async {
    if (uid == 'CurrentUser') {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return null; //return an empty array
      }
      uid = currentUser.uid;
    }
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      if (uid != null && uid != "") {
        DocumentSnapshot doc =
            await db.collection("profile_data").doc(uid).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Map<String, dynamic> userInfo =
              data['username'] as Map<String, dynamic>;
          String name = userInfo['profile_name'] ?? 'username';
          int uniqueNum = userInfo['unique_num'] ?? '';

          // Get number of connections
          List<String> connections =
              await ConnectionService().getConnections("connections", uid);
          int connectionsCount = connections.length;

          // Fetch banner and profile picture URLs
          StorageService storageService = StorageService();
          String bannerUrl = await storageService.getBannerUrl(uid);
          String profilePictureUrl =
              await storageService.getProfilePictureUrl(uid);

          // Fetch recent activities (assuming it's an array of references)
          final recentActivitiesRefs =
              List<DocumentReference>.from(data['recent_activity'] ?? []);
          final recentActivities =
              await fetchRecentActivities(recentActivitiesRefs);

          final mygames = List<String>.from(data['my_games'] ?? []);
          mygGamesLength = mygames.length;
          //print("my games ids: $mygames");
          final myGamesList = await getMyGame(mygames, uid);
          //print("my game stats: $myGamesList");

          return Profile(
            banner: bannerUrl,
            bio: data['bio'] ?? '',
            profilePicture: profilePictureUrl,
            userName: data['username'] as Map<String, dynamic>,
            profileName: name,
            uniqueNumber: uniqueNum,
            currentlyPlaying: data['currently_playing'] ?? '',
            myGames: myGamesList,
            wantToPlay: List<String>.from(data['want_to_play'] ?? []),
            numberOfconnections: connectionsCount,
            recentActivities: recentActivities,
            name: data['name'] ?? '',
            surname: data['surname'] ?? '',
            theme: data['theme'] ?? '',
            userID: uid,
            visibility: data['visibility'] ?? true,
            ageRatings: List<String>.from(data['age_rating_tags'] ?? []),
            birthday: data['birthday'],
            genreInterests:
                List<String>.from(data['genre_interests_tags'] ?? []),
            socialInterests:
                List<String>.from(data['social_interests_tags'] ?? []),
            positions: List<int>.from(data['positions'] ?? []),
          );
        } else {
          //print('Document not found');
        }
      } else {
        //print('User not found');
      }
    } catch (e) {
      //print('Error fetching profile data: $e');
    }
    return null;
  }

  Future<String> getProfileName(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    const int maxRetries = 5;
    const Duration retryDelay = Duration(milliseconds: 500);

    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        DocumentSnapshot profileSnapshot = await db
            .collection("profile_data")
            .doc(userId)
            .get(); //get the document
        Map<String, dynamic> data = profileSnapshot.data()
            as Map<String, dynamic>; //map the overall data
        Map<String, dynamic> userInfo =
            data['username'] as Map<String, dynamic>; //map the username data
        // Return profile name if exists otherwise give an empty string
        if (profileSnapshot.exists) {
          return userInfo['profile_name'];
        }
      } catch (e) {
        //print('Attempt $attempt failed: $e');
      }
      // Wait before retrying
      await Future.delayed(retryDelay);
    }
    //return empty string if the profile name is not found
    return '';
  }

  Future<void> setCurrentlyPlaying(String gameId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;

    if (currentUser != null) {
      DocumentReference doc =
          db.collection('profile_data').doc(currentUser.uid);

      try {
        await doc.update({'currently_playing': gameId});
      } catch (e) {
        throw ("Error setting currently playing: $e");
      }
    } else {
      throw (Exception('User not found'));
    }
  }

  Future<List<GameStats>> fetchRecentActivities(
      List<DocumentReference> recentActivitiesRefs) async {
    final recentActivities = <GameStats>[];

    try {
      for (final statsRef in recentActivitiesRefs) {
        final statsSnapshot = await statsRef.get();
        final statsData = statsSnapshot.data();

        if (statsData is Map<String, dynamic>) {
          final statsModel = GameStats(
              gameId: statsData['game_id'] as String? ?? '',
              lastPlayedDate:
                  _convertTimestampToString(statsData['last_played']),
              mood: statsData['mood'] as String? ?? '',
              timePlayedLast: statsData['time_played'] as int? ?? 0,
              uid: '');

          recentActivities.add(statsModel);
        } else {
          // Handle unexpected data format (e.g., log or skip)
          //print('Unexpected data format for statsData: $statsData');
        }
      }
    } catch (e) {
      // Handle any errors (e.g., log or return an empty list)
      //print('Error fetching recent activities: $e');
    }

    return recentActivities;
  }

  String _convertTimestampToString(Timestamp? timestamp) {
    if (timestamp != null) {
      final dateTime = timestamp.toDate();
      return dateTime.toString(); // Customize the format as needed
    }
    return ''; // Return an empty string if timestamp is null
  }

  Future<void> editUsername(String username) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        if (username.isNotEmpty) {
          final data = {"username.profile_name": username};
          await db.collection("profile_data").doc(currentUser.uid).update(data);

          //Commented out this code to prevent number from updating.
          //await AuthService().getNextNumber();
          //int nextnumber = await AuthService().getNextNum();
          //if (nextnumber != 0) {
          //  final number = { "username.unique_num" :nextnumber};
          //  await db.collection("profile_data").doc(currentUser.uid).update(number);
          //}
        }
      }
    } catch (e) {
      //print('username was not updated');
    }
  }

  Future<List<GameStats>> getMyGame(List<String> myGames, String uid) async {
    List<GameStats> gameStatsList = [];
    try {
      for (String gameId in myGames) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('game_session_stats')
            .where('game_id', isEqualTo: gameId)
            .where('user_id', isEqualTo: uid)
            .get();

        if (querySnapshot.docs.isEmpty) {
          gameStatsList.add(GameStats(
            gameId: gameId,
            lastPlayedDate: '',
            mood: '',
            timePlayedLast: 0,
            uid: uid,
          ));
        } else {
          for (var doc in querySnapshot.docs) {
            gameStatsList.add(GameStats(
              gameId: doc['game_id'],
              lastPlayedDate: _convertTimestampToString(doc['last_played']),
              mood: doc['mood'],
              timePlayedLast: doc['time_played'],
              uid: doc['user_id'],
            ));
          }
        }
      }
    } catch (e) {
      //print("Error from myGames: $e");
    }
    return gameStatsList;
  }
}
