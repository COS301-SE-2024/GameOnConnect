import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/help/help_card.dart';
import 'package:gameonconnect/view/pages/settings/getting_started.dart';

import '../../components/appbars/backbutton_appbar_component.dart';

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
        appBar: BackButtonAppBar(
          title: "Help Center",
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: Key('Help_back_button'),
          textkey: Key('Ehlp_title_key'),
        ),
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
               const Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Text(
                        'Welcome to GameOnConnect\'s Help Center!\n'
                            'If you have any further questions, please feel '
                            'free to send us an email.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
               HelpCard(heading: "Frequently Asked Questions",
                  followHeading: "Answers to commonly asked questions about "
                      "GameOnConnect",
              icon: Icon(
                Icons.question_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 44,
              ),),
               HelpCard(heading: "Getting Started", followHeading:
              "Tutorial videos to help you get started  on GameOnConnect",
              icon: Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.primary,
                size: 44,
              ), ),

      ]),
              ),
          ),
    );
  }
}
