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
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                height: 170,
                color: Colors.grey[300], // Placeholder for banner image
              ),
              Positioned(
                bottom: -50, // Half of the CircleAvatar's radius to align it properly
                left: 50,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey, // Placeholder for profile image
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          SizedBox(height: 8),
          Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), // Adjust the value to your preference
            child: Text('Profile Name', style: TextStyle(fontSize: 24)),
            ),
          ),
          Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), // Adjust the value to your preference
            child: Text('Username', style: TextStyle(fontSize: 20)),
            ),
          ),
        ]
        )
    );
   }
}
