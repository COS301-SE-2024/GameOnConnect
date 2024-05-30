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
              border: Border.all(color: Colors.black, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }
}