import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';

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
          Map<String, dynamic> userInfo = data['username'] as Map<String, dynamic>;
          String profileName = data['name'] ?? 'Profile name';
          String username = userInfo['profile_name'] ?? 'username';
          String profilePicture = data['profile_picture'] ?? '';
          String profileBanner = data['banner'];
          int uniqueNum = userInfo['unique_num'] ?? '';

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
            'profileBanner': bannerUrl,
            'unique_num': uniqueNum,
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

  Future<String?> getProfileName(String userId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot profileSnapshot = await db.collection("profile_data").doc(userId).get(); //get the document
    Map<String, dynamic> data = profileSnapshot.data() as Map<String, dynamic>; //map the overall data
    Map<String, dynamic> userInfo = data['username'] as Map<String, dynamic>; //map the username data
    // Return profile name if exists otherwise give an empty string
    if (profileSnapshot.exists) {
      return userInfo['profile_name'];
    } else {
      return '';
    }
  }

  Future<void> editUsername(String username) async
  {
    try{
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;
      if (currentUser != null) {
        if (username.isNotEmpty) {
          final data = { "username.profile_name" :username};
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
    }catch (e)
    {
      //print('username was not updated');
    }
  }
}

