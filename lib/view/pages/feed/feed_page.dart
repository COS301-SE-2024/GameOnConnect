// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/pages/connections/connections_page.dart';
import 'package:gameonconnect/view/pages/game_library/game_library_page.dart';
import 'package:gameonconnect/view/pages/messaging/messaging_page.dart';
import 'package:gameonconnect/view/pages/profile/profile_page.dart';
import 'package:gameonconnect/view/pages/events/create_events_page.dart';
import 'package:gameonconnect/view/pages/events/events_page.dart';
// import 'package:gameonconnect/services/messaging_S/messaging_service.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key, required this.title});
  final String title;

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Center(
        child: _DevelopmentButtons()), // Integrate the development buttons here
    const GameLibrary(), // Actual page for the Games Library
    const CreateEvents(), // create events Page
    const EventsPage(), // Placeholder for the Events Page
    Profile(), // Actual page for the Profile
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title,
            style: TextStyle(color: Theme.of(context).colorScheme.surface)),
      ),
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_filled, 0),
          _buildNavItem(Icons.search, 1),
          _buildNavItem(Icons.gamepad_rounded, 2),
          _buildNavItem(Icons.calendar_today, 3),
          _buildNavItem(Icons.person, 4),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = _selectedIndex == index;
    Color selectedColor = Theme.of(context).brightness == Brightness.light
        ? Colors.black
        : Theme.of(context).colorScheme.primary;
    Color defaultColor = Theme.of(context).brightness == Brightness.light
        ? Colors.grey
        : Theme.of(context).colorScheme.primary;
    Color highlightColor = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).colorScheme.primary
        : const Color.fromARGB(255, 43, 43, 43);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: isSelected
            ? BoxDecoration(
                color: highlightColor,
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? selectedColor : defaultColor,
        ),
      ),
    );
  }
}

class _DevelopmentButtons extends StatelessWidget {
  // final MessagingService messagingService = MessagingService();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Testing for messaging services - It works - commented out
          // MaterialButton(
          //   onPressed: () async {
          //     try {
          //       // Test the messaging service
          //       String conversationID = await messagingService.createConversation(['10H784yQyufaSb32zpYpWX83UeW2', 'rsYgmKH4bOUmhTFcTyKepTcX2Of2']);
          //       await messagingService.sendMessage(conversationID, 'Hello, world!');
          //       List<Map<String, dynamic>> messages = await messagingService.getMessages(conversationID);
          //       List<Map<String, dynamic>> conversations = await messagingService.getConversations();

          //       // Print the results to the console (or handle as needed)
          //       // print('Conversation ID: $conversationID');
          //       // print('Messages: $messages');
          //       // print('Conversations: $conversations');
          //     } catch (e) {
          //       throw Exception("Error during testing: $e");
          //       // print("Error during testing: $e");  // Log the error
          //     }
          //   },
          //   color: Theme.of(context).colorScheme.primary,
          //   textColor: Theme.of(context).colorScheme.surface,
          //   child: Text('Test Messaging Service'),
          // ),
          MaterialButton(
            onPressed: () {
              //add code here to go to the messaging page. 
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Messaging(),
                  ),
                );
            },
            color: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.surface,
            child: Text('Messaging Page'),
          ),
          MaterialButton(
            onPressed: () {
              // Get the current user's ID
              String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
              //print("current user from home: $currentUserId");
              if (currentUserId != null) {
                // Pass the current user's ID to the search friends page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //builder: (context) => FriendSearchPage(currentUserId),
                    builder: (context) => FriendSearch(currentUserId),
                  ),
                );
              } else {
                // Handle the case where there is no logged-in user
                // ignore: avoid_print
                print('No user is currently logged in.');
              }
            },
            color: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.surface,
            child: Text('search friends '),
          ),
        ],
      ),
    );
  }
}
