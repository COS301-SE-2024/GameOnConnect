// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/help/all_faqs.dart';
import 'package:gameonconnect/view/components/help/contact_us_bottom.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(
          title: 'Help & Support',
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: Key('Back_button_key'),
          textkey: Key('Help_text'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Text(
                "Quick answers to questions you may have. Can't find what your looking for? Contact us through our email address.",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            AllFaqs()
          ],
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
        bottomNavigationBar: ContactUsBar());
  }
}
