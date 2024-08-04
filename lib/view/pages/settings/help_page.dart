// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/help/contact_us_bottom.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(
          title: 'Help',
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: Key('Back_button_key'),
          textkey: Key('Help_text'),
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
        ])),
        bottomNavigationBar: ContactUsBar(),);
  }
}
