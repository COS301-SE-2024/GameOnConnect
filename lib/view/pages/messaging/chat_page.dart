import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';

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
      String conversationID = await _messagingService.findConversationID(
          _textEditingController.text, receiverID);
      //if the conversationID could not be found make a new one
      if (conversationID == 'Not found') {
        List<String> newList = [currentUser, receiverID];
        conversationID =  await _messagingService.createConversation(newList);
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
          _buildUserInput(),
        ],
      ),
    );
  }

  /*Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    Future<String> conversationID = _messagingService.findConversationID(senderID, receiverID);
    return StreamBuilder(stream: _messagingService.getMessages(conversationID as String), builder: 
      (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        return ListView(
          children: [
            snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          ],
        )

      }
    );
  }*/

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

    return Text(data["message"]);
  }

  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _textEditingController,
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_right_alt),
        ),
      ],
    );
  }
}
