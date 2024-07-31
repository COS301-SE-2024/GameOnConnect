// ignore_for_file: unused_element, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:gameonconnect/model/connection_M/user_model.dart';
import '../../../model/connection_M/user_model.dart' as user;
import 'package:gameonconnect/services/profile_S/storage_service.dart';

class ConnectionService {
  //get an instance from FireStore Database
  FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? currentUser;
  String? currentid = '';

  void initializeCurrentUser() {
    currentUser = auth.currentUser;
    currentid = currentUser?.uid;
  }

  //Read friends from database
  Future<List<String>> getConnections(String who, [String? UserId = 'CurrentUser']) async {
    if(UserId== 'CurrentUser')
    {
       initializeCurrentUser();
      if (currentUser == null) {
        return []; //return an empty array
      }
      UserId=currentUser!.uid;
    }
   
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await db.collection('connections').doc(UserId).get();
      if (snapshot.exists && snapshot.data() != null) {
        if (who == "connections") {
          // Cast the friends array to List<String>
          List<String> connections =
              List<String>.from(snapshot.data()!['connections']);
          return connections;
        }
        if (who == "requests") {
          // Cast the friends request array to List<String>
          List<String> requests =
              List<String>.from(snapshot.data()!['connection_requests']);
          return requests;
        } else {
          print("no snapshot");
          return []; //return an empty array
        }
      } else {
        return []; //return an empty array
      }
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  Future<List<user.AppUser>?> getConnectionlist() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      List<user.AppUser> list = [];

      if (currentUser != null) {
        List<String>? connections = await getConnections('connections');
        for (var i in connections) {
          user.AppUser u = user.AppUser.fromMap(
              await ConnectionService().fetchFriendProfileData(i));
          list.add(u);
        }
      }
      return list;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<List<user.AppUser>?> getOnlineConnections() async {
    List<user.AppUser> onlineConnections = [];

    try {
      List<user.AppUser>? connections = await getConnectionlist();
      print(connections);

      if (connections != null) {
        for (var connection in connections) {
          if (connection.currentlyPlaying.isNotEmpty) {
            onlineConnections.add(connection);
          }
        }
      }

      return onlineConnections;
    } catch (e) {
      print('Error getting online connections: $e');
      return null;
    }
  }

  Future<void> acceptConnectionRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      // Add each other to friends list
      await db.collection('connections').doc(currentUserId).update({
        'connections': FieldValue.arrayUnion([requesterUserId]),
        'connection_requests': FieldValue.arrayRemove([requesterUserId])
      });

      await db.collection('connections').doc(requesterUserId).update({
        'connections': FieldValue.arrayUnion([currentUserId]),
        'pending': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error accepting connection request: $e');
    }
  }

  Future<void> rejectConnectionRequest(String requesterUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      // Add each other to friends list
      await db.collection('connections').doc(currentUserId).update({
        'connection_requests': FieldValue.arrayRemove([requesterUserId])
      });

      await db.collection('connections').doc(requesterUserId).update({
        'pending': FieldValue.arrayRemove([currentUserId])
        // later might have to send a notification to let the other user they were rejected
      });
    } catch (e) {
      throw Exception('Error rejecting connection request: $e');
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
        Map<String, dynamic> username = userInfo;
        String userID = userId;
       
        StorageService storageService = StorageService();
        String profilePictureUrl =
            await storageService.getProfilePictureUrl(userId);

        Map<String, dynamic>? d = {
          'name': profileName,
          'username': username,
          'profile_picture': profilePictureUrl,
          'userID': userID,
          'currently_playing': data['currently_playing']
        };

        return d;
      } else {
        return null;
      }
    } catch (e) {
      print ("Error fetching profile data: $e");
      throw Exception('Error fetching profile data: $e');
    }
  }

  Future<List<user.AppUser>?> getProfileConnections(String type, String UserId) async {
    try {

      //print('for the profile page pls get the  $type for user: $UserId');
      List<user.AppUser> list = [];

        List<String>? connections =
            await ConnectionService().getConnections(type, UserId);
        for (var i in connections) {
          user.AppUser u = user.AppUser.fromMap(
              await ConnectionService().fetchFriendProfileData(i));
          list.add(u);
      }
      return list;
    } catch (e) {
      throw ('Error: $e');
    }
  }

  
  Future<void> disconnect(String targetUserId) async {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      await db.collection('connections').doc(currentUserId).update({
        'connections': FieldValue.arrayRemove([targetUserId])
      });

      await db.collection('connections').doc(targetUserId).update({
        'connections': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error disconnecting user: $e');
    }
  }
}
