// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

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
        backgroundColor: const Color.fromARGB(255, 128, 216, 50),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              onPressed: () {
              FirebaseAuth.instance.signOut().then((value) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            });
              },
              color: const Color.fromARGB(255, 128, 216, 50),
              textColor: Color.fromARGB(255, 24, 24, 24),
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
              color: const Color.fromARGB(255, 128, 216, 50),
              textColor: Color.fromARGB(255, 24, 24, 24),
              child: Text('Profile Page '),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/game_library');
              },
              color: const Color.fromARGB(255, 128, 216, 50),
              textColor: Color.fromARGB(255, 24, 24, 24),
              child: Text('Game Library Page '),
            ),
          ],
        ),
      ),
    );
  }
}
