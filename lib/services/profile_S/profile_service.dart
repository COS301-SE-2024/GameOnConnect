import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:gameonconnect/model/profile_M/profile_model.dart';

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

          return Profile(
          banner: data['banner'] ?? '',
          bio: data['bio'] ?? '',
          profilePicture: data['profile_picture'] ?? '',
          username: Map<String, dynamic>.from(data['username'] ?? {}),
          currentlyPlaying: data['currently_playing'] ?? '',
          myGames: List<String>.from(data['my_games'] ?? []),
          wantToPlay: List<String>.from(data['want_to_play'] ?? []),
      );
        } else {
          print('Document not found');
        }
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching profile data: $e');
    }
    return null;
  }

}

