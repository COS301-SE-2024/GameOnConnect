import 'package:flutter/material.dart';
import 'package:gameonconnect/model/help_M/faq_model.dart';
import 'package:gameonconnect/view/components/help/faq_section.dart';

class AllFaqs extends StatelessWidget {
  AllFaqs({super.key});
  final List<FAQ> friendFaqs = [
    FAQ(
      faqHeading: 'How to search for users and send them a connection request',
      faqDetails: 'Navigate to the search tab. Select the Connections tab. You can now search for users using their username. To add a user, send them a connection request and wait for their response.',
      videoPath: 'assets/videos/Connections_1.mp4'
    ),
    FAQ(
      faqHeading: 'How to accept and reject connection requests',
      faqDetails: 'To accept/reject connection requests, navigate to your profile. Click on the Connections tab to see the connection requests.',
      videoPath: 'assets/videos/Connections_2.mp4'
    ),
  ];
  final List<FAQ> gameLibraryFaqs = [
    FAQ(
      faqHeading: 'How to search for games',
      faqDetails: 'Navigate to the search tab. Select the Games tab. You can now search for a game.',
      videoPath: 'assets/videos/GameLibrary_1.mp4'
    ),
    FAQ(
      faqHeading: 'How to sort the games',
      faqDetails: 'Navigate to the search tab. Click on the sort button and sort the games according to the criteria of your liking.',
      videoPath: 'assets/videos/GameLibrary_2.mp4'
    ),
    FAQ(
      faqHeading: 'How to filter the game library',
      faqDetails: 'Navigate to the search tab. Click on the filter button and filter the games according to the criteria of your liking.',
      videoPath: 'assets/videos/GameLibrary_3.mp4'
    ),
  ];
  final List<FAQ> gameInfoFaqs = [
    FAQ(
      faqHeading: 'How to view more information about a game',
      faqDetails: 'Click on a specific game on the game library. More information about the game will be displayed which will allow you to learn about more information regarding the game.',
      videoPath: 'assets/videos/GameInfo_1.mp4'
    ),
    FAQ(
      faqHeading: 'How to share a game',
      faqDetails: 'Select a game you would like to share with others. Click on the share button. This will allow you to copy the link for sharing.',
      videoPath: 'assets/videos/GameInfo_2.mp4'
    ),
    FAQ(
      faqHeading: 'How to add a game to my "Want to play"',
      faqDetails: 'To add a specific game to your wishlist, click on the game you would like to add in the game library. When you click on the "Want to play" button, the game will be added to your "Want to play"',
      videoPath: 'assets/videos/GameInfo_3.mp4'
    ),
    FAQ(
      faqHeading: 'How to add a game to my "Currently playing" list',
      faqDetails: 'To add a specific game to your "Currently playing" list, navigate to the specifc game you would like to add and click on the "Add to currently playing" button to add the game to your "Currently playing" list.',
      videoPath: 'assets/videos/GameInfo_4.mp4'
    ),
    FAQ(
      faqHeading: 'How to remove a game from your "Want to play',
      faqDetails: 'Navigate to your profile tab. Navigate to the "Want to play" section. Click on the game you would like to remove. This will take you to the game''s info page. Click on the remove button to remove the game from your "Want to play".',
      videoPath: 'assets/videos/GameInfo_5.mp4'
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