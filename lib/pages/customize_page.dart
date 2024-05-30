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

          const Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), 
            child: Text('Genre interests:', style: TextStyle(fontSize: 15)),
            ),
          ),

          const SizedBox(height: 8),
           Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButtons(text: 'genre1'),
                CustomButtons(text: 'genre2'),
                CustomButtons(text: 'genre3'),
              ],
            ),

             const SizedBox(height: 45),
             
             const Align(
          alignment: Alignment.centerLeft,
          child:    Padding(
            padding: EdgeInsets.only(left: 30), 
            child: Text('Age ratings:', style: TextStyle(fontSize: 15)),
            ),
          ),
           const SizedBox(height: 8),
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomButtons(text: 'Age rating 1'),
                CustomButtons(text: 'Age rating 2'),
                // add button 
                AddButton(),
              ],
            ),

            

        ]
        ),
    );
  }
}

class CustomButtons extends StatelessWidget {
  final String text;
  const CustomButtons({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(text),
              const SizedBox(width: 8), // Space between text and icon
              GestureDetector(
                onTap: () {
                  // TODO: Add the action you want to perform on tap
                },
                child: const Icon(
                  Icons.close, // Cross icon for close
                  size: 16.0,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddButton extends StatelessWidget {
  const AddButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
  onTap: () {
    // TODO: Define what happens when the button is tapped
  },
  child: Container(
    padding: const EdgeInsets.all(7), // Adjust the padding to change the size
    decoration: BoxDecoration(
      color: Colors.grey[300], // Choose the color of the button
      shape: BoxShape.circle, // This makes the container circular
    ),
    child: const Icon(
      Icons.add, // The plus icon
      color: Colors.black, // Choose the color of the icon
      size: 16, // Adjust the size of the icon
    ),
  ),
);
  }
}


