import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/help/help_card.dart';
import 'package:gameonconnect/view/components/help/contact_us_bottom.dart';


class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
        title: Text('Help Center', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

                          const Padding(
                            padding: EdgeInsets.all(25),
                            child:Expanded( child:  Text(
                              "Quick answers to questions you may have. Can't find what your looking for? Contact us through our email address.",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    ),
               HelpCard(heading: "Frequently Asked Questions",
                  followHeading: "Answers to commonly asked questions about "
                      "GameOnConnect",
              icon: Icon(
                Icons.question_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 44,

              ),
               navigation: '/faq',
               ),
               HelpCard(heading: "Getting Started", followHeading:
              "Tutorial videos to help you get started  on GameOnConnect",
              icon: Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.primary,
                size: 44,
              ),
               navigation: '/getting_started',),

      ]),
              ),
          bottomNavigationBar: const ContactUsBar(),

      ),
    );
  }
}
