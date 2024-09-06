import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/help/all_faqs.dart';
import 'package:gameonconnect/view/components/help/contact_us_bottom.dart';

class GettingStarted extends StatelessWidget {
  const GettingStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackButtonAppBar(
          title: 'Getting Started',
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: const Key('Back_button_key'),
          textkey: const Key('Help_text'),
        ),
        body: Column(
          children: [

            AllFaqs()
          ],
        ),
        bottomNavigationBar: const ContactUsBar());
  }
}
