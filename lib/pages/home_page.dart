// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  int _selectedIndex = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            MaterialButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              color: Colors.grey[600],
              child: Text('Sign Out'),
            ),
            MaterialButton(
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
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/sign_up');
              },
              color: Colors.grey[600],
              child: Text('sign up page '),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/profile');
              },
              color: Colors.grey[600],
              child: Text('Profile page '),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the floating action button press
        },
        tooltip: 'Add',
        child: const Icon(Icons.gamepad_rounded),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home_filled),
              onPressed: () {
                _onItemTapped(0);
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _onItemTapped(1);
              },
            ),
            SizedBox(width: 48.0), // The dummy child
            IconButton(
              icon: Icon(Icons.calendar_today),
              onPressed: () {
                _onItemTapped(2);
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                _onItemTapped(3);
              },
            ),
          ],
        ),
      ),
    );
  }
}
