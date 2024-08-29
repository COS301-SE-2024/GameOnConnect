import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/services/authentication_S/auth_service.dart';
import 'package:gameonconnect/services/messaging_S/messaging_service.dart';
import 'package:gameonconnect/view/components/messaging/chat_bubble_component.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChatPage extends StatefulWidget {
  final String profileName;
  final String receiverID;
  final String profilePicture;

  const ChatPage({
    super.key,
    required this.profileName,
    required this.receiverID,
    required this.profilePicture,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingController = TextEditingController();
  final MessagingService _messagingService = MessagingService();
  final AuthService _authService = AuthService();
  FocusNode newFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    newFocusNode.addListener(() {
      if (newFocusNode.hasFocus) {
        Future.delayed(
            const Duration(milliseconds: 500), () => scrollDownPage());
      }
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        scrollDownPage();
      }
    });
  }

  @override
  void dispose() {
    newFocusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void scrollDownPage() {
    if (_scrollController.hasClients &&
        _scrollController.position.maxScrollExtent > 0) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  void sendMessage() async {
    String currentUser = _authService.getCurrentUser()!.uid;
    String messageText = _textEditingController.text.trim();

    if (messageText.isNotEmpty) {
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: Row(
            children: [
              buildProfilePicture(widget.profilePicture),
              const SizedBox(width: 8),
              Text(widget.profileName,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        scrolledUnderElevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(5.0), 
          child: SizedBox(height: 2.0), 
        ),
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
          return Center(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: Theme.of(context).colorScheme.primary,
              size: 36,
            ),
          );
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
      padding: const EdgeInsets.all(5.0),
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
                  maxLines: null,
                  minLines: 1,
                  decoration: InputDecoration(
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    filled: true,
                    hintText: "Enter your message here",
                    hintStyle: const TextStyle(
                      fontFamily: 'Inter',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onFieldSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      sendMessage();
                    }
                  },
                );
              },
            ),
          ),
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: _textEditingController,
            builder: (context, value, child) {
              return value.text.trim().isNotEmpty
                  ? IconButton(
                      onPressed: sendMessage,
                      icon: Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : Container();
            },
          ),
        ],
      ),
    );
  }

  Widget buildProfilePicture(String? profilePicUrl) {
    if (profilePicUrl != null) {
      return Padding(
        padding: const EdgeInsets.all(2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: CachedNetworkImage(
            imageUrl: profilePicUrl,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            placeholder: (context, url) => _buildLoadingWidget(),
            errorWidget: (context, url, error) => _buildErrorWidget(),
            fadeInDuration: const Duration(milliseconds: 200),
            fadeInCurve: Curves.easeIn,
            memCacheWidth: 50,
            memCacheHeight: 50,
            maxWidthDiskCache: 50,
            maxHeightDiskCache: 50,
          ),
        ),
      );
    } else {
      return _buildErrorWidget();
    }
  }

  //this widget builds while the image is still loading
  Widget _buildLoadingWidget() {
    return SizedBox(
      width: 44,
      height: 44,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LoadingAnimationWidget.halfTriangleDot(
          color: Theme.of(context).colorScheme.primary,
          size: 36,
        ),
      ),
    );
  }

  //this widget builds if there is an error with the image
  Widget _buildErrorWidget() {
    return Container(
      width: 44,
      height: 44,
      color: Colors.grey[300],
      child: const Icon(Icons.error),
    );
  }
}
