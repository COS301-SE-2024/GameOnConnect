import 'package:firebase_storage/firebase_storage.dart';

class User {
  final String uid;
  String profilePicture;
  final String profileName;

  User({required this.uid, required this.profilePicture, required this.profileName});

  factory User.fromMap(Map<String, dynamic> data) {

    return User(
      uid: data['userID'],
      profilePicture: data['profile_picture'],
      profileName: data['username']['profile_name'],
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
