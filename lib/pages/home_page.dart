// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gameonconnect/pages/friends_page.dart';

class HomePage extends StatefulWidget {
  // ignore: use_super_parameters
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.grey[600],
              child: Text('Sign Out'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              color: Colors.grey[600],
              child: Text('Sign Up Page '),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              color: Colors.grey[600],
              child: Text('Profile Page '),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game_library');
              },
              color: Colors.grey[600],
              child: Text('Game Library Page '),
            ),
           /* MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/friends');
              },
              color: Colors.grey[600],
              child: Text('search friends '),
            ),*/
            MaterialButton(
  onPressed: () {
    // Get the current user's ID
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
     print("current user from home: $currentUserId");
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
      print('No user is currently logged in.');
    }
  },
  color: Colors.grey[600],
  child: Text('search friends '),
),
          ],
        ),
      ),
    );
  }
}
