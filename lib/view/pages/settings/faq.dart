import 'package:flutter/material.dart';
import 'package:gameonconnect/view/components/appbars/backbutton_appbar_component.dart';
import 'package:gameonconnect/view/components/help/faq_boxes.dart';

class FaqWidget extends StatefulWidget {
  const FaqWidget({super.key});

  @override
  State<FaqWidget> createState() => _FaqWidgetState();
}

class _FaqWidgetState extends State<FaqWidget> {
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
        appBar: BackButtonAppBar(
          title: "FAQ's",
          onBackButtonPressed: () {
            Navigator.pop(context);
          },
          iconkey: const Key('Back_button_key'),
          textkey: const Key('Help_text'),
        ),
        key: scaffoldKey,
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(10)),
                    child: const Column(
                      children: [
                        Text(
                          "Account and connections",
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        Faq_boxWidget(
                          question: "What are connections?",
                          answer:
                              "Connections are any profiles on GameOnConnect "
                              "who you choose to connect with. You can view their"
                              " profiles and "
                              "invite them specifically to any event you "
                              "choose to create",
                        ),
                        Faq_boxWidget(
                          question: "How are profiles made unique?",
                          answer: "To make it easier for you to search for "
                              "someone specific, we assign everyone a unique number. "
                              "This way you can distinguish between all the different profiles"
                              "and easily find your friends on GameOnConnect",
                        ),
                        Faq_boxWidget(
                          question:
                              "What is the difference between a private and "
                              "public account?",
                          answer:
                              "If your account is private, anyone who is not "
                              "your connection, will not be able to see any information"
                              " when viewing your profile. If your account is public"
                              " anyone will be able to view your profile, including"
                              " your stats, My Games list, Want to play list as well as"
                              " your connections list. ",
                        ),
                        Faq_boxWidget(
                          question:
                              "What is the difference between My Games and Want to play list?",
                          answer:
                              "Your My Games list is a list where you can add all the games you currently"
                              " have or are currently playing. Your Want to play list "
                              "is a list where you can add all the games you still "
                              "want to play or are interested in",
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.all(10),
                      padding: EdgeInsets.only(top: 24),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Column(
                        children: [
                          Text(
                            "Games and events",
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                          Faq_boxWidget(
                            question:
                                "Can I play a game through GameOnConnect?",
                            answer:
                                "Unfortunately you cannot ply a game through "
                                "GameOnConnect. GameOnConnect is a platform for gamers"
                                " to get to know one another and to easily schedule "
                                "sessions. You are also able to time your gaming "
                                "activity to update your gaming stats for all your "
                                "connections to see. ",
                          ),
                          Faq_boxWidget(
                            question:
                                "What is the difference between gaming sessions"
                                " and tournaments?",
                            answer:
                                "When creating an event, you can choose to make"
                                " the event a gaming session or a tournament. Tournaments"
                                " are competitions, and so there is a lot of pressure"
                                " to perform. Gaming sessions on the other hand "
                                "are more relaxed events, where you can spend time "
                                "playing a game with your connections.",
                          ),
                          Faq_boxWidget(
                            question:
                                "What is the difference between a private and "
                                "public event?",
                            answer:
                                "Your event is set to private by default. This means"
                                "only the connections you have invited are able to join"
                                " the event. If you decide to make your event public, "
                                "any user on GameOnConnect will be able to join and"
                                " partake in your event.",
                          ),
                          // Account & connections
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
