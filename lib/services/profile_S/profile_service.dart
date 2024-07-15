import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';
import 'package:gameonconnect/services/connection_S/connection_service.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';


class ProfileService {
Future<Profile?>  fetchProfile() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final FirebaseAuth auth = FirebaseAuth.instance;
      final currentUser = auth.currentUser;

      if (currentUser != null) {
        DocumentSnapshot doc =
            await db.collection("profile_data").doc(currentUser.uid).get();

        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;


          Map<String, dynamic> userInfo =data['username'] as Map<String, dynamic>;
          String name= userInfo['profile_name'] ?? 'username';
          int uniqueNum=userInfo['unique_num'] ?? '';

  	      // Get number of connections
          List<String> connections= await ConnectionService().getConnections("connections");
          int connectionsCount = connections.length;

          // Fetch banner and profile picture URLs
          StorageService storageService = StorageService();
          String bannerUrl = await storageService.getBannerUrl(currentUser.uid);
          String profilePictureUrl = await storageService.getProfilePictureUrl(currentUser.uid);

          return Profile(
          banner: bannerUrl,
          bio: data['bio'] ?? '',
          profilePicture: profilePictureUrl,
          userName: data['username'] as Map<String, dynamic>,
          profileName: name, 
          uniqueNumber: uniqueNum,
          currentlyPlaying: data['currently_playing'] ?? '',
          myGames: List<String>.from(data['my_games'] ?? []),
          wantToPlay: List<String>.from(data['want_to_play'] ?? []),
          numberOfconnections: connectionsCount,
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


