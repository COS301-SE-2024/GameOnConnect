// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/pages/friends_page.dart';
import 'package:gameonconnect/pages/game_library_page.dart';
import 'package:gameonconnect/pages/profile_page.dart';
import 'package:gameonconnect/pages/events_and_gaming_sessions.dart';
import 'package:gameonconnect/pages/events_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    Center(child: _DevelopmentButtons()), // Integrate the development buttons here
    const GameLibrary(), // Actual page for the Games Library
    const EventsGamingSessions(), // Placeholder for the Currently Playing Page
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
        backgroundColor: const Color.fromARGB(255, 128, 216, 50),
        title: Text(widget.title),
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
    Color selectedColor = Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.green;
    Color defaultColor = Theme.of(context).brightness == Brightness.light ? Colors.grey : Colors.green;
    Color highlightColor = Theme.of(context).brightness == Brightness.light ? const Color(0xFF00FF00) : const Color.fromARGB(255, 43, 43, 43);

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
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // MaterialButton(
          //   onPressed: () {
          //     Navigator.pushNamed(context, '/profile');
          //   },
          //   color: const Color.fromARGB(255, 128, 216, 50),
          //   textColor: Color.fromARGB(255, 24, 24, 24),
          //   child: Text('Profile Page '),
          // ),
          MaterialButton(
            onPressed: () {
              
            },
            color: const Color.fromARGB(255, 128, 216, 50),
            textColor: Color.fromARGB(255, 24, 24, 24),
            child: Text('Feed Page'),
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
  color: const Color.fromARGB(255, 128, 216, 50),
  textColor: Color.fromARGB(255, 24, 24, 24),
  child: Text('search friends '),
),

        ],
      ),
    );
  }
}
