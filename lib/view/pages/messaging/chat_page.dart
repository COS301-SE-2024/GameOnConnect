import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/view/components/messaging/chat_bubble_component.dart';

class ChatPage extends StatefulWidget {
  final String profileName;
  final String receiverID;

  const ChatPage({
    super.key,
    required this.profileName,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  final AuthService _authService = AuthService();
  FocusNode newFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    newFocusNode.addListener(() {
      if (newFocusNode.hasFocus) {
        Future.delayed(
            const Duration(milliseconds: 500), () => scrollDownPage());
      }
    });
    Future.delayed(
      const Duration(milliseconds: 500),
      () => scrollDownPage(),
    );
  }

  @override
  void dispose() {
    newFocusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDownPage() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
    String currentUser = _authService.getCurrentUser()!.uid;
    if (_textEditingController.text.isNotEmpty) {
      //find the conversationID
      String conversationID = await _messagingService.findConversationID(
          currentUser, widget.receiverID);
      //if the conversationID could not be found make a new one
      if (conversationID == 'Not found') {
        List<String> newList = [currentUser, widget.receiverID];
        conversationID = await _messagingService.createConversation(newList);
      }

      //send a message
      await _messagingService.sendMessage(
          conversationID, _textEditingController.text, widget.receiverID);
      //clear the controller
      _textEditingController.clear();

      scrollDownPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileName),
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
      future: _messagingService.findConversationID(senderID, widget.receiverID),
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
                controller: _scrollController,
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
        message: data["message_text"],
        isCurrentuser: isCurrentuser,
        time: data["timestamp"],
      ),
    );
  }

  Widget _buildUserInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: [
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _textEditingController,
              builder: (context, value, child) {
                return TextFormField(
                  focusNode: newFocusNode,
                  controller: _textEditingController,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Enter your message here",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    suffixIcon: value.text.isNotEmpty
                        ? IconButton(
                            onPressed: sendMessage,
                            icon: Icon(
                              Icons.send,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : null,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
