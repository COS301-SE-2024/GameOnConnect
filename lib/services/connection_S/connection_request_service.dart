import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/connection_M/user_model.dart';
import '../../model/connection_M/friend_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 // Stream for real-time updates
  Stream<Friend?> getCurrentUserFriendsStream(String uid) {
    return _firestore.collection('friends').doc(uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data != null) {
        // ignore: unnecessary_cast
        return Friend.fromMap(data as Map<String, dynamic>);
      } else {
        throw Exception('Could not get friends');
      }
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
  Future<Friend?> fetchCurrentUserFriends(String uid) async {
    try {
      DocumentSnapshot docSnapshot = await _firestore.collection('friends').doc(uid).get();
      var data = docSnapshot.data();
      if (data != null) {
      return Friend.fromMap(data as Map<String, dynamic>);
    } else {
      throw Exception('EXCEPTION OCCURRED'); 
    }
    } catch (e) {
      throw Exception('Error fetching friend data: $e');
    }
  }

  // Send friend request
  Future<void> sendFriendRequest(String currentUserId, String targetUserId) async {
    try {
      await _firestore.collection('friends').doc(currentUserId).set({
        'pending': FieldValue.arrayUnion([targetUserId])
      } , SetOptions(merge: true));

      // Add to the target user's friend request list
      await _firestore.collection('friends').doc(targetUserId).set({
        'friend_requests': FieldValue.arrayUnion([currentUserId])
      } ,SetOptions(merge: true));
    } catch (e) {
      throw Exception('Error sending friend request: $e');
    }
  }

  Future<void> undoFriendRequest (String currentUserId,  String targetUserId) async {
    try {
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
  Future<void> acceptFriendRequest(String? currentUserId , String requesterUserId) async {
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

  //reject friend request
  Future<void> rejectFriendRequest(String? currentUserId, String requesterUserId) async {
    try {
      // Add each other to friends list
      await _firestore.collection('friends').doc(currentUserId).update({
        'friend_requests': FieldValue.arrayRemove([requesterUserId])
      });

      await _firestore.collection('friends').doc(requesterUserId).update({
        'pending': FieldValue.arrayRemove([currentUserId]) 
        // later might have to send a notification to let the other user they were rejected
      });
    } catch (e) {
      throw Exception('Error rejecting friend request: $e');
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
