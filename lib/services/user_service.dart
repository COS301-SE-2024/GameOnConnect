import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/friend_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 // Stream for real-time updates
  Stream<Friend> getCurrentUserFriendsStream(String uid) {
    return _firestore.collection('friends').doc(uid).snapshots().map((snapshot) {
      return Friend.fromMap(snapshot.data() as Map<String, dynamic>);
    });
  }

  // Fetch all users

 Future<List<User>> fetchAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('profile_data').get();
      List<User> users = [];
      for (var doc in querySnapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        if (_hasRequiredFields(data)) {
          User currentuser =User.fromMap(data);
          //await currentuser.setpicture(data); // Await the result
          users.add(currentuser);
          //users.add(User.fromMap(data));
        } else {
          //print('Skipping document ${doc.id} due to missing required fields \n');
          //print('user document: $data \n');
            //print("---------------------------- \n");
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
  Future<Friend> fetchCurrentUserFriends(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('friends').doc(uid).get();
      return Friend.fromMap(docSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Error fetching friend data: $e');
    }
  }

  // Send friend request
  Future<void> sendFriendRequest(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('friends').doc(currentUserId).update({
        'pending': FieldValue.arrayUnion([targetUserId])
      });

      // Add to the target user's friend request list
      await _firestore.collection('friends').doc(targetUserId).update({
        'friend_requests': FieldValue.arrayUnion([currentUserId])
      });
    } catch (e) {
      throw Exception('Error sending friend request: $e');// [cloud_firestore/permission-denied] Missing or insufficient permissions.
    }
  }
  // ---???when they click on pending it should remove everyone from pending and freind request 
  Future<void> UndoFriendRequest (String currentUserId,  String targetUserId) async {
    try {
      // Add each other to friends list
      await _firestore.collection('friends').doc(currentUserId).update({
         'pending': FieldValue.arrayRemove([targetUserId])
        
      });

      await _firestore.collection('friends').doc(targetUserId).update({
       'friend_requests': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error undoing friend request: $e');
    }
  }


  // Accept friend request
  Future<void> acceptFriendRequest(String currentUserId, String requesterUserId) async {
    try {
      // Add each other to friends list
      await _firestore.collection('friends').doc(currentUserId).update({
        'friends': FieldValue.arrayUnion([requesterUserId]),
        'friend_requests': FieldValue.arrayRemove([requesterUserId])
      });

      await _firestore.collection('friends').doc(requesterUserId).update({
        'friends': FieldValue.arrayUnion([currentUserId]),
        'pending': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error accepting friend request: $e');
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('friends').doc(currentUserId).update({
        'friends': FieldValue.arrayRemove([targetUserId])
      });

      await _firestore.collection('friends').doc(targetUserId).update({
        'friends': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      throw Exception('Error unfollowing user: $e');
    }
  }
}
