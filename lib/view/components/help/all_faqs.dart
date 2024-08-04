import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';
import 'package:gameonconnect/view/components/help/faq_section.dart';

class AllFaqs extends StatelessWidget {
  AllFaqs({super.key});
  final List<FAQ> friendFaqs = [
    FAQ(
      faqHeading: 'How to search for friends and add them',
      faqDetails: 'Navigate to the search tab. Select the Friends tab. You can now search for friends using their username. To add a friend, send them a connection request and wait for their response.',
      videoPath: 'assets/videos/Connections_1.mp4'
    ),
    FAQ(
      faqHeading: 'Accepting/rejecting friend requests',
      faqDetails: 'To accept/reject friend requests, navigate to your profile. Click on the friends tab to see the friend requests.',
      videoPath: 'assets/videos/Connections_2.mp4'
    ),
  ];
  final List<FAQ> gameLibraryFaqs = [
    FAQ(
      faqHeading: 'How to search for friends and add them',
      faqDetails: 'Navigate to the search tab. Select the Friends tab. You can now search for friends using their username. To add a friend, send them a connection request and wait for their response.',
      videoPath: 'assets/videos/Connections_1.mp4'
    ),
    FAQ(
      faqHeading: 'Accepting/rejecting friend requests',
      faqDetails: 'To accept/reject friend requests, navigate to your profile. Click on the friends tab to see the friend requests.',
      videoPath: 'assets/videos/Connections_2.mp4'
    ),
  ];
  final List<FAQ> gameInfoFaqs = [
    FAQ(
      faqHeading: 'How to search for friends and add them',
      faqDetails: 'Navigate to the search tab. Select the Friends tab. You can now search for friends using their username. To add a friend, send them a connection request and wait for their response.',
      videoPath: 'assets/videos/Connections_1.mp4'
    ),
    FAQ(
      faqHeading: 'Accepting/rejecting friend requests',
      faqDetails: 'To accept/reject friend requests, navigate to your profile. Click on the friends tab to see the friend requests.',
      videoPath: 'assets/videos/Connections_2.mp4'
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        FaqSection(friendFaqs, 'Friends'),
        FaqSection(gameLibraryFaqs, 'Game Library'),
        FaqSection(gameInfoFaqs, 'Game Info'),
      ],
    );
    
  }
}