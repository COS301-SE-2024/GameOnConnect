import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

   @override
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

              //banner
              Container(
                height: 170,
                color: Colors.grey[300], // Placeholder for banner image
              ),
              
              const Positioned(
                bottom: -50, // Half of the CircleAvatar's radius to align it properly
                left: 50,
                //profile picture
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey, // Placeholder for profile image
                ),
              ),
            ],
          ),

          const SizedBox(height: 50),
          const SizedBox(height: 8),

          const Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), 
            child: Text('Profile Name', style: TextStyle(fontSize: 24)),
            ),
          ),

          const Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), 
            child: Text('Username', style: TextStyle(fontSize: 20)),
            ),
          ),

          const SizedBox(height: 30),

          //friends, games, events
          const Row(
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

                /*Divider(
                  color: Colors.grey, 
                  thickness: 1.0, 
                ),*/
              ],
            ),
            Divider(
            color: Colors.black54, 
            thickness: 1.0, 
          ),

            const Text('Game Name', style: TextStyle(fontSize: 24)),

            const SizedBox(height: 8),

            //game tags
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7), // Add some padding around the text
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(25), // The rounded ends of the rectangle
                      ),
                      child:const Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: <Widget>[
                          Icon(
                            Icons.circle, // dot icon
                            size: 8.0, 
                            color: Colors.black, 
                          ),
                          SizedBox(width: 8), // Space between the icon and the text
                          Text('Action'),
                        ],
                      ),
  
                    ),
                  ],
                ),

                Column(
                 children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7), 
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(25), 
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: <Widget>[
                          Icon(
                            Icons.circle, 
                            size: 8.0, 
                            color: Colors.black, 
                          ),
                          SizedBox(width: 8), 
                          Text('Sept 2022',),
                        ],
                      ),
                    ),
                  ],
                ),

                Column(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7), 
                      decoration: BoxDecoration(
                        color: Colors.grey[300], 
                        borderRadius: BorderRadius.circular(25), 
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min, 
                        children: <Widget>[
                          Icon(
                            Icons.circle,
                            size: 8.0, 
                            color: Colors.black, 
                          ),
                          SizedBox(width: 8), 
                          Text('MOBA',),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

          const SizedBox(height: 30),

          //game discription
            const Align(
            alignment: Alignment.centerLeft,
            child:    Padding(
              padding: EdgeInsets.only(left: 5), 
              child: Text('Game Description', style: TextStyle(fontSize: 18)),
              ),
            ),

            const SizedBox(height: 10),

            const Align(
            alignment: Alignment.centerLeft,
            child:    Padding(
              padding: EdgeInsets.only(left: 5),
              child: Text('Game Description Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua...', style: TextStyle(fontSize: 14)),
              ),
            ),

        ]
        )
    );
   }
}
