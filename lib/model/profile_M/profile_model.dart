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

  Profile({
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
  });
}