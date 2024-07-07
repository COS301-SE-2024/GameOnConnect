import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessagingService 
{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new conversation (group or private chat)
  Future<String> createConversation(List<String> participants) async 
  {
    try 
    {
      final String conversationID = _firestore.collection('messages_log').doc().id;

      await _firestore.collection('messages_log').doc(conversationID).set({
        'conversationID': conversationID,
        'participants': participants,
        'participant_messages': []
      });

      return conversationID;
    } 
    catch (e) 
    {
      throw Exception("Failed to create conversation: $e");
    }
  }

  // Send a message in a conversation
  Future<void> sendMessage(String conversationID, String messageText) async 
  {
    try 
    {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      final String messageID = _firestore.collection('messages').doc().id;
      final Timestamp timestamp = Timestamp.now();

      await _firestore.collection('messages').doc(messageID).set({
        'messageID': messageID,
        'conversationID': conversationID,
        'message_text': messageText,
        'userID': currentUser.uid,
        'timestamp': timestamp
      });

      await _firestore.collection('messages_log').doc(conversationID).update({
        'participant_messages': FieldValue.arrayUnion([messageID])
      });
    } 
    catch (e) 
    {
      throw Exception("Failed to send message: $e");
    }
  }

  // Get messages from a conversation
  Future<List<Map<String, dynamic>>> getMessages(String conversationID) async 
  {
    try 
    {
      QuerySnapshot querySnapshot = await _firestore
          .collection('messages')
          .where('conversationID', isEqualTo: conversationID)
          .orderBy('timestamp', descending: false)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } 
    catch (e) 
    {
      throw Exception("Failed to get messages: $e");
    }
  }

  // Get conversations for the current user
  Future<List<Map<String, dynamic>>> getConversations() async 
  {
    try 
    {
      final User? currentUser = _auth.currentUser;
      if (currentUser == null) throw Exception("No user logged in");

      QuerySnapshot querySnapshot = await _firestore
          .collection('messages_log')
          .where('participants', arrayContains: currentUser.uid)
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } 
    catch (e) 
    {
      throw Exception("Failed to get conversations: $e");
    }
  }
}
