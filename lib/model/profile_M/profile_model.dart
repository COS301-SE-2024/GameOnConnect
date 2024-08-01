import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameonconnect/model/Stats_M/game_stats.dart';

class Profile {
  final String banner;
  final String bio;
  final String profilePicture;
  final Map<String, dynamic> userName; // { 'profilename': 'JohnDoe', 'uniqueNumber': 123 }
  final String profileName;
  final int uniqueNumber;// since it has a larger range
  final String currentlyPlaying;
  final List<String> myGames;
  final List<String> wantToPlay;
  final List<GameStats> recentActivities;
  final int numberOfconnections; 
  final String name;
  final String surname;
  final String theme;
  final String userID;
  final bool visibility;
  final List<String> ageRatings;
  final Timestamp birthday;
  final List<String> genreInterests;
  final List<String> socialInterests;
  final List<int> positions;

  Profile({
    required this.ageRatings,
    required this.birthday,
    required this.banner,
    required this.bio,
    required this.profilePicture,
    required this.userName,
    required this.profileName,
    required this.uniqueNumber,
    required this.currentlyPlaying,
    required this.myGames,
    required this.wantToPlay,
    required this.recentActivities,
    required this.numberOfconnections,
    required this.name,
    required this.surname,
    required this.theme,
    required this.userID,
    required this.visibility,
    required this.genreInterests,
    required this.socialInterests,
    required this.positions,
  });
}