class Profile {
  final String banner;
  final String bio;
  final String profilePicture;
  final Map<String, dynamic> username; // { 'profilename': 'JohnDoe', 'uniqueNumber': 123 }
  final String currentlyPlaying;
  final List<String> myGames;
  final List<String> wantToPlay;

  Profile({
    required this.banner,
    required this.bio,
    required this.profilePicture,
    required this.username,
    required this.currentlyPlaying,
    required this.myGames,
    required this.wantToPlay,
  });
}