import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserProfile.dart';


class FriendSearch {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Stream<List<UserProfile>> searchFriends(String query) {
  return db
    .collection('profile_data')
    .where('username.profile_name', isGreaterThanOrEqualTo: query.toLowerCase())
    .where('username.profile_name', isLessThan: query.toLowerCase() + '\uf8ff')
    .snapshots()
    .asyncMap((snapshot) async {
      List<UserProfile> userProfiles = [];
      for (var doc in snapshot.docs) {
        UserProfile userProfile = await UserProfile.fromDocumentSnapshot(doc);
        userProfiles.add(userProfile);
      }
      return userProfiles;
    });
}

}


