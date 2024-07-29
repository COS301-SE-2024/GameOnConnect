// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Help',
            style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          ),
          leading: IconButton(
            key: Key('Back_button_key'),
            icon: const Icon(Icons.keyboard_backspace),
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
            child:
                ListView(padding: const EdgeInsets.all(8), children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/getting_started');
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Theme.of(context).colorScheme.primary,
              ),
              child:  Center(
                child: Text(
                    style: TextStyle(color:Theme.of(context).colorScheme.surface),
                  key: Key('Getting_started_text'),
                  "Getting started"),

              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          /*GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/profile_management');
            },
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Color.fromARGB(255, 128, 216, 50),
              ),
              child: const Center(child: Text("Profile Management")),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Color.fromARGB(255, 128, 216, 50),
            ),
            child: const Center(child: Text("Game Management")),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Color.fromARGB(255, 128, 216, 50),
            ),
            child: const Center(child: Text("Social Management")),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: Color.fromARGB(255, 128, 216, 50),
            ),
            child: const Center(child: Text("Troubleshooting")),
          ),
          SizedBox(
            height: 5,
          ),*/
        ])));
  }
}
