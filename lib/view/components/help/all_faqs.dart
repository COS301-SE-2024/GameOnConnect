import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';
import 'package:gameonconnect/view/components/help/faq_section.dart';

class AllFaqs extends StatelessWidget {
  AllFaqs({super.key});
  final List<FAQ> friendFaqs = [
    FAQ(
      faqHeading: 'How to search for users and send them a connection request',
      faqDetails: 'Navigate to the search tab. Select the Connections tab. You can now search for users using their username. To add a user, send them a connection request and wait for their response.',
      videoPath: '28XRoWQn7f0'
    ),
    FAQ(
      faqHeading: 'How to accept and reject connection requests',
      faqDetails: 'To accept/reject connection requests, navigate to your the search page. Click on the Connections tab and you will find a "Requests" button which will take you to your requests',
      videoPath: 'eGnxoB1NQ9U'
    ),
  ];
  final List<FAQ> gameLibraryFaqs = [
    FAQ(
      faqHeading: 'How to search for games',
      faqDetails: 'Navigate to the search tab. Select the Games tab. You can now search for a game.',
      videoPath: 'pxs2ywuFGxA'
    ),
    FAQ(
      faqHeading: 'How to sort the games',
      faqDetails: 'Navigate to the search tab. Click on the sort button and sort the games according to the criteria of your liking.',
      videoPath: 'MIITWjbGIyw'
    ),
    FAQ(
      faqHeading: 'How to filter the game library',
      faqDetails: 'Navigate to the search tab. Click on the filter button and filter the games according to the criteria of your liking.',
      videoPath: 'wEGlsIYjpug'
    ),
  ];
  final List<FAQ> gameInfoFaqs = [
    FAQ(
      faqHeading: 'How to view more information about a game',
      faqDetails: 'Click on a specific game on the game library. More information about the game will be displayed which will allow you to learn about more information regarding the game.',
      videoPath: 'hzJVWz03fW8'
    ),
    FAQ(
      faqHeading: 'How to share a game',
      faqDetails: 'Select a game you would like to share with others. Click on the share button. This will allow you to copy the link for sharing.',
      videoPath: 'u_4Z4dayaWM'
    ),
    FAQ(
      faqHeading: 'How to add a game to my "Want to play"',
      faqDetails: 'To add a specific game to your "Want to play" list, click on the game you would like to add in the game library. When you click on the "+ Want to play" button, the game will be added to your "Want to play"',
      videoPath: 'hD8JhI9Bk70'
    ),
    FAQ(
      faqHeading: 'How to add a game to my "My Games" list',
      faqDetails: 'To add a specific game to your "My Games" list, navigate to the specific game you would like to add and click on the "+ My Games" button ',
      videoPath: 'L0h67wfz-g8'
    ),
    FAQ(
      faqHeading: 'How to remove a game from your "Want to play',
      faqDetails: 'Navigate to your profile tab. Navigate to the "Want to play" section. Click on the game you would like to remove. This will take you to the game''s info page. Click on the remove button to remove the game from your "Want to play".',
      videoPath: 'WUE-Xsf8itE'
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView(
        children: [
          FaqSection(friendFaqs, 'Connections', Icons.diversity_1_outlined, const Key('Friends_section')),
          FaqSection(gameLibraryFaqs, 'Game Library', Icons.library_books_outlined, const Key('game_library_section')),
          FaqSection(gameInfoFaqs, 'Game Information', Icons.gamepad_outlined, const Key('game_information_section')),
        ],
      ),
    );
    
  }
}