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
}
