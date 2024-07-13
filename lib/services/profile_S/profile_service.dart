import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          double uniqueNum=userInfo['unique_num'] ?? '';

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



}


