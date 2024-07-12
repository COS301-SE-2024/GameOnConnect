import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileService {
  //Function to query FireStore
  Future<Map<String, dynamic>?> fetchProfileData() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot doc =
            await db.collection("profile_data").doc(currentUser.uid).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          Map<String, dynamic> userInfo =
              data['username'] as Map<String, dynamic>;
          String profileName = data['name'] ?? 'Profile name';
          String username = userInfo['profile_name'] ?? 'username';
          String profilePicture = data['profile_picture'] ?? '';
          String profileBanner = data['banner'];

          String profilePictureUrl = '';
          String bannerUrl = '';

          if (profilePicture.isNotEmpty) {
            try {
              // Use refFromURL for a full URL
              Reference storageRef =
                  FirebaseStorage.instance.refFromURL(profilePicture);
              profilePictureUrl = await storageRef.getDownloadURL();

              Reference storage2 =
                  FirebaseStorage.instance.refFromURL(profileBanner);
              bannerUrl = await storage2.getDownloadURL();
            } catch (e) {
              return null;
            }
          }

          return {
            'profileName': profileName,
            'username': username,
            'profilePicture': profilePictureUrl,
            'profileBanner': bannerUrl
          };
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

