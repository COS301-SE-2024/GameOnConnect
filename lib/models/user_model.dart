class User {
  final String uid;
  final String profilePicture;
  final String profileName;

  User({required this.uid, required this.profilePicture, required this.profileName});

  factory User.fromMap(Map<String, dynamic> data) {

    return User(
      uid: data['userID'],
      profilePicture: data['profile_picture'],
      profileName: data['username']['profile_name'],
    );
  }
}
