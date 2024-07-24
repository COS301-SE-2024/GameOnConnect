
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageID;
  final String conversationID;
  final String messageText;
  final String userID;
  final Timestamp timestamp;
  final String receiverID;

  Message({
    required this.messageID,
    required this.conversationID,
    required this.messageText,
    required this.userID,
    required this.timestamp,
    required this.receiverID,
  });

  Map<String, dynamic> toMap() {
    return { 
      'messageID': messageID,
      'conversationID': conversationID,
      'message_text': messageText,
      'userID': userID,
      'timestamp': timestamp,
      'receiverID': receiverID,
    };
  }
}