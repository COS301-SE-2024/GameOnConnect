// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            /* MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit-profile');
              },
              color: Colors.grey[600],
              child: Text('Edit Profile'),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/customize');
              },
              color: Colors.grey[600],
              child: Text('Customize profile '),
            ),*/
            /*MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              color: Colors.grey[600],
              child: Text('Sign Up Page '),
            ),*/
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
          ],
        ),
      ),
    );
  }
}
