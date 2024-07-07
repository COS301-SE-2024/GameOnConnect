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

  
}
