// ignore_for_file: unused_element, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gameonconnect/services/connection_S/connection_request_service.dart';


class ConnectionService {

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
  Future<List<String>> getConnections(String who) async {
    initializeCurrentUser();
    if (currentUser == null) {
      return []; //return an empty array
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('connections').doc(currentUser!.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
        if(who=="connections")
        {
           // Cast the friends array to List<String>
          List<String> connections = List<String>.from(snapshot.data()!['connections']);
          return connections;
        }
        if(who=="requests")
        {
           // Cast the friends request array to List<String>
          List<String> requests = List<String>.from(snapshot.data()!['connection_requests']);
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

   Future<List<String>> getConnectionRequests() async {
    initializeCurrentUser();
    if (currentUser == null) {
      return []; //return an empty array
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection('connections').doc(currentUser?.uid).get();

      if (snapshot.exists && snapshot.data() != null) {
      // Cast the friends array to List<String>
      List<String> requests = List<String>.from(snapshot.data()!['connection_requests']);
      return requests;
    } else {
      return []; //return an empty array
    }

    } catch (e) {
      return []; //return an empty array
    }
  }

  void acceptConnectionRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _userService.acceptConnectionRequest(currentUserId, requesterUserId);
    } catch (e) {
      print('Error accepting connection request: $e');
    }
  } 

  void rejectConnectionRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await _userService.rejectConnectionRequest(currentUserId, requesterUserId);
    } catch (e) {
      print('Error accepting connection request: $e');
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
        Map<String,dynamic> username = userInfo;
        String userID =userId;
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


        Map<String,dynamic>? d =
         {
          'name': profileName,
          'username': username,
          'profile_picture': profilePictureUrl,
          'userID': userID,
        };

        return d;

      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
