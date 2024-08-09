import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gameonconnect/model/messages_M/message_modal.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new conversation (group or private chat)
  Future<String> createConversation(List<String> participants) async {
    try {
      final String conversationID =
          _firestore.collection('message_log').doc().id;

      await _firestore.collection('message_log').doc(conversationID).set({
        'conversationID': conversationID,
        'participants': participants,
        'participant_messages': []
      });

      return conversationID;
    } catch (e) {
      // print("Error in createConversation: $e");  // Log the error
      throw Exception("Failed to create conversation: $e");
    }
  }

  // Send a message in a conversation
  Future<void> sendMessage(
      String conversationID, String messageText, String receiverID) async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      final String messageID = _firestore.collection('messages').doc().id;
      final Timestamp timestamp = Timestamp.now();

      Message newMessage = Message(
        messageID: messageID,
        conversationID: conversationID,
        messageText: messageText,
        userID: currentUser.uid,
        timestamp: timestamp,
        receiverID: receiverID,
      );

      //here we set the new message
      await _firestore
          .collection('messages')
          .doc(messageID)
          .set(newMessage.toMap());

      await _firestore.collection('message_log').doc(conversationID).update({
        'participant_messages': FieldValue.arrayUnion([messageID])
      });
    } catch (e) {
      throw Exception("Failed to send message: $e");
    }
  }

  // Get messages from a conversation
  Future<List<Map<String, dynamic>>> getMessages(String conversationID) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('messages')
          .where('conversationID', isEqualTo: conversationID)
          .orderBy('timestamp', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      // print("Error in getMessages: $e");  // Log the error
      throw Exception("Failed to get messages: $e");
    }
  }

  Stream<QuerySnapshot> getSnapshotMessages(String conversationID) {
    return FirebaseFirestore.instance
        .collection('messages')
        .where('conversationID', isEqualTo: conversationID)
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get conversations for the current user
  Future<List<Map<String, dynamic>>> getConversations() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      QuerySnapshot querySnapshot = await _firestore
          .collection('message_log')
          .where('participants', arrayContains: currentUser.uid)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      // print("Error in getConversations: $e");  // Log the error
      throw Exception("Failed to get conversations: $e");
    }
  }

  Stream<DocumentSnapshot> getLastMessage(
      String userID, String otherUserID) async* {
    try {
      //check that the userid and otheruser is not empty
      if (userID.isEmpty ||
          otherUserID.isEmpty ||
          otherUserID == 'Not Found' ||
          userID == 'Not Found') {
        throw Exception("No user logged in");
      }
      String conversationID = await findConversationID(
          userID, otherUserID); //now get the conversationID
          //get snapshots
      await for (var conversationSnapshot in _firestore
          .collection('message_log')
          .doc(conversationID)
          .snapshots()) {
        //ensure the conversation is found
        if (!conversationSnapshot.exists) {
          throw Exception("Conversation was not found");
        }

        //map the data so that the participant messages can be extracted
        Map<String, dynamic> conversationData =
            conversationSnapshot.data() as Map<String, dynamic>;
        List<dynamic> participantMessages =
            conversationData['participant_messages']; //store messages in a list

        //ensure the participant messages are not empty
        if (participantMessages.isEmpty) {
          throw Exception("No messages in conversation found");
        }

        //take the last messageID available
        String lastMessageID = participantMessages.last;
        //get snapshots
        await for (var messageSnapshot in _firestore
            .collection('messages')
            .doc(lastMessageID)
            .snapshots()) {
          //check that the snapshot exists
          if (!messageSnapshot.exists) {
            throw Exception("Message was not found");
          }
          //return the last message as a snapshot
          yield messageSnapshot;
        }
      }
    } catch (e) {
      throw Exception("Failed to get last message: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> getAllUsers() {
    //can change this later to get less users
    return _firestore.collection("profile_data").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data(); //go through all of the users of the app
        return user;
      }).toList();
    });
  }

  Stream<List<Map<String, dynamic>>> getAllChatsForCurrentUser() async* {
    final User? currentUser = _auth.currentUser; //get the current user
    var allUsersSnapshot = await _firestore.collection("profile_data").get();
    List<Map<String, dynamic>> allUsers = allUsersSnapshot.docs
        .map((doc) => doc.data())
        .toList(); //map the users to a list

    List<Map<String, dynamic>> usersWithConversations = [];
    for (var user in allUsers) {
      String conversationID = await findConversationID(
        user['userID'],
        currentUser!.uid,
      ); //find the conversationID between all the users and the person logged in
      if (conversationID != 'Not found') {
        usersWithConversations.add(user);
      }
    }

    yield usersWithConversations; //yield the results
  }

  Future<String> findConversationID(String userID1, String userID2) async {
    var querySnapshot = await _firestore
        .collection('message_log')
        .where('participants', arrayContains: userID1)
        .get();

    for (var doc in querySnapshot.docs) {
      var participants = List<String>.from(doc['participants']);
      if (participants.contains(userID2) &&
          participants.contains(userID1) &&
          userID1 != userID2) {
        return doc.id;
      }
    }
    return 'Not found';
  }
}

/* 
Example of map:

{
  'uid': esldksldsdsdsdsd
  'email': sdsdlksd@gmail.com
}

Example of list of map:

{
  'uid': esldksldsdsdsdsd
  'email': sdsdlksd@gmail.com
}
{
  'uid': esldksldsdsdsdsd
  'email': sdsdlksd@gmail.com
}

*/
