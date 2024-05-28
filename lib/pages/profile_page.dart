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
          ) 
      )
    );
   }
}
