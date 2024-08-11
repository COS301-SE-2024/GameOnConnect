class AppUser {
  final String uid;
  String profilePicture;
  final String profileName;
  final String username;
  final String uniqueNum;
  final String currentlyPlaying;
  AppUser(
      {required this.uid,
      required this.profilePicture,
      required this.profileName,
      required this.username,
      required this.uniqueNum,
      required this.currentlyPlaying});

  factory AppUser.fromMap(Map<String, dynamic>? data) {
    return AppUser(
      uid: data?['userID'],
      profilePicture: data?['profile_picture'],
      profileName: data?['name'],
      username: data?['username']['profile_name'],
      uniqueNum: data!['username']['unique_num'].toString(),
      currentlyPlaying: data['currently_playing']
    );
  }

  /*Future<String?> getPicture(Map<String, dynamic> data)
  async {
    String picture = data['profile_picture'] ?? '';
     String profilePictureUrl = '';
    
          if (picture.isNotEmpty) {
            try {
              // Use refFromURL for a full URL
              Reference storageRef =
                  FirebaseStorage.instance.refFromURL(picture);
              profilePictureUrl = await storageRef.getDownloadURL();

            } catch (e) {
              return null;
            }
          }
          return profilePictureUrl;
  }

  Future<void> setpicture(Map<String, dynamic> data) async {
  profilePicture = await getPicture(data) ?? ''; // Await the result
}*/
}
