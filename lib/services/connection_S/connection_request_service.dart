import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gameonconnect/services/profile_S/storage_service.dart';
import '../../model/connection_M/user_model.dart';
import '../../model/connection_M/friend_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 // Stream for real-time updates
  Stream<Friend?> getCurrentUserConnectionsStream(String uid) {
    return _firestore.collection('connections').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        // ignore: unnecessary_cast
        return Friend.fromMap(data as Map<String, dynamic>);
      } else {
        throw Exception('Could not get connections');

      }
    });
  }

  // Fetch all users

 Future<List<AppUser>> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('profile_data').get();
      List<AppUser> users = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (_hasRequiredFields(data)) {
          AppUser currentUser = AppUser.fromMap(data);

          //StorageService storageService = StorageService();
          //currentUser.profilePicture = await storageService.getProfilePictureUrl(currentUser.uid);

          users.add(currentUser);
          //users.add(User.fromMap(data));
        } else {
          /*print('Skipping document ${doc.id} due to missing required fields \n');
          print('user document: $data \n');
            print("---------------------------- \n");*/
        }
      }
      return users;
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Check if the document has all required fields
  bool _hasRequiredFields(Map<String, dynamic> data) {
    return data['userID'] != null &&
           data['profile_picture'] != null &&
           data['username'] != null &&
           data['username']['profile_name'] != null;
  }

  // Fetch current user's friend data
  Future<Friend?> fetchCurrentUserConnections(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('connections').doc(uid).get();
      var data = docSnapshot.data();
      if (data != null) {
      return Friend.fromMap(data as Map<String, dynamic>);
    } else {
      throw Exception('EXCEPTION OCCURRED'); 
    }
    } catch (e) {
      throw Exception('Error fetching connection data: $e');
    }
  }

  // Send friend request
  Future<void> sendConnectionRequest(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('connections').doc(currentUserId).set({
        'pending': FieldValue.arrayUnion([targetUserId])
      } , SetOptions(merge: true));

      // Add to the target user's friend request list
      await _firestore.collection('connections').doc(targetUserId).set({
        'connection_requests': FieldValue.arrayUnion([currentUserId])
      } ,SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error sending connection request: $e');
    }
  }

  Future<void> undoConnectionRequest (String currentUserId,  String targetUserId) async {
    try {
      await _firestore.collection('connections').doc(currentUserId).update({
         'pending': FieldValue.arrayRemove([targetUserId])
        
      });

      await _firestore.collection('connections').doc(targetUserId).update({
       'connection_requests': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error undoing connection request: $e');
    }
  }


  
  // Unfollow user
  Future<void> disconnect(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('connections').doc(currentUserId).update({
        'connections': FieldValue.arrayRemove([targetUserId])
      });

      await _firestore.collection('connections').doc(targetUserId).update({
        'connections': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error unconnecting user: $e');
    }
  }
}