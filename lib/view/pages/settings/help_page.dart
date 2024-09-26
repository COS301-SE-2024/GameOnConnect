import 'package:flutter/material.dart';
import 'package:gameonconnect/services/badges_S/badge_service.dart';
import 'package:gameonconnect/services/events_S/dynamic_scaling.dart';
import 'package:gameonconnect/view/components/help/help_card.dart';
import '../../components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/help/contact_us_bottom.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpWidgetState();
}

class _HelpWidgetState extends State<HelpPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final BadgeService _badgeService = BadgeService();

  @override
  void initState() {
    super.initState();
    _badgeService.unlockNightOwlBadge(DateTime.now());
    _badgeService.unlockExplorerComponent("view_help");
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
          iconkey: const Key('Help_back_button'),
          textkey: const Key('Help_title_key'),
        ),
        body: SafeArea(
          top: true,
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Padding(
              padding: EdgeInsets.all(25.pixelScale(context)),
              child: Expanded(
                child: Text(
                  "Quick answers to questions you may have. Can't find what your looking for? Contact us through our email address.",
                  style: TextStyle(
                    fontSize: 12.pixelScale(context),
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            HelpCard(
              heading: "Frequently Asked Questions",
              followHeading: "Answers to commonly asked questions about "
                  "GameOnConnect",
              icon: Icon(
                Icons.question_mark,
                color: Theme.of(context).colorScheme.primary,
                size: 44.pixelScale(context),
              ),
              navigation: '/faq',
            ),
            HelpCard(
              heading: "Getting Started",
              followHeading:
                  "Tutorial videos to help you get started  on GameOnConnect",
              icon: Icon(
                Icons.play_arrow,
                color: Theme.of(context).colorScheme.primary,
                size: 44.pixelScale(context),
              ),
              navigation: '/getting_started',
            ),
          ]),
        ),
        bottomNavigationBar: const ContactUsBar(),
      ),
    );
  }
}
