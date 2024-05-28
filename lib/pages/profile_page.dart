import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

   Widget build(BuildContext context)
   {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading:IconButton(
            icon: const Icon(Icons.keyboard_backspace),
            onPressed: () {
              // Edit profile logic
            },
          ),
          actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit profile logic
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Customize profile logic
            },
          ),
        ], 
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 170,
            color: Colors.grey[300], // Placeholder for banner image
          ),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey, // Placeholder for profile image
          ),
        ]
        )
    );
   }
}
