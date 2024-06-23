import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/services/user_service.dart';

class FriendServices {
  //get an instance from FireStore Database
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final UserService _userService = UserService();
  User? currentUser;
  String? currentid='';

  void initializeCurrentUser() {
    currentUser = auth.currentUser;
    currentid=currentUser?.uid;
  }

  //Read friends from database
  Future<List<String>> getFriends(String who) async {
    initializeCurrentUser();
    if (currentUser == null) {
      return []; //return an empty array
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('friends').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        if(who=="friends")
        {
           // Cast the friends array to List<String>
          List<String> friends = List<String>.from(snapshot.data()!['friends']);
          return friends;
        }
        if(who=="requests")
        {
           // Cast the friends request array to List<String>
          List<String> requests = List<String>.from(snapshot.data()!['friend_requests']);
          return requests;
        }
        else{
          return []; //return an empty array
        }
     
    } else {
      return []; //return an empty array
    }

    } catch (e) {
      return []; //return an empty array
    }
  }

   Future<List<String>> getFriendRequests() async {
    initializeCurrentUser();
    if (currentUser == null) {
      return []; //return an empty array
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('friends').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
      // Cast the friends array to List<String>
      List<String> requests = List<String>.from(snapshot.data()!['friend_requests']);
      return requests;
    } else {
      return []; //return an empty array
    }

    } catch (e) {
      return []; //return an empty array
    }
  }

  void acceptFriendRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _userService.acceptFriendRequest(currentUserId, requesterUserId);
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  } 

  void rejectFriendRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _userService.rejectFriendRequest(currentUserId, requesterUserId);
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  } 

  Future<Map<String, dynamic>?> fetchFriendProfileData(String userId) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      DocumentSnapshot doc =
          await db.collection("profile_data").doc(userId).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Map<String, dynamic> userInfo =
            data['username'] as Map<String, dynamic>;
        String profileName = data['name'] ?? 'Profile name';
        String username = userInfo['profile_name'] ?? 'username';
        String userID =data['userID']?? '';
        String profilePicture = data['profile_picture'] ?? '';

        String profilePictureUrl = '';

        if (profilePicture.isNotEmpty) {
          try {
            Reference storageRef =
                FirebaseStorage.instance.refFromURL(profilePicture);
            profilePictureUrl = await storageRef.getDownloadURL();
          } catch (e) {
            return null;
          }
        }

        return {
          'profileName': profileName,
          'username': username,
          'profilePicture': profilePictureUrl,
          'userID': userID,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
