import 'package:flutter/material.dart';

class CustomizeProfilePage extends StatefulWidget {
  @override
  CustomizeProfilePageObject createState() => CustomizeProfilePageObject();
}

class CustomizeProfilePageObject extends State<CustomizeProfilePage> {

  bool isDarkMode = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         leading:IconButton(
            icon: const Icon(Icons.keyboard_backspace),
           onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: CircleAvatar(
          radius: 25.0, // Doubled the radius
          backgroundColor: Colors.white,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black, width: 1.0),
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          //Text('Customize Profile', style: TextStyle(fontSize: 24)),
          const Align(
          alignment: Alignment.center,
           child: Text('Customize Profile', style: TextStyle(fontSize: 24)),   
          ),
          const SizedBox(height: 30),
          Center(
            child: CircleAvatar(
              radius: 60,
               backgroundColor: Colors.grey[300],  
            ),
          ),

           const Align(
          alignment: Alignment.center,
           child: Text('Change picture', style: TextStyle(fontSize: 18)),   
          ),
          const SizedBox(height: 30),

          
        ]
        ),
    );
  }
}