import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/view/components/messaging/chat_bubble_component.dart';

class ChatPage extends StatelessWidget {
  final String profileName;
  final String receiverID;

  ChatPage({
    super.key,
    required this.profileName,
    required this.receiverID,
  });

  final TextEditingController _textEditingController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    String currentUser = _authService.getCurrentUser()!.uid;
    if (_textEditingController.text.isNotEmpty) {
      //find the conversationID
      String conversationID =
          await _messagingService.findConversationID(currentUser, receiverID);
      //if the conversationID could not be found make a new one
      if (conversationID == 'Not found') {
        List<String> newList = [currentUser, receiverID];
        conversationID = await _messagingService.createConversation(newList);
      }

      //send a message
      await _messagingService.sendMessage(
          conversationID, _textEditingController.text, receiverID);
      //clear the controller
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(profileName),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
          _buildUserInput(context),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;

    // Use FutureBuilder to first find the conversation ID
    return FutureBuilder<String>(
      future: _messagingService.findConversationID(senderID, receiverID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data == 'Not found') {
          return const Center(child: Text("No conversation found"));
        } else {
          String conversationID = snapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream: _messagingService.getSnapshotMessages(conversationID),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error loading messages");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading messages...');
              }
              var documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  return _buildMessageItem(documents[index]);
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentuser = data['userID'] == _authService.getCurrentUser()!.uid;
    
    var alignment =
        isCurrentuser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: ChatBubble(
          message: data["message_text"], isCurrentuser: isCurrentuser),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textEditingController,
              obscureText: false,
              decoration: InputDecoration(
                hintText: "Enter your message here",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.arrow_forward_ios,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
