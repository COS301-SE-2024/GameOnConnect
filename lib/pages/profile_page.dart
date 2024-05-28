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
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Icon(Icons.people),
                    Text('5 Friends'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.gamepad),
                    Text('Games'),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Icon(Icons.event),
                    Text('Events'),
                  ],
                ),
                Divider(
                  color: Colors.grey, // Customize the color of the line
                  thickness: 1.0, // Set the thickness of the line
                ),
              ],
            ),
            Text('Game Name', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7), // Add some padding around the text
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color of the rectangle
                        borderRadius: BorderRadius.circular(25), // The rounded ends of the rectangle
                      ),
                      child: Text('Action',),
                    ),
                  ],
                ),
                Column(
                 children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7), // Add some padding around the text
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color of the rectangle
                        borderRadius: BorderRadius.circular(25), // The rounded ends of the rectangle
                      ),
                      child: Text('Sept 2022',),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7), // Add some padding around the text
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color of the rectangle
                        borderRadius: BorderRadius.circular(25), // The rounded ends of the rectangle
                      ),
                      child: Text('MOBA',),
                    ),
                  ],
                ),
              ],
            ),
        ]
        )
    );
   }
}
